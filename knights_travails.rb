# frozen_string_literal: true

class ChessBoard
  KNIGHT_MOVEMENTS = [[2, 1], [2, -1], [-2, -1], [-2, 1], [1, -2], [1, 2], [-1, - 2], [-1, +2]].freeze

  def knight_moves(source, destination)
    refresh_board(source)
    find_paths(source, destination)
    shortest_path(source, destination)
  end

  private

  attr_accessor :queue, :visited_positions, :paths

  def refresh_board(source)
    @queue = [source]
    @visited_positions = []
    @paths = Array.new(8) { [] }
  end

  def find_paths(source, destination)
    until queue.empty?
      current_vertex = queue.shift

      break if current_vertex == destination

      knight_movements_from(*current_vertex).each do |movement|
        visited_positions.push(movement) unless visited_positions.include?(movement)

        store_path_to(*movement, current_vertex) unless movement == source

        queue.push(movement)
      end
    end
  end

  def knight_movements_from(row, column)
    KNIGHT_MOVEMENTS.map { |i, j| [row + i, column + j] }
                    .filter { |i, j| valid_movement?(i, j) }
  end

  def valid_movement?(row, column)
    (row >= 0 && row <= 7) && (column >= 0 && column <= 7)
  end

  def store_path_to(row, column, path)
    return if paths[row][column]

    paths[row][column] = path
  end

  def shortest_path(source, position, store = [])
    row, column = position
    previous_vertex = paths[row][column]

    shortest_path(source, previous_vertex, store) unless previous_vertex.nil?

    store << position
  end
end
