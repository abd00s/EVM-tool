class RemoveSchedFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :schedule_id
  end
end
