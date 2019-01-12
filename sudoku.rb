class Sudoku
  attr_reader :tiles

  BOARD_SIZE = 9

  def initialize(default_tiles=[])
    @tiles = default_tiles.empty? ? blank_board : default_tiles
  end

  def row(num)
    cell_values_for(cell_indexes_for(:row, num))
  end

  def column(num)
    cell_values_for(cell_indexes_for(:column, num))
  end

  def grid(num)
    cell_values_for(cell_indexes_for(:grid, num))
  end

  def self.checker(tiles)
    non_nils = tiles.compact.sort

    non_nils == non_nils.uniq
  end

  def valid?
    results = (all_rows + all_columns + all_grids).map { |tiles| Sudoku.checker(tiles) }

    results.all?
  end

  def complete?
    @tiles.compact.count == @tiles.count
  end

  def win?
    valid? && complete?
  end

  def suitable_num?(index, candidate_num)
    original_num = @tiles[index]

    row_num, column_num, grid_num = coord_of(index)

    @tiles[index] = candidate_num
    result = [row(row_num), column(column_num), grid(grid_num)].map { |tiles| Sudoku.checker(tiles) }

    @tiles[index] = original_num
    result.all?
  end

  def build_puzzle!
    loop do
      try_build
      break if valid? && complete?
    end
  end

  private

  def try_build
    puts "=========================================="
    puts "Trying to build a board"

    @tiles = blank_board

    (0..80).each do |index|
      puts "Looking for candidate for pos: #{index}"

      candidates = (1..9).to_a

      loop do
        break if candidates.empty?

        candidates.shuffle!
        candidate_num = candidates.slice!(1)

        if candidate_num.nil?
          candidate_num = candidates[0]
          candidates = []
        end

        puts "Checking: #{candidate_num} for pos: #{index}"

        if suitable_num?(index, candidate_num)
          puts "Yup! #{candidate_num} is suitable."
          @tiles[index] = candidate_num
          break
        end
      end

      if @tiles[index].nil?
        puts 'Seems like the last candidate was not found.'
        break
      end
    end
  end

  def cell_indexes_for(type, num)
    case type
    when :row
      start_index = (num - 1) * BOARD_SIZE
      (start_index..start_index+8).to_a
    when :column
      start_index = (num - 1)
      (0..BOARD_SIZE-1).map { |n| start_index + (n * BOARD_SIZE) }
    when :grid
      grid_row = (num / 3.0).ceil
      upper_bound = grid_row * 3

      grid_col = (num % 3)
      grid_column_mapping = {
          1 => 0,
          2 => 3,
          0 => 6
      }
      column_index = grid_column_mapping[grid_col]

      ((upper_bound - 2)..upper_bound).map { |r| cell_indexes_for(:row, r)[column_index..column_index+2] }.flatten
    end
  end

  def cell_values_for(indexes)
    indexes.map{ |i| @tiles[i] }
  end

  def coord_of(index)
    start_index = (index + 1)

    row_num = (start_index / BOARD_SIZE.to_f).ceil

    column_num = start_index % BOARD_SIZE
    column_num = 9 if column_num.zero?

    grid_num = (row_num / 3.0).ceil * (column_num / 3.0).ceil

    [row_num, column_num, grid_num]
  end

  def all_rows
    (1..BOARD_SIZE).map(&method(:row))
  end

  def all_columns
    (1..BOARD_SIZE).map(&method(:column))
  end

  def all_grids
    (1..BOARD_SIZE).map(&method(:grid))
  end

  def blank_board
    Array.new((BOARD_SIZE * BOARD_SIZE))
  end
end