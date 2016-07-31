defmodule MazeWallsTest do
  use ExUnit.Case
  #doctest MazeWalls

  test "create walls between" do
    alias MazeWalls.Grid
    grid = %Grid{}
    _ = MazeWalls.AnyGrid.wall_between(grid, {0,0}, {1,0})
  end
end
