defmodule GridTest do
  use ExUnit.Case

  alias MazeWalls.Grid

  test "Generation of all locations" do
    assert Grid.get_locations(%MazeWalls.Grid{nrows: 2, ncols: 2}) == MapSet.new([ {0,0}, {0,1}, {1,0}, {1,1}])
  end

  _ = """
  +---+---+
  |       |
  +   +   +
  |   |   |
  +---+---+
  """

  # Quick dumb test
  test "Create a grid" do
    assert %Grid{ nrows: _, ncols: _ } = %Grid{} 
  end

  test "walk row" do
    grid = %Grid{ nrows: 2, ncols: 5 }
    assert Grid.walk_row(1, grid) == [ {1,0}, {1,1}, {1,2}, {1,3}, {1,4} ]
  end

  test "get neighbors without walls" do
    grid = %Grid{ nrows: 5, ncols: 5 }
    cell = { 2, 2 }
    neighbors = Grid.neighbors(cell, grid) 
    assert MapSet.new(neighbors) == MapSet.new [ {1,2}, {3,2}, {2,1}, {2,3} ]
  end

  test "get neighbors on the edge of the grid" do
    grid = %Grid{ nrows: 5, ncols: 5 }
    cell = { 0, 0 }
    neighbors = Grid.neighbors(cell, grid) 
    assert MapSet.new(neighbors) == MapSet.new [ {0,1}, {1,0} ]
  end

  test "get neighbors with walls" do
    cell = { 0, 0 }
    neigh_east = { 0, 1 }

    wall = Grid.wall_between(cell, neigh_east)

    grid = %Grid{ nrows: 5, ncols: 5, walls: MapSet.new([wall])}

    neighbors = Grid.neighbors(cell, grid) 
    assert MapSet.new(neighbors) == MapSet.new [ {1,0} ]
  end
end
