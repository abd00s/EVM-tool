class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :period_number
      t.integer :schedule_id
      t.float :bcws
      t.float :bcwp
      t.float :acwp

      t.timestamps
    end
  end
end
