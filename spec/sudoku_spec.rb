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
      end
    end

    describe '#column' do
      it 'returns column' do
        expect(subject.column(1)).to eq [5, 6, 1, 8, 4, 7, 9, 2, 3]
        expect(subject.column(2)).to eq [3, 7, 9, 5, 2, 1, 6, 8, 4]
      end
    end

    describe '#grid' do
      it 'returns grid' do
        expect(subject.grid(1)).to eq [5, 3, 4, 6, 7, 2, 1, 9, 8]
        expect(subject.grid(2)).to eq [6, 7, 8, 1, 9, 5, 3, 4, 2]
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

    describe '#suitable_num?' do
      it 'returns true for suitable number' do
        expect(subject.suitable_num?(3, 6)).to be
      end

      it 'returns false for unsuitable number' do
        expect(subject.suitable_num?(3, 7)).not_to be
        expect(subject).to be_valid
      end
    end

    describe '#build_puzzle!' do
      subject{ Sudoku.new }

      it 'builds a valid puzzle' do
        subject.build_puzzle!

        expect(subject).to be_win
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