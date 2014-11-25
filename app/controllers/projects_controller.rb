class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    @data = [[0,0]] 
    Period.all.each do |p|
      count = 1
      @data << [count, p.bcws]
      count += 1
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to project_path(@project), notice: "New Project Created."
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
