defmodule AsciiTest do
  use ExUnit.Case

  alias MazeWalls.Grid
  alias MazeWalls.Ascii

  test "walls between columns" do
    grid = %Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        MapSet.new([{1,0}, {1,1}]),
      ])
    }

    assert Ascii.walls_between_columns(grid, 1) == "|   |   |\n"

  end

  test "walls between rows" do
    grid = %Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        MapSet.new([{1,0}, {1,1}]),
      ])
    }
    assert Ascii.walls_between_rows(grid, 0) == "+   +   +\n"
    assert Ascii.walls_between_rows(grid, 1) == "+---+---+\n"
  end

  test "other walls between rows" do
    grid = %Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        MapSet.new([{1,0}, {0,0}]),
      ])
    }
    assert Ascii.walls_between_rows(grid, 0) == "+---+   +\n"
    assert Ascii.walls_between_rows(grid, 1) == "+---+---+\n"

  end

  test "as ascii" do
    grid = %Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        MapSet.new([{1,0}, {0,0}]),
      ])
    }

    ascii = """
      +---+---+
      |       |
      +---+   +
      |       |
      +---+---+
      """

      #IO.puts("\n" <> Ascii.as_ascii(grid))

    assert Ascii.as_ascii(grid) == ascii

  end
end
