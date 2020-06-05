class RisksController < ApplicationController
  unloadable

  before_action :find_project_by_project_id
  before_action :find_risk, except: [:index, :new, :create]
  before_action :check_project_permission

  def index
    @query = Risk.includes(:issues, :risk_status)

    @limit = Risk::PER_PAGE
    @risks_count = @query.count
    @risks_pages = Paginator.new @risks_count, @limit, params[:page]
    @offset ||= @risks_pages.offset

    @risks = @query.where(project_id: @project).offset(@offset).limit(@limit)
  end

  def new
    @risk = Risk.new
    @risk_statuses = RiskStatus.ordered
  end

  def create
    @risk = Risk.new
    @risk.safe_attributes = params[:risk]
    @risk.project = @project
    @risk.user    = User.current

    if @risk.save
      flash[:notice] = t(:notice_successful_create)
      respond_to do |format|
        format.html { redirect_to [@project, @risk] }
        format.api  { head :ok }
      end
    else
      respond_to do |format|
        format.html { render action: :new }
        format.api  { render_validation_errors(@risk) }
      end
      @risk_statuses = RiskStatus.ordered
    end
  end

  def show
    @issues = @risk.issues
  end

  def edit
    @risk_statuses = RiskStatus.ordered
  end

  def update
    @risk.safe_attributes = params[:risk]

    if @risk.save
      flash[:notice] = t(:notice_successful_update)
      respond_to do |format|
        format.html { redirect_to [@project, @risk]  }
        format.api  { head :ok }
      end
    else
      respond_to do |format|
        format.html { render action: :edit }
        format.api  { render_validation_errors(@risk) }
      end
      @risk_statuses = RiskStatus.ordered
    end
  end

  def destroy
    if @risk.destroy
      flash[:notice] = t(:notice_successful_delete)
    else
      flash[:error] = t(:notice_unsuccessful_delete)
    end

    respond_to do |format|
      format.html { redirect_to project_risks_path(@project) }
      format.api  { head :ok }
    end
  end


private

  def find_risk
    @risk = Risk.includes(:project).find(params[:id])
  end

  def check_project_permission
    if @risk && @risk.project != @project
      render_403
    end
  end

end
