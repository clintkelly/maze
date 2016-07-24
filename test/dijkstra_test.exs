defmodule DijkstraTest do
  use ExUnit.Case

  alias MazeWalls.Grid
  alias MazeWalls.Dijkstra

  test "as ascii" do
    grid = %Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        Grid.wall_between({0,0}, {1,0})
      ])
    }

    _grid = """
      +---+---+
      |       |
      +---+   +
      |       |
      +---+---+
      """

    distances = %{
      {0,0} => 0,
      {0,1} => 1,
      {1,1} => 2,
      {1,0} => 3
    }

    root = {0,0}

    assert Dijkstra.get_new_frontier([root], grid, %{root => 0}) == %{ {0,1} => 1 }
    assert Dijkstra.get_new_frontier([{0,1}], grid, %{root => 0, {0, 1} => 1}) == %{ {1,1} => 2 }

    assert Dijkstra.dijkstra({0,0}, grid) == distances
  end
end
