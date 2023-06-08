# pour gérer les arguments appeler avec le script .py
import sys
from types import SimpleNamespace

# import pandas as pd # needs pip install wheel and pip install pandas
# import plotly  #needs pip install plotly
# import plotly.express as px
import numpy as np
import json

# import scipy.optimize
# import pylab as plt
# from scipy.optimize import curve_fit
# from datetime import datetime
# from pandas import read_excel

def toJson(obj):
    return obj.__dict__

# Result = résultats qui seront exportés en JSON
class Result:
    def __init__(self):
        pass

# Import des données d'entrée ligne de commande
# print('Number of arguments:', len(sys.argv), 'arguments.')

# print('Argument List:', sys.argv)
user_json = sys.argv[1]


# with open(user_jsonfile_name) as user_json:
user_data = json.loads(user_json)

samples_pipes = user_data['pipes']
# print(samples_pipes)

studied_building = user_data['building_data']
# print(studied_building)

studied_ground = user_data['ground']
# print(arr_ground)

# # Parse JSON into an object with attributes corresponding to dict keys.
# x = json.loads(data, object_hook=lambda d: SimpleNamespace(**d))
# print(x.name, x.hometown.name, x.hometown.id)


###############################################################
##### DEBUT DU PROGRAMME DE CALCUL DE DIMENSIONNEMENT #########
###############################################################
# # List of global variables needed for sizing
SPEED_MIN_QV_MAX = 2 # unit : m/s
SPEED_MAX_QV_MAX = 5 # unit : m/s
SPEED_MIN_QV_MIN = 1 # unit : m/s
SPEED_MAX_QV_MIN = 4 # unit : m/s

# List of Soils:
arr_ground = [{
    'slug': 'argile_humide_rt2012',
    'name': 'Argile Humide_RT2012',
    'density': 1800,
    'lambda_ground': 1.45,
    'heat_capacity' :  1340
},
{
    'slug': 'sable_humide_rt2012',
    'name': 'Sable Humide RT2012',
    'density': 1500,     # kg/m3
    'lambda_ground': 1.88,  # W/m.K
    'heat_capacity' :  1200     # J/kg.K
},
{
    'slug': 'sable_sec_rt2012',
    'name': 'Sable Sec RT2012',
    'density': 1500,     # kg/m3
    'lambda_ground': 0.70,  # W/m.K
    'heat_capacity' :  920      # J/kg.K
},
{
    'slug': 'tourbe',
    'name': 'Tourbe',
    'density': 500,      # kg/m3
    'lambda_ground': 0.20,  # W/m.K
    'heat_capacity' :  3200     # J/kg.K
}
]

# Définition des ground settings :
class Ground_settings:
    def __init__(self, ground_type_slug,rho=0,cp=0,lambda_ground=0):
        self.rho = rho
        self.cp= cp
        self.lambda_ground=lambda_ground
        if len(ground_type_slug)>0:
            self.rho, self.cp, self.lambda_ground = self.setup_ground(ground_type_slug) #ground_type: 'argile_humide'
        # calcul of soil diffusivity
        self.alpha = self.lambda_ground / (self.rho*self.cp) # m²/s
        self.cv = self.rho * self.cp # J/(m³.K)
        # durée d'un jour en secondes :
        self.Tjour = 86400 #secondes
        # djour = profondeur de pénétration de l'onde thermique dans le sol
        self.djour = np.sqrt(self.alpha*self.Tjour/np.pi)

    def setup_ground(self,slug):
        for i in arr_ground:
            if i['slug'] == slug:
                return i['density'],i['heat_capacity'],i['lambda_ground']
    def info(self):
        for var in vars(self):
            print(getattr(self, var))

class Pipe_settings:
    def __init__(self,name,diameter_int,e_p_mm,lambda_tube):
        self.name = name
        self.diameter_int = diameter_int/1000. #m
        self.diameter_ext =  self.diameter_int + 2*e_p_mm/1000
        self.radius_int = self.diameter_int/2. #m
        self.e_p_m = e_p_mm/1000 #m
        self.section = np.pi*(self.radius_int)**2 #m²
        self.lambda_tube = lambda_tube
        self.slope = 0.02
        self.nb_layers = 1

    def surface_int(self,pipe_length):
        return 2*np.pi*self.radius_int*pipe_length

class Air_settings:
    def __init__(self):
        self.rho_air = 1.24 # kg/m³
        self.cp_air = 1003 # J/kg.K
        self.lambda_air = 0.025 # W/m.K
        self.mu_air = 1.78E-05

# Well_system : objet prenant en entrée :
# - pipe
# - nb_branch
# - ground
# -
class Well_system:
    def __init__(self,pipe,nb_branch,qv_tube_max,ground,qv_tube_min=0):
        self.atmo = Air_settings()
        self.pipe = pipe
        self.nb_branch = nb_branch
        self.qv_tube_max = qv_tube_max
        if qv_tube_min>0:
            self.qv_tube_min = qv_tube_min
        else:
            self.qv_tube_min = qv_tube_max*0.3
        self.ground = ground
        self.speed_max = self.qv_tube_max/(3600*self.pipe.section)
        self.speed_min = self.qv_tube_min/(3600*self.pipe.section)
        self.Re = self.Re_init()
        self.Pr = self.Pr_init()
        self.Nu = self.Nu_init()
        self.ha = self.coeff_convectif_airtube_init()
        self.hc = self.ech_therm_conduction()
        self.hs = self.coeff_diff_soltube()
        self.R_th = self.calc_R_th()
        self.h = 1/self.R_th
        self.L_0 = self.caracteristic_length()
        self.L_total = self.L_0 * self.nb_branch
        self.diff_drop = self.L_0*self.pipe.slope
        self.occupied_surface = self.computeOccupiedSurface()

    def Re_init(self):
        return self.atmo.rho_air * self.speed_max * self.pipe.diameter_int / self.atmo.mu_air
    def Pr_init(self):
        return self.atmo.mu_air * self.atmo.cp_air / self.atmo.lambda_air
    def Nu_init(self):
        return 0.023*(self.Re**0.8)*(self.Pr**0.33)
    def coeff_convectif_airtube_init(self):
        return self.Nu * self.atmo.lambda_air / self.pipe.diameter_int
    def ech_therm_conduction(self):
        return self.pipe.lambda_tube/self.pipe.e_p_m
    def coeff_diff_soltube(self):
        return self.ground.lambda_ground/(self.pipe.radius_int*np.log(1+self.ground.djour/self.pipe.radius_int))
    def calc_R_th(self):
        return 1/self.ha + 1/self.hs +1/self.hc
    def caracteristic_length(self):
        return (self.atmo.rho_air*self.atmo.cp_air/4)*(self.speed_max * self.pipe.diameter_int/self.h)
    def computeOccupiedSurface(self):
        return 4*self.pipe.diameter_ext*self.nb_branch*self.L_0

# Working_wells : permet de sortir les systèmes qui "fonctionnent"
class Working_wells:
     def __init__(self,qvmin,qvmax,selected_pipes_db,nb_branch,ground):
        self.selected_pipes=selected_pipes_db
        self.nb_branch=nb_branch
        self.qv_max=qvmax
        self.qv_min=qvmin
        self.pipe = []
        self.arr_well_system = []
        self.ground=ground

        #Calcul du débit unitaire

        # Creation of pipe_settings collections (instances)
        for i_pipe in self.selected_pipes:
            self.pipe.append(Pipe_settings(i_pipe['name'],
                                    i_pipe['diameter_int'],
                                    i_pipe['thickness_mm'],
                                    i_pipe['thermal_conductivity']))

        for j_pipe in self.pipe:
            #print('name',j_pipe.name)
            for i_branch in self.nb_branch:
                #calcul du débit unitaire par tube
                qv_tube_max = self.qv_max/i_branch
                #calcul de la vitesse maw par tube :
                pipe_speed_max = qv_tube_max/(3600*j_pipe.section)
                #print('pipe_speed_max',pipe_speed_max)
                qv_tube_min = self.qv_min/i_branch
                pipe_speed_min = qv_tube_min/(3600*j_pipe.section)
                #print('pipe_speed_min',pipe_speed_min)

                # vérification des conditions à respecter sur la vitesse dans les pipes :
                if pipe_speed_max > SPEED_MIN_QV_MAX and  pipe_speed_max < SPEED_MAX_QV_MAX:
                    if pipe_speed_min > SPEED_MIN_QV_MIN and  pipe_speed_min < SPEED_MAX_QV_MIN:
                        self.arr_well_system.append(Well_system(j_pipe, i_branch,qv_tube_max,self.ground,qv_tube_min))

        #print(arr_well_system)

        # # calcul de la longueur préconisée
        # for i_well in self.arr_well_system:
        #     print(i_well.qv_tube_max*i_well.nb_branch,"m³/h  ", i_well.pipe.name,"  ",i_well.nb_branch,"branche(s)  ","v@Qvmax:",np.round(i_well.speed_max,1),"m/s  ", "v@Qvmin:",np.round(i_well.speed_min,1),"m/s  " ,"Long Unitaire Conseillée(RAGE):",np.round(i_well.L_0,1),"m  ", "Longueur tot conseillée:",np.round(i_well.L_total,1),'m  ',"surf. terrain",np.round(i_well.occupied_surface,1),'m²')


# DEPARTEMENT DE L'UTILISATEUR
user_departement = studied_building['department']

# Fichier météo adapté au département:
# meteo = Meteo_settings('./meteo/TW_Bilan_Temperatures2.csv',user_departement)
# Text = meteo.dataT

# SOL DE L'UTILISATEUR
user_ground_type = studied_ground['slug']
# user_ground = Ground_settings('argile_humide_rt2012')
user_ground = Ground_settings(user_ground_type)

# CHOIX DES PUITS ETUDIES
selected_pipes_db = samples_pipes



# CHOICE OF PROJECT AIR FLOW :
d = 1 # premier jour de l'année : si d = 1 premier jour = lundi


# Débit max d'entrée : qv_max
# il s'agit du débit max dimensionnant du projet
Qv_max = studied_building['nominal_flow_rate']
# 6000 #m³/h # donner une info sur le débit max type : maison 30*(Nb_occ+2)
Qv_min = 0.3*Qv_max # ce débit réduit sert à la sélection des systèmes adaptés :
# il faut que des conditions de vitesse soient respectées sur Qv_max et Qv_min

# Débit de ventilation horaire pour la simulation énergétique :
# liste horaire de réduction des débits par rapport au débit max
# VMC = import_VMC_planning('./planningVMC/RNA_HIVER.csv',d).VMC_8760
# à termes il faudra trouver un moyen de faire remplir à l'utilisateur une table horaire hebdo
# de réduction du débit par rapport au débit max

# Nombre de branches étudiées"

max_branch = np.floor((Qv_max/200)).astype(int)+1
 # à choisir par l'utilisateur : il faut lui indiquer un paramètre du type :"Qv_max (m3/h) / 500"
nb_branch = range(1,max_branch)

# APPEL DE LA FONCTION DE SELECTION DES TUBES ADAPTES
arr_well_system = Working_wells(Qv_min,Qv_max,selected_pipes_db,nb_branch,user_ground).arr_well_system

result_wells = []
for i_well in arr_well_system:
    # Impression des caractéristiques des systèmes préconisés
    # print(i_well.qv_tube_max*i_well.nb_branch,"m³/h  ", i_well.pipe.name,"  ",i_well.nb_branch,"branche(s)  ",
    #       "v@Qvmax:",np.round(i_well.speed_max,1),"m/s  ", "v@Qvmin:",np.round(i_well.speed_min,1),"m/s  " ,
    #       "Long Unitaire Conseillée(RAGE):",np.round(i_well.L_0,1),"m  ", "Longueur tot conseillée:",np.round(i_well.L_total,1),'m  ',"surf. terrain",np.round(i_well.occupied_surface,1),'m²')
    i_result = {
        "pipe_data": i_well.pipe,
        "sizing_flow_rate": i_well.qv_tube_max*i_well.nb_branch,
        "pipe_name": i_well.pipe.name,
        "external_diameter": i_well.pipe.diameter_ext,
        "number_of_branches": i_well.nb_branch,
        "nominal_speed_per_branch": np.round(i_well.speed_max,1),
        "minimal_unit_length_adviced_RAGE": np.round(i_well.L_0,1),
        "total_length_adviced": np.round(i_well.L_total,1),
        "needed_area_m2": np.round(i_well.occupied_surface,1)
    }
    result_wells.append(i_result)

result = Result()
result.selected_wells = result_wells
# result.number_max_of_branches = max_branch
# result.number_of_simulations = max_branch * len(samples_pipes)

jsonResult = json.dumps(result,  default=toJson, indent=4, sort_keys=True)
# print ('------------------------------------------')
print (jsonResult)


with open("result_file.json", "w") as json_file:
     json.dump(result, json_file, default=toJson, indent=4, sort_keys=False)
