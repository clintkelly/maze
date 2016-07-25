defmodule DijkstraTest do
  use ExUnit.Case

  alias MazeWalls.Grid
  alias MazeWalls.Ascii
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

  test "advancing the frontier from the root", %{grid: grid, root: root} do
    assert Dijkstra.get_new_frontier([root], grid, %{root => 0}) == %{ {0,1} => 1 }
  end

  test "advancing the frontier from a non-root", %{grid: grid, root: root} do
    assert Dijkstra.get_new_frontier([{0,1}], grid, %{root => 0, {0, 1} => 1}) == %{ {1,1} => 2 }
  end

  test "running dijktra's algorithm on a simple maze", %{grid: grid, distances: distances, root: root} do
    assert Dijkstra.dijkstra(root, grid) == distances
  end

  test "running dijktra's algorithm on a simple maze and printing the results", %{grid: grid, distances: distances, root: root} do
    assert Dijkstra.dijkstra(root, grid) == distances
    ascii =  Ascii.as_ascii(grid, fn(loc, _grid) -> Integer.to_string(distances[loc], 36) end)
    grid_with_distances = """
      +---+---+
      | 0   1 |
      +---+   +
      | 3   2 |
      +---+---+
      """
      assert ascii == grid_with_distances
  end

  test "tracking backwards", %{grid: grid, distances: distances} do
    assert Dijkstra.dijkstra({0,0}, grid) == distances
    assert Dijkstra.trace_backward({0,0}, {1,0}, grid, distances) == [ {0,0}, {0,1}, {1,1}, {1,0} ]
  end

  test "finding the farthest point from another", %{grid: grid, root: root} do
    { loc, dist } = Dijkstra.farthest_from(root, grid)
    assert loc == {1,0}
    assert dist == 3
  end

  test "find the furthest-apart pair of points" do
    # Create a grid in which {0,0} is not one of the furthest points. 
    grid = %Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        Grid.wall_between({1,0}, {1,1})
      ])
    }
    assert Dijkstra.farthest_apart_points(grid) == MapSet.new([ {1,0}, {1,1} ])
  end
end
