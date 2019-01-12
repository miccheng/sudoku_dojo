require 'spec_helper'
require_relative '../sudoku'

describe Sudoku do
  describe '.initialize' do
    it 'creates a new board' do
      expect(subject).to be_a Sudoku
      expect(subject.tiles.count).to eq 81
    end
  end

  describe '.checker' do
    it 'checks for unique values' do
      expect(Sudoku.checker([5, 3, 4, 6, 7, 8, 9, 1, 2])).to be
      expect(Sudoku.checker([1, 2, nil, nil, nil, 3, nil, nil, nil])).to be
      expect(Sudoku.checker([5, 3, 4, 6, 7, 8, 9, 2, 2])).not_to be
      expect(Sudoku.checker([1, 2, nil, nil, nil, 2, nil, nil, nil])).not_to be
    end
  end

  context 'valid puzzle' do
    let(:valid_tiles) {
      [
        5, 3, 4, 6, 7, 8, 9, 1, 2,
        6, 7, 2, 1, 9, 5, 3, 4, 8,
        1, 9, 8, 3, 4, 2, 5, 6, 7,
        8, 5, 9, 7, 6, 1, 4, 2, 3,
        4, 2, 6, 8, 5, 3, 7, 9, 1,
        7, 1, 3, 9, 2, 4, 8, 5, 6,
        9, 6, 1, 5, 3, 7, 2, 8, 4,
        2, 8, 7, 4, 1, 9, 6, 3, 5,
        3, 4, 5, 2, 8, 6, 1, 7, 9
      ]
    }
    subject{ Sudoku.new(valid_tiles) }

    describe '#row' do
      it 'returns row' do
        expect(subject.row(1)).to eq [5, 3, 4, 6, 7, 8, 9, 1, 2]
        expect(subject.row(2)).to eq [6, 7, 2, 1, 9, 5, 3, 4, 8]
        expect(subject.row(4)).to eq [8, 5, 9, 7, 6, 1, 4, 2, 3]
      end
    end

    describe '#column' do
      it 'returns column' do
        expect(subject.column(1)).to eq [5, 6, 1, 8, 4, 7, 9, 2, 3]
        expect(subject.column(2)).to eq [3, 7, 9, 5, 2, 1, 6, 8, 4]
        expect(subject.column(4)).to eq [6, 1, 3, 7, 8, 9, 5, 4, 2]
      end
    end

    describe '#grid' do
      it 'returns grid' do
        expect(subject.grid(1)).to eq [5, 3, 4, 6, 7, 2, 1, 9, 8]
        expect(subject.grid(2)).to eq [6, 7, 8, 1, 9, 5, 3, 4, 2]
        expect(subject.grid(4)).to eq [8, 5, 9, 4, 2, 6, 7, 1, 3]
      end
    end

    describe '#neighbours' do
      it 'returns neighbouring indexes' do
        expect(subject.neighbours(27)).to eq [0, 9, 18, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 45, 46, 47, 54, 63, 72]
      end
    end

    describe '#valid?' do
      it 'returns true on all valid answers' do
        expect(subject).to be_valid
      end
    end

    describe '#complete?' do
      it 'returns true when all tiles are filled' do
        expect(subject).to be_complete
      end
    end

    describe '#build_puzzle!' do
      subject{ Sudoku.new }

      it 'builds a valid puzzle' do
        subject.build_puzzle!

        expect(subject).to be_win
      end
    end

    describe '#display_answers' do
      it 'shows the current state' do
        expected = <<~EOT
        81 tiles filled up:
        -------------------------
        | 5 3 4 | 6 7 8 | 9 1 2 |
        | 6 7 2 | 1 9 5 | 3 4 8 |
        | 1 9 8 | 3 4 2 | 5 6 7 |
        |-------+-------+-------|
        | 8 5 9 | 7 6 1 | 4 2 3 |
        | 4 2 6 | 8 5 3 | 7 9 1 |
        | 7 1 3 | 9 2 4 | 8 5 6 |
        |-------+-------+-------|
        | 9 6 1 | 5 3 7 | 2 8 4 |
        | 2 8 7 | 4 1 9 | 6 3 5 |
        | 3 4 5 | 2 8 6 | 1 7 9 |
        -------------------------
        EOT
        expect{ subject.display_answers }.to output(expected).to_stdout
      end
    end

    describe '#display_puzzle' do
      subject{ Sudoku.new(valid_tiles, [0, 1, 2, 3, 79, 80]) }
      it 'shows the current puzzle' do
        expected = <<~EOT
        75 tiles filled up:
        -------------------------
        |       |   7 8 | 9 1 2 |
        | 6 7 2 | 1 9 5 | 3 4 8 |
        | 1 9 8 | 3 4 2 | 5 6 7 |
        |-------+-------+-------|
        | 8 5 9 | 7 6 1 | 4 2 3 |
        | 4 2 6 | 8 5 3 | 7 9 1 |
        | 7 1 3 | 9 2 4 | 8 5 6 |
        |-------+-------+-------|
        | 9 6 1 | 5 3 7 | 2 8 4 |
        | 2 8 7 | 4 1 9 | 6 3 5 |
        | 3 4 5 | 2 8 6 | 1     |
        -------------------------
        EOT
        expect{ subject.display_puzzle }.to output(expected).to_stdout
      end
    end
  end

  context 'invalid puzzle' do
    let(:valid_tiles) {
      [
          5, 3, 4, 6, 8, 8, 9, 1, 2,
          6, 7, 2, 1, 9, 5, 3, 4, 8,
          1, 9, 8, nil, 4, 2, 5, 6, 7,
          8, 5, 9, 7, 6, 1, 4, 2, 3,
          4, 2, 6, 8, 3, 3, 7, 9, 1,
          7, 1, 3, 9, 2, 4, 8, 5, 6,
          9, 6, 1, 5, 3, 7, 2, 8, 4,
          2, 8, 7, 4, 1, 9, 6, 3, 5,
          3, 4, 5, 2, 8, 6, 1, 7, 9
      ]
    }
    subject{ Sudoku.new(valid_tiles) }

    describe '#valid?' do
      it 'returns true on all valid answers' do
        expect(subject).not_to be_valid
      end
    end

    describe '#complete?' do
      it 'returns false when all tiles are not filled' do
        expect(subject).not_to be_complete
      end
    end
  end
end