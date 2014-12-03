class PeriodsController < ApplicationController
  before_action :set_period, only: [:show, :edit, :update]
  before_action :set_schedule, only: [:index, :show, :details, :edit, :new, :create, :update]

  def index
    @project = Project.find(params[:project_id])
    @periods = Period.where(schedule_id: @schedule.id)
  end

  def show
  end

  def details
    @periods = Period.where(schedule_id: @schedule.id)
    @project = Project.find(params[:project_id])
  end

  def new
    @project = Project.find(params[:project_id])
    # We capture the start and dates of the project
    @start = @schedule.start_date
    @end = @schedule.end_date
    # We find the number of months (~rounded down~) which will correspond 
    # to number of periods
    @num_periods = (@end.year * 12 + @end.month) - (@start.year * 12 + @start.month)
    # Counter to number periods (period_number attribute); not id.
    @count = 1
    # Create named periods equal to number of months
    @num_periods.times do 
      @period = Period.create(schedule: @schedule, period_number: @count)
      @count += 1
    end 
    redirect_to project_schedule_periods_path(@project, @schedule)
  end

  def create
    @period = @schedule.period.new(period_params)
    if @period.save 
      redirect_to project_schedule(@schedule)
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find(params[:project_id])
  end

  def update
    @project = Project.find(params[:project_id]).id
    # Initial case where BCWS (baseline) isn't populated yet
    if !@period.bcws  
      if @period.update_attributes(period_params)
        # Sequentially populate baseline data period after period
        unless @period.period_number == Period.where(schedule_id: @schedule.id).count
          redirect_to "/projects/#{@project}/schedules/#{@schedule.id}/periods/#{@period.id+1}/edit", notice: 'Period Data Updated'
        # When last period is populated, redirect to project page
        else
          redirect_to "/projects/#{@project}"
        end
      else
        render 'update'
      end
    # Month-to-month updating of actuals
    else
      if @period.update_attributes(period_params)
        redirect_to "/projects/#{@project}"
      else
        render 'update'
      end
    end
  end

  private

  def set_period
    @period = Period.find(params[:id])
  end

  def set_schedule    
    @schedule = Schedule.find(params[:schedule_id])
  end

  def period_params
    params.require(:period).permit(:id, :period_number, :schedule_id, :bcws, :bcwp, :acwp)
  end
end
