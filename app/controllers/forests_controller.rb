class ForestsController < ApplicationController
  # GET /forests
  # GET /forests.json
  def index
    @forests = Forest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forests }
    end
  end

  # GET /forests/1
  # GET /forests/1.json
  def show
    @forest = Forest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forest }
    end
  end

  # GET /forests/new
  # GET /forests/new.json
  def new
    @forest = Forest.new
    @forest.trees.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forest }
    end
  end

  # GET /forests/1/edit
  def edit
    @forest = Forest.find(params[:id])
  end

  # POST /forests
  # POST /forests.json
  def create
    @forest = Forest.new(params[:forest])

    respond_to do |format|
      if @forest.save
        format.html { redirect_to @forest, notice: 'Forest was successfully created.' }
        format.json { render json: @forest, status: :created, location: @forest }
      else
        format.html { render action: "new" }
        format.json { render json: @forest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forests/1
  # PUT /forests/1.json
  def update
    @forest = Forest.find(params[:id])

    @forest.special_scenario = 'testing'

    respond_to do |format|
      if @forest.update_attributes(params[:forest])
        format.html { redirect_to @forest, notice: 'Forest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forests/1
  # DELETE /forests/1.json
  def destroy
    @forest = Forest.find(params[:id])
    @forest.destroy

    respond_to do |format|
      format.html { redirect_to forests_url }
      format.json { head :no_content }
    end
  end
end
