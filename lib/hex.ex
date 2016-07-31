defmodule MazeWalls.Hex do
  @moduledoc """
  Hex grid.
  """
  defstruct nrows: 5, ncols: 5, walls: MapSet.new

  import Integer

  def wall_between(cell={_row,_col}, neigh={_row2,_col2}) do
    # TODO: Assert the cells are actually neighbors!
    MapSet.new([cell, neigh])
  end

  # Methods for returning neighboring cells.
  # North/south are the same as for a standard square grid.
  # East/west are no more, instead we have northeast, southeast and northwest, southwest.

  defp cell_at(grid, row, col) do
    #IO.puts "cell at: #{row}, #{col} #{inspect grid}"
    if 0 <= row and row < grid.nrows and 0 <= col and col < grid.ncols do
      { row, col }
    else
      nil
    end
  end

  # North / south
  def neigh_north(loc={row, col}, grid), do: cell_at(grid, row-1, col)
  def neigh_south(loc={row, col}, grid), do: cell_at(grid, row+1, col)

  # East / west
  defp north_diagonal_row(loc={row, col}) do
    if Integer.is_even(col), do: row - 1, else: row
  end
  
  defp south_diagonal_row(loc={row, col}) do
    if Integer.is_even(col), do: row, else: row + 1
  end

  def neigh_northeast( loc={row, col}, grid), do: cell_at(grid, north_diagonal_row(loc), col+1 )
  def neigh_southeast( loc={row, col}, grid), do: cell_at(grid, south_diagonal_row(loc), col+1 )
  
  def neigh_northwest( loc={row, col}, grid), do: cell_at(grid, north_diagonal_row(loc), col-1 )
  def neigh_southwest( loc={row, col}, grid), do: cell_at(grid, south_diagonal_row(loc), col-1 )

  def wall_to_north?(loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_north/2)
  def wall_to_south?(loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_south/2)

  def wall_to_northeast?( loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_northeast/2)
  def wall_to_northwest?( loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_northwest/2)

  def wall_to_southeast?( loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_southeast/2)
  def wall_to_southwest?( loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_southwest/2)

  defp wall_to?(loc, grid, neigh_getter) do
    neigh = neigh_getter.(loc, grid)
    is_nil(neigh) or MapSet.member?(grid.walls, wall_between(loc, neigh))
  end

  def neighbors(loc = { _row, _col }, grid, consider_walls? \\ true) do
    # Get all of the possible neighbors
    neighbors = for neigh <- [
      neigh_north(loc, grid),
      neigh_south(loc, grid),
      neigh_northwest(loc, grid),
      neigh_northeast(loc, grid), 
      neigh_southwest(loc, grid),
      neigh_southeast(loc, grid), ],
      !is_nil(neigh), do: neigh
    
    if consider_walls? do
      neighbors
      |> Enum.reject(&MapSet.member?(grid.walls, wall_between(loc, &1)))
    else
      neighbors
    end
  end

  def get_locations(%MazeWalls.Hex{nrows: nrows, ncols: ncols}) do
    for row <- 0..(nrows-1), col <- 0..(ncols-1), into: MapSet.new, do: { row, col }
  end

  # Get all of the locations in a given row
  # TODO: Check that row is legal
  def walk_row(row, grid) do
    for col <- 0..(grid.ncols-1), do: { row, col }
  end

end

defimpl MazeWalls.AnyGrid, for: MazeWalls.Hex do
  def wall_between(_grid, cell, neigh) do
    MazeWalls.Hex.wall_between(cell, neigh)
  end

  def neighbors(grid, cell, consider_walls? \\ true) do
    MazeWalls.Hex.neighbors(cell, grid, consider_walls?)
  end

  def all_cells(grid) do
    MazeWalls.Hex.get_locations(grid)
  end
  def with_walls(grid, walls) do
    %MazeWalls.Hex{ nrows: grid.nrows, ncols: grid.ncols, walls: MapSet.union(grid.walls, walls) }
  end
end
