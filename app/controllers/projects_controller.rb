class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    # Initialize all metrics at [0,0]
    @bcws = [[0,0]] 
    @bcwp = [[0,0]] 
    @acwp = [[0,0]] 
    # Counter to increment X axis (period) value
    count = 1
    # Vars to build cumulative data 
    aprev = 0
    bprev = 0
    cprev = 0
    # Get the schedule associated with the project
    @schedule = Schedule.where(project_id: @project.id).first
    # Build up metrics for each period 
    Period.where(schedule_id: @schedule).each do |p|
      @bcws << [count, p.bcws + aprev]
      aprev += p.bcws
      # Initially, perids will not have the actuals so will be nil until updated
      if p.bcwp
        @bcwp << [count, p.bcwp + bprev]
        bprev += p.bcwp
        @acwp << [count, p.acwp + cprev]
        cprev += p.acwp
      end
      count += 1
    end
    # Notation for using the data in JavaScript 
    gon.bcws = @bcws
    gon.bcwp = @bcwp
    gon.acwp = @acwp

    # To be used in view for value displayed in "Update Period '#'" button
    # Set to one initially
    if !@schedule.periods.first.bcwp
      @period_number = 1
    end
    
    # After initial, set to period where actuals are yet to be populated
    @schedule.periods.each do |p|
      if !p.bcwp
        @period_number = p.period_number
        break
      end
    end

    # Used temporarily for debugging
    @period_numbers = @schedule.periods.count

    # Display overall metrics
    # Because BCWS is populated entirely, we don't want sum of entire data set,
    # we want sum up to current period (i.e. ignore periods where actuals
    # aren't populated yet)
    @schedule.periods.each do |p|
      if !p.bcwp
        @current = p.period_number-1
        break
      else
        @current = @bcws.length-1
      end
    end

    @total_bcws = @bcws[@current][1]
    # For actuals, we want sum up to current point 
    @total_bcwp = @bcwp[@bcwp.length-1][1]
    @total_acwp = @acwp[@acwp.length-1][1]
    # Initially won't be populated so we don't want to divide by 0
    # Then, calculate metrics
    if @total_acwp != 0
      @cpi = (@total_bcwp / @total_acwp).round(3)
      @spi = (@total_bcwp / @total_bcws).round(3)
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      # Automatically create a schedule associated to this project
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
