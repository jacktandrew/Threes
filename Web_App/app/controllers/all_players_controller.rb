class AllPlayersController < ApplicationController
  # GET /all_players
  # GET /all_players.json
  def index
    @all_players = AllPlayer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @all_players }
    end
  end

  # GET /all_players/1
  # GET /all_players/1.json
  def show
    @all_player = AllPlayer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @all_player }
    end
  end

  # GET /all_players/new
  # GET /all_players/new.json
  def new
    @all_player = AllPlayer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @all_player }
    end
  end

  # GET /all_players/1/edit
  def edit
    @all_player = AllPlayer.find(params[:id])
  end

  # POST /all_players
  # POST /all_players.json
  def create
    @all_player = AllPlayer.new(params[:all_player])

    respond_to do |format|
      if @all_player.save
        format.html { redirect_to @all_player, notice: 'All player was successfully created.' }
        format.json { render json: @all_player, status: :created, location: @all_player }
      else
        format.html { render action: "new" }
        format.json { render json: @all_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /all_players/1
  # PUT /all_players/1.json
  def update
    @all_player = AllPlayer.find(params[:id])

    respond_to do |format|
      if @all_player.update_attributes(params[:all_player])
        format.html { redirect_to @all_player, notice: 'All player was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @all_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /all_players/1
  # DELETE /all_players/1.json
  def destroy
    @all_player = AllPlayer.find(params[:id])
    @all_player.destroy

    respond_to do |format|
      format.html { redirect_to all_players_url }
      format.json { head :ok }
    end
  end
end
