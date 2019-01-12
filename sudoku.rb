require 'set'

class Sudoku
  attr_reader :tiles

  BOARD_SIZE = 9
  DEFAULT_EMPTY_SLOTS = 40

  def initialize(default_tiles=[], default_blanks=[], empty_slots=40)
    @tiles = default_tiles.empty? ? blank_board : default_tiles
    @puzzle_blanks = default_blanks unless default_blanks.empty?
    @empty_slots = empty_slots || DEFAULT_EMPTY_SLOTS
  end

  def row(num, tiles=@tiles)
    cell_values_for(cell_indexes_for(:row, num), tiles)
  end

  def column(num, tiles=@tiles)
    cell_values_for(cell_indexes_for(:column, num), tiles)
  end

  def grid(num, tiles=@tiles)
    cell_values_for(cell_indexes_for(:grid, num), tiles)
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

  def neighbours(index)
    row_num, column_num, grid_num = coord_of(index)

    Set.new([
      cell_indexes_for(:row, row_num),
      cell_indexes_for(:column, column_num),
      cell_indexes_for(:grid, grid_num),
    ].flatten).to_a.sort
  end

  def build_puzzle!
    puts "=========================================="
    puts "Trying to build a board"
    @tiles = blank_board
    puts "Unable to build Puzzle" unless fill_cell(0)

    display_puzzle
  end

  def display_answers
    display_board(@tiles)
  end

  def display_puzzle
    puzzle = @tiles.dup

    puzzle_blanks.each do |i|
      puzzle[i] = nil
    end

    display_board(puzzle)
  end

  def puzzle_blanks
    @puzzle_blanks ||= build_blanks!
  end

  def build_blanks!
    @puzzle_blanks = (0..80).to_a.sample(@empty_slots)
  end

  private

  def display_board(tiles)
    puts "#{tiles.compact.count} tiles filled up:"
    print "-------------------------\n" +
      (1..3).map{ |r| print_line(row(r, tiles)) }.join("\n") +
      "\n|-------+-------+-------|\n" +
      (4..6).map{ |r| print_line(row(r, tiles)) }.join("\n") +
      "\n|-------+-------+-------|\n" +
      (7..9).map{ |r| print_line(row(r, tiles)) }.join("\n") +
      "\n-------------------------\n"
    $stdout.flush
  end

  def print_line(cells)
    str = '|'

    cells.each_with_index do |cell, index|
      str += " #{cell.nil? ? ' ' : cell}"
      str += ' |' if (index+1) % 3 == 0
    end

    str
  end

  def fill_cell(index)
    row_num, column_num, grid_num = coord_of(index)
    unique_values = Set.new([row(row_num), column(column_num), grid(grid_num)].flatten.compact).to_a.sort

    available_options = (1..9).to_a - unique_values

    available_options.shuffle.each do |n|
      @tiles[index] = n
      # display_answers

      return true if index == (@tiles.count - 1) || fill_cell(index + 1)
    end

    @tiles[index] = nil
    false
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

  def cell_values_for(indexes, tiles=@tiles)
    indexes.map{ |i| tiles[i] }
  end

  def coord_of(index)
    start_index = (index + 1)

    row_num = (start_index / BOARD_SIZE.to_f).ceil

    column_num = start_index % BOARD_SIZE
    column_num = 9 if column_num.zero?

    grid_y = (row_num / 3.0).ceil
    grid_x = (column_num / 3.0).ceil
    grid_num = ((grid_y - 1) * 3) + grid_x

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