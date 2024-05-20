# app/controllers/games_controller.rb
class GamesController < ApplicationController
  before_action :set_game, only: %i[show update set_piece destroy]

  
  def play
    @game = Game.find(params[:id])
  end
  def index
    @games = Game.all
  end


  def create
    @game = Game.new.initialize_board
    if @game.save
      redirect_to play_game_path(@game)
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def set_piece
    return if @game_over
    column = params['coords'].split("-")[1].to_i
    row = @game.get_empty_row(column)
    return if row == -1 # Column is full

    tile_class = @game.set_tile_and_player(row, column)

    render json: { status: 200, id: "#{row}-#{column}", class: tile_class, winner: @game.winner}
  end

  def destroy
    @game.destroy
    respond_to do |format|
      if @game.destroyed?
        format.html { redirect_to games_path, notice: "Game deleted successfully!" }
        format.json { head :no_content }
      else
        format.html { redirect_to games_path, alert: "Failed to delete game!" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
    @game_over = false
  end
end
