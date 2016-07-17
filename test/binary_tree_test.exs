defmodule BinaryTreeTest do
  use ExUnit.Case

  import MazeWalls.BinaryTree

  test "picking a wall to the north or the east" do
    loc = { 1, 1 }
    north = { 0, 1 }
    east = { 1, 2 }
    walls = MapSet.new([MapSet.new([loc, north]), MapSet.new([loc, east])])
    for i <- 0..100 do
      assert MazeWalls.BinaryTree.pick_north_or_east_wall(loc) in walls
    end
  end

end


