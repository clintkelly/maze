defprotocol MazeWalls.AnyGrid do

  @doc """
  Returns a wall between two cells.
  """
  def wall_between(grid, cell, neigh)
end
