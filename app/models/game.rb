class Game < ApplicationRecord
  validates :state, presence: true
  validates :current_player, presence: true
  serialize :state, Array


  def initialize_board
    self.assign_attributes(state: Array.new(6) { Array.new(7) { 0 } }, current_player: 1)
    return self
  end

  def empty_row?(column)
    state.map { |r| r[column] }.reverse.index(0).present?
  end

  def get_empty_row(column)
    index = state.map { |r| r[column] }.reverse.index(0)
    return 5 - index unless index.nil?

    -1 # Column is full
  end

  def set_tile_and_player(row, column)

    self.state[row][column] = self.current_player
    tile_class = self.current_player == 1 ? "red-piece" : "yellow-piece"
    game_winner = check_winner(state).to_i
    self.winner = game_winner if game_winner > 0
    self.current_player = self.current_player == 1 ? 2 : 1
    save
    return tile_class
  end
  
  def check_winner(board)
    # Check for consecutive wins (1s or 2s)
    players = [1, 2]
    players.each do |player|
      # Check horizontal wins
      board.each do |row|
        consecutive_count = 0
        row.each do |cell|
          consecutive_count = (cell == player) ? consecutive_count + 1 : 0
          return player if consecutive_count >= 4
        end
      end
  
      # Check vertical wins
      (0...board.first.size).each do |col_index|
        consecutive_count = 0
        board.each do |row|
          cell = row[col_index]
          consecutive_count = (cell == player) ? consecutive_count + 1 : 0
          return player if consecutive_count >= 4
        end
      end
  
      # Check diagonal wins (downward)
      (0...board.size - 3).each do |row_index|
        (0...board.first.size - 3).each do |col_index|
          consecutive_count = 0
          (0..3).each do |offset|
            next if row_index + offset >= board.size || col_index + offset >= board.first.size
            consecutive_count = (board[row_index + offset][col_index + offset] == player) ? consecutive_count + 1 : 0
            return player if consecutive_count >= 4
          end
        end
      end
  
      # Check diagonal wins (upward)
      (3...board.size).each do |row_index|
        (0...board.first.size - 3).each do |col_index|
          consecutive_count = 0
          (0..3).each do |offset|
            next if row_index - offset < 0 || col_index + offset >= board.first.size
            consecutive_count = (board[row_index - offset][col_index + offset] == player) ? consecutive_count + 1 : 0
            return player if consecutive_count >= 4
          end
        end
      end
    end
  
    # No winner found
    return nil
  end

  
end