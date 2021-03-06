class StatusesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :current_project

  respond_to :html
  respond_to :js, :only => [ :index ]

  def index
    @statuses = @project.statuses.page(params[:page])
  end

  def create
    @comment = @project.statuses.new(params[:status])
    @comment.source = "Comment"
    @comment.user = current_user
    @comment.link = nil

    if @comment.save
      flash[:notice] = "Comment saved"
    else
      flash[:alert] = "Comment not saved"
    end

    redirect_to project_path(@project)
  end

  private

  def current_project
    @project = Project.find(params[:project_id])
    raise ActiveRecord::RecordNotFound unless @project.organization.user_ids.include? current_user.id
  end
end
