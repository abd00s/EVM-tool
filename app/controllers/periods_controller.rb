class PeriodsController < ApplicationController
  before_action :set_period, only: [:show, :edit, :update]
  before_action :set_schedule, only: [:show, :edit, :new, :create, :update]

  def index
    @periods = Period.all
  end

  def show
  end

  def new
    @project = Project.find(params[:project_id])
    @start = @schedule.start_date
    @end = @schedule.end_date
    @num_periods = (@end.year * 12 + @end.month) - (@start.year * 12 + @start.month)
    @count = 1
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
  end

  def update
    if @period.update_attributes(period_params)
      redirect_to project_schedule(@schedule), notice: 'Period Data Updated'
    else
      render 'update'
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
