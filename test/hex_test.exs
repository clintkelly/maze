defmodule HexTest do
  use ExUnit.Case

  alias MazeWalls.Hex
  alias MazeWalls.AnyGrid

  test "Generation of all locations" do
    assert AnyGrid.all_cells(%Hex{nrows: 2, ncols: 2}) == MapSet.new([ {0,0}, {0,1}, {1,0}, {1,1} ])
  end

  test "neighbor to north" do
    grid = %Hex{ nrows: 5, ncols: 5 }
    assert Hex.neigh_southeast({0, 0}, grid) == {0, 1}
    assert Hex.neigh_south({0, 0}, grid) == {1, 0}
    assert Hex.neigh_north({0, 0}, grid) == nil
    assert Hex.neigh_northwest({0, 0}, grid) == nil
    assert Hex.neigh_southwest({0, 0}, grid) == nil
    assert Hex.neigh_northeast({0, 0}, grid) == nil
  end

  test "get neighbors without walls" do
    grid = %Hex{ nrows: 5, ncols: 5 }
    cell = { 0, 0 }
    neighbors = AnyGrid.neighbors(grid, cell)
    assert MapSet.new(neighbors) == MapSet.new [ {0, 1}, {1, 0} ]
  end

  test "show as ascii" do
    # Annoying that we cannot put \ directly in the string...
    ascii = """
       ___     ___ 
      /   |___/   |
      |___    |   /
      /    ___    |
      |___/    ___/
          |___/    
      """ |> String.replace("|", "\\")

    walls = MapSet.new([
      Hex.wall_between( {0,0}, {1,0} ),
      Hex.wall_between( {0,1}, {0,2} ),
      Hex.wall_between( {0,1}, {1,1} ),
      Hex.wall_between( {1,0}, {1,1} ),
    ])

    maze = %Hex{nrows: 2, ncols: 3, walls: walls}
    assert AnyGrid.as_text(maze) == ascii
  end
end
