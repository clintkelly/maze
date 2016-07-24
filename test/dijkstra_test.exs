defmodule DijkstraTest do
  use ExUnit.Case

  alias MazeWalls.Grid
  alias MazeWalls.Dijkstra

  setup do
    grid = %Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        Grid.wall_between({0,0}, {1,0})
      ])
    }

    _grid_as_ascii = """
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

    {:ok, grid: grid, distances: distances, root: root}
  end

  test "advancing the frontier from the root", %{grid: grid, distances: distances, root: root} do
    assert Dijkstra.get_new_frontier([root], grid, %{root => 0}) == %{ {0,1} => 1 }
  end

  test "advancing the frontier from a non-root", %{grid: grid, distances: distances, root: root} do
    assert Dijkstra.get_new_frontier([{0,1}], grid, %{root => 0, {0, 1} => 1}) == %{ {1,1} => 2 }
  end

  test "running dijktra's algorithm on a simple maze", %{grid: grid, distances: distances, root: root} do
    assert Dijkstra.dijkstra({0,0}, grid) == distances
  end

  test "running dijktra's algorithm on a simple maze and printing the results", %{grid: grid, distances: distances, root: root} do
    assert Dijkstra.dijkstra({0,0}, grid) == distances
    ascii =  MazeWalls.Grid.Ascii.as_ascii(grid, fn(loc, _grid) -> Integer.to_string(distances[loc], 36) end)
    grid_with_distances = """
      +---+---+
      | 0   1 |
      +---+   +
      | 3   2 |
      +---+---+
      """
      assert ascii == grid_with_distances
  end
end
