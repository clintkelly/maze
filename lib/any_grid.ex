defprotocol MazeWalls.AnyGrid do

  @doc """
  Returns a wall between two cells.
  """
  def wall_between(grid, cell, neigh)

  @doc """
  Get all of the neighbors of a cell.

  If consider_walls? is true, then don't include neighbors blocked by walls.
  """
  def neighbors(grid, cell, consider_walls? \\ true)

  @doc """
  Return all of the cells from the maze (no guarantees about order).
  """
  def all_cells(grid)

  @doc """
  Return a new instance of the grid, but with these walls added to it.
  """
  def with_walls(grid, walls)

  @doc """
  Return a text representation of the grid.
  """
  def as_text(grid)
end
