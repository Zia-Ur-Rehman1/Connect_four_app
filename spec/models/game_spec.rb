require 'rails_helper'

RSpec.describe Game, type: :model do

    describe "validations" do
        # This test ensures the presence of the state attribute is validated
        it "validates the presence of state" do
          game = Game.new  # Create a new instance of the Game model
          game.valid?       # Run validations on the game object
          expect(game.errors[:state]).to include("can't be blank")
        end
    
        # This test ensures the presence of the current_player attribute is validated
        it "validates the presence of current_player" do
          game = Game.new
          game.valid?
          expect(game.errors[:current_player]).to include("can't be blank")
        end
    end
    describe "initialize_board" do
        # This test verifies that the initialize_board method creates a board
        # with all cells initialized to zero (empty)
        it "creates a board with empty cells" do
          game = Game.new
          game.initialize_board
          expect(game.state.all? { |row| row.all?(&:zero?) }).to be true
        end
      end
    

      
  

    describe "set_tile_and_player" do
        let(:game) { Game.create(state: Array.new(6) { Array.new(7) { 0 } }, current_player: 1) }

        context "when placing a piece" do
        it "places the piece in the correct row and column" do
            game.set_tile_and_player(2, 3)
            expect(game.state[2][3]).to eq(1)
        end

        it "switches the current player" do
            game.set_tile_and_player(2, 3)
            expect(game.current_player).to eq(2)
        end

        it "updates the winner if a winning condition is met (horizontal)" do
            game.state = [[1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
            game.set_tile_and_player(0, 3)
            expect(game.winner).to eq(1)
        end
        end
    end

  describe "check_winner" do
    let(:game) { Game.new }

    context "horizontal win (player 1)" do
      before { game.state = [[1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]] }
      it "returns the winner" do
        expect(game.check_winner(game.state)).to eq(1)
      end
    end

    context "vertical win (player 2)" do
        before { game.state = [[2, 0, 0, 0, 0, 0, 0], [2, 0, 0, 0, 0, 0, 0], [2, 0, 0, 0, 0, 0, 0], [2, 0, 0, 0, 0, 0, 2]] }
        it "returns the winner" do
          expect(game.check_winner(game.state)).to eq(2)
        end
      end
  
    context "diagonal win (downward, player 1)" do
      before { game.state = [[1, 0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0, 0], [0, 0, 0, 1, 0, 0, 0], [0, 0, 0, 0, 1, 0, 0], [0, 0, 0, 0, 0, 1, 1]] }
      it "returns the winner" do
        expect(game.check_winner(game.state)).to eq(1)
      end
    end
  
    context "diagonal win (upward, player 2)" do
      before { game.state = [[0, 0, 0, 0, 0, 0, 2], [0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 2, 0, 0], [0, 0, 0, 2, 0, 0, 0], [0, 0, 2, 0, 0, 0, 0], [1, 2, 0, 0, 0, 0, 0]] }
      it "returns the winner" do
        expect(game.check_winner(game.state)).to eq(2)
      end
    end
  
    context "tie (no winner)" do
        before { game.state = [[3, 2, 1, 3, 1, 3, 1], [2, 3, 3, 4, 3, 4, 3], [3, 4, 3, 4, 3, 5, 3], [4, 5, 6, 7, 9, 10, 12], [21, 12, 11, 22, 31, 24, 51], [12, 21, 32, 1, 2, 1, 2]] }
      
        it "returns nil" do
          expect(game.check_winner(game.state)).to be_nil
        end
      end
    end
end
  