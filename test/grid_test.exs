defmodule GridTest do
  use ExUnit.Case

  alias MazeWalls.Grid
  alias MazeWalls.Grid.Ascii

  test "Generation of all locations" do
    assert Grid.get_locations(%MazeWalls.Grid{nrows: 2, ncols: 2}) == MapSet.new([ {0,0}, {0,1}, {1,0}, {1,1}])
  end

  """
  +---+---+
  |       |
  +   +   +
  |   |   |
  +---+---+
  """


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

  test "walls between rows" do
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

    IO.puts("\n" <> Ascii.as_ascii(grid))

    assert Ascii.as_ascii(grid) == ascii

  end

  # Quick dumb test
  test "Create a grid" do
    assert %Grid{ nrows: _, ncols: _ } = %Grid{} 
  end
end
