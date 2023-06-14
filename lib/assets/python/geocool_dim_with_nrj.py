# pour éviter l'impression de warnings non bloquants :
import warnings  # included in python3
warnings.filterwarnings("ignore")
# pour gérer les arguments appeler avec le script .py
import sys
from types import SimpleNamespace

# gestion des dates : # included in python3
from datetime import datetime
# gestion des datas :
# needs pip install wheel and pip install pandas
import pandas as pd
# install pandas : commandes à taper dans ubuntu :
# "pip3 install pandas"

from scipy.optimize import curve_fit
# gestion des graphiques
# import plotly  #needs pip install plotly
# import plotly.express as px
import numpy as np
import json

# import os
# dir_path = os.path.dirname(os.path.realpath(__file__))
# print(dir_path)

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


# en cas d'utilisation depuis le terminal , décommanter ce bloc :
user_json_file_name = sys.argv[1]
temperatures_json_file_name = sys.argv[2]

with open(user_json_file_name) as user_json:
    user_data = json.load(user_json)

with open(temperatures_json_file_name) as temperatures:
    france_temperatures = json.load(temperatures)

# en cas d'exécution depuis l'appli décommenter cette ligne et commenter les précédentes :
# user_json = sys.argv[1]
# user_data = json.loads(user_json)

# temperatures = sys.argv[2]
# france_temperatures= json.loads(temperatures)

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
SPEED_MIN_QV_MAX = 1.5 # unit : m/s
SPEED_MAX_QV_MAX = 5.1 # unit : m/s
SPEED_MIN_QV_MIN = 0.95 # unit : m/s
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
},
{
    'slug': 'limons',
    'name': 'Limons',
    'density': 500,      # kg/m3
    'lambda_ground': 0.20,  # W/m.K
    'heat_capacity' :  3200     # J/kg.K
},
{
    'slug': 'calcaire',
    'name': 'Calcaire',
    'density': 1800,      # kg/m3
    'lambda_ground': 0.20,  # W/m.K
    'heat_capacity' :  3200     # J/kg.K
},
{
    'slug': 'argile_sec',
    'name': 'Argile Sec',
    'density': 1700,      # kg/m3
    'lambda_ground': 0.40,  # W/m.K
    'heat_capacity' : 850     # J/kg.K
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
    def __init__(self,name,diameter_int,e_p_mm,lambda_tube,id):
        self.name = name
        self.diameter_int = diameter_int/1000. #m
        self.diameter_ext =  self.diameter_int + 2*e_p_mm/1000
        self.radius_int = self.diameter_int/2. #m
        self.e_p_m = e_p_mm/1000 #m
        self.section = np.pi*(self.radius_int)**2 #m²
        self.lambda_tube = lambda_tube
        self.slope = 0.02
        self.nb_layers = 1
        self.id = id

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
                                    i_pipe['thermal_conductivity'],
                                    i_pipe['id']))

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


#####################################################################################
##### CLASSES POUR LES ETUDES ENERGETIQUES #############333
####################################################################################

# Meteo settings : récupère les données météo horaires dans le fichier d'entrée en fonction du numéro de département d'entrée
class Meteo_settings:
    def __init__(self,meteo_path_csv,departement):
        self.dpt=departement
        self.df = pd.read_csv(meteo_path_csv, low_memory=False).drop([0],axis=0) # df stands for "dataframe"
        self.df2= self.df[self.dpt]
        # dataT = hourly_temperature °C :
        self.dataT=np.array(self.df2,dtype=float)
        # self.i = [index  for index in range(0,len(self.dataT))]
        # plt.plot(self.i,self.dataT)

class import_VMC_planning:
    def __init__(self,VMC_path_csv,first_day) :
        #self.df=pd.read_excel(VMC_path_csv) # read xlsx files need : pip install openpyxl*
        # fichier d'entrée un csv de % du débit max
        self.VMC_path_csv=VMC_path_csv
        self.first_day=first_day

        self.VMC_file=pd.read_csv(VMC_path_csv)
        # on retire la première colonnes "heure"
        self.VMC_file=self.VMC_file.drop('Heure',axis=1)

        # conversion en array :
        self.VMC_hebdo=np.array(self.VMC_file,dtype=float)
        self.VMC_8760=np.zeros(8760)
        # n : nombre d'heure par jour
        n = 24
        # à partir du planning VMC hebdomadaire, création d'une liste de valeurs de débits de VMC sur l'année
        for k in range (52): # 52 weeks in a year
            for i in range (7): # 7 days in a week
                if i+(self.first_day-1)>6:
                    self.VMC_8760[i*n+k*(n*7):((i+1)*n)+k*(n*7)]= self.VMC_hebdo[:,7-(i+ self.first_day-1)]
                else :
                    self.VMC_8760[i*n+k*(n*7):((i+1)*n)+k*(n*7)]= self.VMC_hebdo[:,i]

        # une année de 8760 heures = 52 semaines + un jour : il faut donc ajouter les 24 dernières heures de l'année
        self.VMC_8760[8736:]= self.VMC_hebdo[:, self.first_day-1]
        # sauvegarde en txt des données de ventilation
        # np.savetxt('VMC_8760.txt',self.VMC_8760,fmt='%1.2f')

class Datetohour: # Convert a string "dd/mm/yy" into hour number within the year
   def __init__(self,user_date):
      self.user_date=user_date

      #self.user_year    = datetime.strptime("19/11/21", "%d/%m/%y").year
      self.user_year    = datetime.strptime(self.user_date, '%d/%m/%y').year
      self.user_month   = datetime.strptime(self.user_date, "%d/%m/%y").month
      self.user_day     = datetime.strptime(self.user_date, "%d/%m/%y").day

      # Create the Timestamp object
      # ts.timestamp() return the number of seconds since a certain period
      self.ts = pd.Timestamp(year = self.user_year, month = self.user_month, day = self.user_day,
               hour = 0, second = 0, tz = 'Europe/Berlin')

      self.ts2 = pd.Timestamp(year = self.user_year, month = 1, day = 1,
               hour = 0, second = 0, tz = 'Europe/Berlin')
      self.hourofyear=int((self.ts.timestamp()-self.ts2.timestamp())/3600)

# création d'un arr [heure début, heure de fin]
class Set_heating_period:
    def __init__(self,start_date,end_date):
        self.heating_period=np.array([Datetohour(start_date).hourofyear,Datetohour(end_date).hourofyear])
        # print("heating period (début, fin)",self.heating_period)

# CALCUL DES PERFORMANCE ENERGETIQUES ANNUELLES D'UN SYSTEME :
class AnnualPerformance:
    def __init__(self,well,meteo,heating_period,depth,Qv,bypass,VMC_planning,L_user=0):
        # Données météo du site :
        self.meteo = meteo # meteo is an array of 8760 floats numbers
        # systeme puits-clim étudié
        self.well_system = well
        self.pipe=self.well_system.pipe
        self.nb_tubes=self.well_system.nb_branch
        # début & fin des saison hiver et été
        self.heating_period=heating_period # type : np.array [heure début, heure fin]
        self.winter_period = [self.heating_period[0],self.heating_period[1]]
        self.summer_period = [self.heating_period[1]+1,self.heating_period[0]-1]
        self.VMC_planning=VMC_planning
        # vérification des heures de début et fin des simu hiver et été
        # print("annual_perf-winter_period",self.winter_period)
        # print("annual_perf-summer_period",self.summer_period)

        #prodondeur d'enfouissement étudiée :
        self.profondeur=depth

        # débit de ventilation étudié
        self.Qv=Qv # Qv = array of hourly air flow
        self.VMC_ON=np.where(self.VMC_planning>0,1,0)

        # type de by-pass considéré
        self.bp_type = bypass

        # création d'un database Text
        self.df = pd.DataFrame(data=self.meteo,columns = ['Text'])

        # Longueur de tube étudiée :
        # si une longueur est renseignée par l'utilisateur on utilise cette donnée, sinon Lo
        if L_user > 0:
            self.L_user = L_user
        else:
            self.L_user = self.well_system.L_0

        # print("\n###############################################")
        # print("Cas étudié",self.well_system.pipe.name,np.round(self.L_user,1),"m / ", self.nb_tubes ,"branches - ","Profondeur : ",self.profondeur,"m")
        # print("#################################################")

    # fonction mysin : création d'un sinusoide selon Tmoy, Amplitude et phase
    def my_sin(self,t, Tm, Ta, phase):
        return Tm - Ta*np.sin( (t+phase)  * 2 * np.pi / (365*24) ) # vh : je pense qu'il faut passer en jours pour clarifier les graphiques

    # Fonction de calcul de la température du sol à la profondeur étudiée
    def temperature_sol(self,t, x, g, Tm,Tdecalage, alpha, T0):
        omega = 2*np.pi/(365*24)
        return Tm + g*x - T0*np.exp(-x*np.sqrt(omega/(2*alpha)))*np.cos( omega*(t-Tdecalage) - x*np.sqrt(omega/(2*alpha)) )

    def stats_on_hourlyT(self,dataT):
        Tmean=np.average(dataT)
        # nb_heures Text <= 0°C
        nb_heure_inf0= int(np.sum(np.where(dataT<=0,1,0)))
        # nb_heures Text <= 5°C
        nb_heure_inf5=int(np.sum(np.where(dataT<=5,1,0)))
        nb_heure_sup28=int(np.sum(np.where(dataT>=28,1,0)))
        Tmin = np.min(dataT)
        Tmax = np.max(dataT)
        return {"Tmean":Tmean,"nb_hours_inf_0":nb_heure_inf0, "nb_hours_inf_5":nb_heure_inf5,"nb_hours_sup_28":nb_heure_sup28, "Tmin":Tmin, "Tmax":Tmax}

    def computeStats(self):
        a = self.stats_on_hourlyT(self.meteo)
        # print(f"Tmean_ext:{np.round(a[0],2)}°C","- nb heures <0°C:",a[1],"- nb_heure <5°C :",a[2], "nb_heures > 28°C:",a[3])
        # def DJU(self,dataT):
        weather_data = {
            "Text_mean_degC": a["Tmean"],
            "nb_hours_inf_zero": a["nb_hours_inf_0"],
            "nb_hours_sup_vingthuit": a["nb_hours_sup_28"],
            "Text_min": a["Tmin"],
            "Text_max": a["Tmax"]
        }
        return weather_data

    def computeGroundTemperature(self):
    #version initiale

        Text_data = self.meteo # dropna : to drop NAN or NULL values, here seems to be useless
        # print("test_vh_Text_data",Text_data)
        t = [index  for index in range(0,len(Text_data))]
        t = np.nan_to_num(t)
        # plt.plot(t/24,Text_data)

        guess_Ta = 3*np.std(Text_data)/(2**0.5)
        guess_phase = 0
        guess_Tm = np.mean(Text_data)
        # print( "guess_Ta:", guess_Ta, "guess_phase:",guess_phase,"guess_Tm:", guess_Tm )
        p0=[ guess_Tm, guess_Ta, guess_phase]

        # now do the fit
        fit = curve_fit(self.my_sin, t, Text_data, p0=p0)
        # print("Tm :: {:.2f} °C".format(fit[0][0]))
        # print("Ta :: {:.2f} °C".format(fit[0][1]))
        # print("Phase_h :: {:.2f} h".format(fit[0][2]))
        # print("Phase_jr ::{:.2f} jr".format(fit[0][2]/24))

        # recreate the fitted curve using the optimized parameters
        data_fit = self.my_sin(t, *fit[0])
        # plt.plot(t/24,data_fit)

        T_m = fit[0][0]
        T_min = np.min(data_fit)
        T_max = np.max(data_fit)

        # list of depth for burried tubes under ground
        # arr_depth = [0,0.5,1,1.5,2,2.5,3]
        # Diffusivité du sol (m²/h) (car la fréquence de self.temperature_sol est en heures )
        alpha=self.well_system.ground.alpha*3600
        # Température moyenne annuelle
        T_0 = 0.5*(T_max - T_min)

        self.Tsol_prof=self.temperature_sol(t,self.profondeur,0,T_m,np.argmin(data_fit),alpha,T_0 )

    #Temperature de sortie de puits
    def wellOutlet_Temp(self):
        self.df["Ts_puits"] = 0
        self.Tout = np.array(self.df["Ts_puits"],dtype=float)
        Text      = self.meteo
        self.hourly_L_0 = np.zeros(8760)

        for h in range(8760):
            # si pas de ventilation prévue alors pas de calcul : Lo = 0
            if self.VMC_planning[h]==0:
                self.hourly_L_0[h]=0
            # sinon calcul de Lo à partir de "well-system"
            else:
                self.hourly_L_0[h]=Well_system(self.pipe,self.nb_tubes,self.Qv*self.VMC_planning[h]/self.nb_tubes,self.well_system.ground).L_0

        # np.savetxt('HOURLY_Lo.txt',self.hourly_L_0,fmt='%1.2f')

        self.Tout=np.where(self.hourly_L_0 == 0, self.Tsol_prof,(self.Tsol_prof+(Text-self.Tsol_prof)*(np.exp(-self.L_user/self.hourly_L_0))))
        # np.savetxt('Tout_pc.txt',self.Tout,fmt='%1.2f')
        self.Tout_av=np.round(np.average( self.Tout),1)
        # print("Tout_moyen",self.Tout_av,"°C")

        #return self.Tout

    def setWarmingPeriod(self):
        self.df['warming_periode'] = 0
        if self.winter_period[0]>self.winter_period[1]:
            self.df['warming_periode'].loc[0:self.winter_period[1]] = 1
            self.df['warming_periode'].loc[self.winter_period[0]:] = 1
        else :
            self.df['warming_periode'].loc[self.winter_period[0]:self.winter_period[1]] = 1
        # print(self.df['warming_periode'])
        self.WarmingPeriod=np.array(self.df["warming_periode"],dtype=float)

    def setCoolingPeriod(self):
        self.df['cooling_period'] = 0
        if self.summer_period[0]>self.summer_period[1]:
            self.df['cooling_period'].loc[0:self.summer_period[1]] = 1
            self.df['cooling_period'].loc[self.summer_period[0]:] = 1
        else :
            self.df['cooling_period'].loc[self.summer_period[0]:self.summer_period[1]] = 1
        # print(self.df['warming_periode'])
        self.CoolingPeriod=np.array(self.df['cooling_period'],dtype=float)

    def computeWinterGain(self):
        Tint = 20
        Heating_SF_hour=(self.Qv*self.VMC_planning*0.3455*self.WarmingPeriod*(Tint-self.meteo))
        Heating_SF=np.round(np.sum(Heating_SF_hour)/1000,0)
        Text_min=np.min(self.meteo)

        DeltaT_gain=np.where(self.Tout>=Tint,self.Tout-Tint,0)

        # définition du by-pass : =0 si le puits est bypassé sinon =1
        if self.bp_type==0:
            Bypass_winter = np.ones(8760)
        else :
            Bypass_winter=np.where(self.Tout<self.meteo,0,1)

        Heating_PC_hour=self.Qv*self.VMC_planning*0.3455*self.WarmingPeriod*Bypass_winter*(Tint-self.Tout)
        Heating_PC=np.round(np.sum(Heating_PC_hour)/1000,0)
        duree_fonctionnement_winter=np.sum(self.WarmingPeriod*Bypass_winter*self.VMC_ON)

        # outputs sur efficacité hivernale
        self.Tout_min=np.round(np.min(self.Tout),1)
        self.WinterGain_PC=Heating_SF-Heating_PC
        self.Winter_efficiency=np.round(1-(Heating_PC/Heating_SF),2)

        self.WinterGainTmin=np.abs(self.Tout_min-Text_min)
        meanWinterGain=np.round(self.WinterGain_PC/duree_fonctionnement_winter,1)
        maxWinterGain=np.round(np.max(Heating_SF_hour-Heating_PC_hour)/1000,1)
        mean_linear_winter_gain_wml = np.round(meanWinterGain*1000/(self.nb_tubes*self.L_user),0)
        max_linear_winter_gain_wml = np.round(maxWinterGain*1000/(self.nb_tubes*self.L_user),0)

        winter_data = {
        'studied_depth_m': self.profondeur,
        "winter_heating_needs_PC_kwh": Heating_PC,
        "total_winter_gain_vs_SF_kwh": self.WinterGain_PC,
        "mean_winter_gain_kw": meanWinterGain,
        "mean_linear_winter_gain_wml": mean_linear_winter_gain_wml,
        "max_winter_gain_kw": maxWinterGain,
        "max_linear_winter_gain_wml": max_linear_winter_gain_wml,
        "winter_Tout_min_degC": self.Tout_min,
        "winter_Tout_min_gain_degC": self.WinterGainTmin,
        "winter_number_of_hours_PC": duree_fonctionnement_winter
        }

        return winter_data

        # print('Winter :: @ ',self.profondeur,"m")
        # print("Heating air _SF", Heating_SF, "kWh")
        # print("Heating air_PClim",Heating_PC, "kWh")
        # print("Gain Energetique PC:", self.WinterGain_PC,"kWh")
        # print("Puissance Moyenne de récupération Hiver :", meanWinterGain,"KW")
        # print("Puissance Moyenne Linéaire de récupération Hiver :",  np.round(meanWinterGain*1000/(self.nb_tubes*self.L_user),0),"W/ml")
        # print("Puissance MAX de récupération Hiver :",  maxWinterGain,"KW")
        # print("Puissance MAX Linéaire de récupération Hiver :", np.round(maxWinterGain*1000/(self.nb_tubes*self.L_user),0),"W/ml")

        # print("Tmin soufflé (hiver) : ",self.Tout_min,"°C")
        # print("gain sur Tmin hiver : ",self.WinterGainTmin,"°C")
        # print("Efficacité_hiver:",self.Winter_efficiency)
        # print("durée_fonctionnement_hiver",duree_fonctionnement_winter,"heures")
        # # return(self.WinterGain_PC)

    def computeSummerGain(self):
        Tint_summer = 26
        if self.bp_type==0:
            Bypass_summer= np.ones(8760)
        else :
            Bypass_summer=np.where(self.Tout>self.meteo,0,1)

        Cooling_SF_hour=(self.Qv*self.VMC_planning*0.3455*self.CoolingPeriod*(Tint_summer-self.meteo))
        Cooling_SF=np.round(np.sum(Cooling_SF_hour)/1000,0)

        Cooling_PC_hour=self.Qv*self.VMC_planning*0.3455*self.CoolingPeriod*Bypass_summer*(self.Tout-self.meteo)
        self.SummerGain_PC=int(np.sum(Cooling_PC_hour)/1000)
        duree_fonctionnement_summer=np.sum(self.CoolingPeriod*Bypass_summer*self.VMC_ON)
        # Températures max :
        self.Tout_max=np.round(np.max(self.Tout),1)
        Text_max=np.round(np.max(self.meteo),1)
        self.SummerGainTmax=np.round(np.abs(self.Tout_max-Text_max),1)

        # Gain max et moyen (kW) et linéaire
        meanSummerGain =np.round(self.SummerGain_PC/duree_fonctionnement_summer,1)
        maxSummerGain = np.round(np.min(Cooling_PC_hour)/1000,1) #coolingPC = chiffres négatifs
        mean_linear_summer_gain_wml = np.round(meanSummerGain*1000/(self.nb_tubes*self.L_user),0)
        max_linear_summer_gain_wml = np.round(maxSummerGain*1000/(self.nb_tubes*self.L_user),0)

        summer_data = {
            'studied_depth_m': self.profondeur,
            "total_summer_gain_vs_SF_kwh": {
                'value': self.SummerGain_PC,
                'units': "kWh"
            },
            "mean_summer_gain_kw": {
                'value': meanSummerGain,
                'units': "kW"
            },
            "mean_linear_summer_gain_wml":{
                'value': mean_linear_summer_gain_wml,
                'units': "W/ml"
            },
            "max_summer_gain_kw":{
                'value': maxSummerGain,
                'units': "kW",
            },
            "max_linear_summer_gain_wml":{
                'value': max_linear_summer_gain_wml,
                'units': "W/ml"
            },
            "summer_Tout_max_degC":{
                'value': self.Tout_max,
                'units': "deg Celcius",
            },
            "summer_Tout_max_gain_degC": {
                'value':self.SummerGainTmax,
                'units':"deg Celcius",
            },
            "summer_number_of_hours_PC":{
                'value':duree_fonctionnement_summer,
                'units':"hours",
            }
        }
        return summer_data

        # print('Summer :: @ ',self.profondeur,"m")
        # print("Cooling air _SF @ 26°C:", Cooling_SF, "kWh")
        # print("Gain énergétique PC été",self.SummerGain_PC, "kWh")
        # print("Puissance Moyenne de récupération été :", meanSummerGain,"KW")
        # print("Puissance Moyenne Linéaire de récupération été :",  np.round(meanSummerGain*1000/(self.nb_tubes*self.L_user),0),"W/ml")
        # print("Puissance MAX de récupération été :",  maxSummerGain,"KW")
        # print("Puissance MAX Linéaire de récupération été :", np.round(maxSummerGain*1000/(self.nb_tubes*self.L_user),0),"W/ml")
        # print("Tmax soufflé (été) : ",self.Tout_max,"°C")
        # print("gain sur Tmax été : ",self.SummerGainTmax,"°C")
        # print("durée_fonctionnement_été",duree_fonctionnement_summer,"heures")

##########################################################################################
#### DONNEES UTILISATEUR EN ENTREE DU CALCUL
##########################################################################################

# DEPARTEMENT DE L'UTILISATEUR
user_departement = studied_building['department'].split(' -')[0]
available_ground_area = studied_building['available_area']

# Fichier météo adapté au département:
# avec fichier .csv :
# meteo = Meteo_settings('./meteo/TW_Bilan_Temperatures2.csv',user_departement)
# Text = meteo.dataT
# avec json :
Text = np.zeros(8760)
for index,elt in enumerate(france_temperatures):
    # print(index,elt["44"])
    Text[index]= elt[user_departement]

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
Qv_min = 0.35*Qv_max # ce débit réduit sert à la sélection des systèmes adaptés :
# il faut que des conditions de vitesse soient respectées sur Qv_max et Qv_min

# Débit de ventilation horaire pour la simulation énergétique :
# liste horaire de réduction des débits par rapport au débit max
# cas simplifié :
VMC = np.ones(8760)
# VMC = import_VMC_planning('./RNA_HIVER.csv',d).VMC_8760

# à termes il faudra trouver un moyen de faire remplir à l'utilisateur une table horaire hebdo
# de réduction du débit par rapport au débit max

# Surface du bâtiment
Sbat = studied_building["area"]
# Sbat = 2400 # m²
# si pas connue : si bureaux : Sbat = 10* débit/25  ; si maison : Sbat = 25* Qv/30

# Nombre de branches étudiées"
max_branch = np.floor((Qv_max/200)).astype(int)+1
# à choisir par l'utilisateur : il faut lui indiquer un paramètre du type :"Qv_max (m3/h) / 500"
nb_branch = range(1,max_branch)

# APPEL DE LA FONCTION DE SELECTION DES TUBES ADAPTES
arr_well_system = Working_wells(Qv_min,Qv_max,selected_pipes_db,nb_branch,user_ground).arr_well_system

# ################################################################
# # PARTIE DU PROGRAMME POUR LE CALCUL DES PERFORMANCES ANNUELLES
# ################################################################
# par défaut on étudie tous les systèmes préalablement sélectionnés dans arr_well_system

# sélection des profondeurs d'enfouissement des tubes dans le sol
arr_prof = [2] #m

# définition de la période de chauffage par l'utilisateur
start_heating = "01/10/22"
stop_heating = "15/04/22"
# calcul de la période de chauffage pour intégration dans les calculs
heating_period = Set_heating_period(start_heating,stop_heating).heating_period

# Température du bâtiment en hiver en occupation
Tint_on = 20 #°C
# Température du bâtiment en hiver en inoccupation (réduit de nuit / vacances...)
Tint_off = 17 #°C
# Choix d'une strategie de by-pass du puits climatique:
Bypass = 0 # Bypass = 0 : pas de bypass, sinon si Bypass= 1 : méthode simple sur comparaison Text et Tout_pc


result_wells = []
for i_well in arr_well_system:
    # Impression des caractéristiques des systèmes préconisés
    # print(i_well.qv_tube_max*i_well.nb_branch,"m³/h  ", i_well.pipe.name,"  ",i_well.nb_branch,"branche(s)  ",
    #       "v@Qvmax:",np.round(i_well.speed_max,1),"m/s  ", "v@Qvmin:",np.round(i_well.speed_min,1),"m/s  " ,
    #       "Long Unitaire Conseillée(RAGE):",np.round(i_well.L_0,1),"m  ", "Longueur tot conseillée:",np.round(i_well.L_total,1),'m  ',"surf. terrain",np.round(i_well.occupied_surface,1),'m²')
    if i_well.L_0 < 100 and i_well.occupied_surface < available_ground_area:
        i_result = {
            "pipe_id": i_well.pipe.id,
            "pipe_data": i_well.pipe,
            "nominal_flow_rate": i_well.qv_tube_max*i_well.nb_branch,
            "pipe_name": i_well.pipe.name,
            "external_diameter": i_well.pipe.diameter_ext,
            "proposed_number_of_pipes": i_well.nb_branch,
            "nominal_speed": np.round(i_well.speed_max,1),
            "proposed_length_lo": np.round(i_well.L_0,1),
            "proposed_total_length": np.round(i_well.L_total,1),
            "occupied_area": np.round(i_well.occupied_surface,1)
        }
        for p in arr_prof:
            perf = AnnualPerformance(i_well,Text,heating_period,p,Qv_max,Bypass,VMC)
            i_weather_stats = perf.computeStats()
            # print("weather_stats",i_weather_stats)
            perf.computeGroundTemperature()
            perf.wellOutlet_Temp()
            perf.setWarmingPeriod()
            perf.setCoolingPeriod()
            i_winter_perf = perf.computeWinterGain()
            i_summer_perf = perf.computeSummerGain()
            # print('winter_perf',i_winter_perf)
            # print('summer_perf',i_summer_perf)
            i_result["weather_stats"] = i_weather_stats
            i_result["winter_perf"] = i_winter_perf
            i_result["summer_perf"] = i_summer_perf
        result_wells.append(i_result)

result = Result()
result.selected_wells = result_wells
result.number_of_tests = int(max_branch * len(samples_pipes))
result.number_wells_found = int(len(result_wells))
result.department = user_departement

# with open("result_file.json", "w") as json_file:
#      json.dump(result, json_file, default=toJson, indent=4, sort_keys=False)

jsonResult = json.dumps(result,  default=toJson, indent=4, sort_keys=True)
# print ('------------------------------------------')
# print("number of cases tested:", max_branch * len(samples_pipes))
# print("number of wells results:", len(result_wells))
print (jsonResult)
