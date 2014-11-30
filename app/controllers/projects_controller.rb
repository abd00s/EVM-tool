class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    @bcws = [[0,0]] 
    @bcwp = [[0,0]] 
    @acwp = [[0,0]] 
    count = 1
    aprev = 0
    bprev = 0
    cprev = 0
    @schedule = Schedule.where(project_id: @project.id).first
    Period.where(schedule_id: @schedule).each do |p|
      @bcws << [count, p.bcws + aprev]
      aprev += p.bcws
      if p.bcwp
        @bcwp << [count, p.bcwp + bprev]
        bprev += p.bcwp
        @acwp << [count, p.acwp + cprev]
        cprev += p.acwp
      end
      count += 1
    end
    gon.bcws = @bcws
    gon.bcwp = @bcwp
    gon.acwp = @acwp

    if !@schedule.periods.first.bcwp
      @period_number = 1
    end
    


    @schedule.periods.each do |p|
      if !p.bcwp
        @period_number = p.period_number
        break
      end
    end

    @period_numbers = @schedule.periods.count
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to new_project_schedule_path(@project), notice: "New Project Created."
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params) 
      redirect_to project_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  private 
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:id, :name, :user_id, :scheudle_id)
  end
end
