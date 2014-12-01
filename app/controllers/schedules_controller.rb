class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :new, :edit, :create, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @schedule = Schedule.create(project: @project)
    # With the schedule associated to the new project created, we redirect to 
    # this schedule's edit to populate dates
    redirect_to edit_project_schedule_path(@project, @schedule)
  end

  def create
    @schedule = @project.schedule.new(schedule_params)
    if @schedule.save
      redirect_to project_path(@project), notice: 'New Schedule Created'
      # num of periods (N)= end - start
      # N.time {x = Period.create
      #          x.period_number = count}
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @schedule.update_attributes(schedule_params)
      # After the dates are populated, we ridirect to the new periods action
      redirect_to new_project_schedule_period_path(@project, @schedule)
    else
      render 'edit'
    end
  end

  def destroy
    @schedule.destroy
    redirect_to project_path(@project)
  end

  private 
  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def schedule_params
    params.require(:schedule).permit(:id, :project_id, :start_date, :end_date)
  end
end
