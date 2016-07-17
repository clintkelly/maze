defmodule MazeWalls.BinaryTree do
  @moduledoc """
  Binary tree algorithm for maze generation - dead simple!

  Start with walls between every cell (a grid)
  Iterate through every position in the maze
  - Choose to eliminate the wall to the east or the north
  - (Handle edge cases appropriately)
  
  That's it!

  """

  @doc """
  Runs binary-tree algorithm to create a maze.
  """
  def generate_with_binary_tree(num_rows \\ 5, num_cols \\ 5) do
    # Assume that we don't need to take care of the edge walls now
    # Iterate through all of the cells
    # Generate a wall to either the north or the east (handling edge cases)

    walls = for loc <- MazeWalls.Grid.get_locations(num_rows, num_cols),
                !MazeWalls.Grid.is_north_edge?(loc, num_rows),
                !MazeWalls.Grid.is_east_edge?(loc, num_cols),
                into: MapSet.new, do: pick_north_or_east_wall(loc)
    %MazeWalls.Grid{ nrows: num_rows, ncols: num_cols, walls: walls }
  end

  def pick_north_or_east_wall(loc = {row, col}) do
    north_loc = { row - 1, col }
    east_loc = { row, col + 1 }
    Enum.random([
      MapSet.new([north_loc, loc]),
      MapSet.new([east_loc, loc])
    ])
  end

end
