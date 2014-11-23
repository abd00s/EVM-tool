class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :start_date
      t.date :end_date
      t.integer :project_id

      t.timestamps
    end
  end
end
