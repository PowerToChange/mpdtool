class MpdContactActionsController < ApplicationController
  # GET /mpd_contact_actions
  # GET /mpd_contact_actions.xml
  def index
    @mpd_contact_actions = MpdContactAction.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mpd_contact_actions }
    end
  end

  # GET /mpd_contact_actions/1
  # GET /mpd_contact_actions/1.xml
  def show
    @mpd_contact_action = MpdContactAction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mpd_contact_action }
    end
  end

  # GET /mpd_contact_actions/new
  # GET /mpd_contact_actions/new.xml
  def new
    @mpd_contact_action = MpdContactAction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mpd_contact_action }
    end
  end

  # GET /mpd_contact_actions/1/edit
  def edit
    @mpd_contact_action = MpdContactAction.find(params[:id])
  end

  # POST /mpd_contact_actions
  # POST /mpd_contact_actions.xml
  def create
    @mpd_contact_action = MpdContactAction.new(params[:mpd_contact_action])

    respond_to do |format|
      if @mpd_contact_action.save
        flash[:notice] = 'MpdContactAction was successfully created.'
        format.html { redirect_to(@mpd_contact_action) }
        format.xml  { render :xml => @mpd_contact_action, :status => :created, :location => @mpd_contact_action }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mpd_contact_action.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mpd_contact_actions/1
  # PUT /mpd_contact_actions/1.xml
  def update
    @mpd_contact_action = MpdContactAction.find(params[:id])

    respond_to do |format|
      if @mpd_contact_action.update_attributes(params[:mpd_contact_action])
        flash[:notice] = 'MpdContactAction was successfully updated.'
        format.html { redirect_to(@mpd_contact_action) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mpd_contact_action.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mpd_contact_actions/1
  # DELETE /mpd_contact_actions/1.xml
  def destroy
    @mpd_contact_action = MpdContactAction.find(params[:id])
    @mpd_contact_action.destroy

    respond_to do |format|
      format.html { redirect_to(mpd_contact_actions_url) }
      format.xml  { head :ok }
    end
  end
end
