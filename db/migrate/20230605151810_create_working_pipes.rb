class CreateWorkingPipes < ActiveRecord::Migration[7.0]
  def change
    create_table :working_pipes do |t|
      t.references :project, null: false, foreign_key: true
      t.references :pipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
