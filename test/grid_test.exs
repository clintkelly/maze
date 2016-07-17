defmodule GridTest do
  use ExUnit.Case

  import MazeWalls.Grid

  test "Generation of all locations" do
    assert MazeWalls.Grid.get_locations(2,2) == MapSet.new([ {0,0}, {0,1}, {1,0}, {1,1}])
  end

  """
  +---+---+
  |       |
  +   +   +
  |   |   |
  +---+---+
  """


  test "walls between columns" do
    grid = %MazeWalls.Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        MapSet.new([{1,0}, {1,1}]),
      ])
    }

    assert MazeWalls.Grid.as_ascii_walls_between_columns(grid, 1) == "|   |   |\n"

  end

  test "walls between rows" do
    grid = %MazeWalls.Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        MapSet.new([{1,0}, {1,1}]),
      ])
    }
    assert MazeWalls.Grid.as_ascii_walls_between_rows(grid, 0) == "+   +   +\n"
    assert MazeWalls.Grid.as_ascii_walls_between_rows(grid, 1) == "+---+---+\n"
  end

  test "walls between rows" do
    grid = %MazeWalls.Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        MapSet.new([{1,0}, {0,0}]),
      ])
    }
    assert MazeWalls.Grid.as_ascii_walls_between_rows(grid, 0) == "+---+   +\n"
    assert MazeWalls.Grid.as_ascii_walls_between_rows(grid, 1) == "+---+---+\n"

  end

  test "as ascii" do
    grid = %MazeWalls.Grid{
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

    IO.puts("\n" <> MazeWalls.Grid.as_ascii(grid))

    assert MazeWalls.Grid.as_ascii(grid) == ascii

  end

  # Quick dumb test
  test "Create a grid" do
    assert %MazeWalls.Grid{ nrows: _, ncols: _ } = %MazeWalls.Grid{} 
  end
end
