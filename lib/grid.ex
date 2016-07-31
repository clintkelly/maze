defmodule MazeWalls.Grid do
  defstruct nrows: 5, ncols: 5, walls: MapSet.new

  def wall_between(cell={_row,_col}, neigh={_row2,_col2}) do
    # TODO: Assert the cells are actually neighbors!
    MapSet.new([cell, neigh])
  end

  # Return the neighboring cell, regardless of walls. Returns nil if you are on the edge of the grid.
  def neigh_east( loc={row, col}, grid), do: if is_east_edge?( loc, grid), do: nil, else: {row, col+1}
  def neigh_west( loc={row, col}, grid), do: if is_west_edge?( loc, grid), do: nil, else: {row, col-1}
  def neigh_north(loc={row, col}, grid), do: if is_north_edge?(loc, grid), do: nil, else: {row-1, col}
  def neigh_south(loc={row, col}, grid), do: if is_south_edge?(loc, grid), do: nil, else: {row+1, col}

  def is_north_edge?({ row, _col }, _grid), do: row == 0
  def is_south_edge?({ row, _col }, grid ), do: row == grid.nrows - 1 
  def is_east_edge?( { _row, col }, grid ), do: col == grid.ncols - 1
  def is_west_edge?( { _row, col }, _grid), do: col == 0

  def wall_to_north?(loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_north/2)
  def wall_to_south?(loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_south/2)
  def wall_to_east?( loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_east/2)
  def wall_to_west?( loc={_row,_col}, grid), do: wall_to?(loc, grid, &neigh_west/2)

  defp wall_to?(loc, grid, neigh_getter) do
    neigh = neigh_getter.(loc, grid)
    is_nil(neigh) or MapSet.member?(grid.walls, wall_between(loc, neigh))
  end

  def neighbors(loc = { _row, _col }, grid, consider_walls? \\ true) do
    # Get all of the possible neighbors
    neighbors = for neigh <- [
      neigh_north(loc, grid), neigh_east(loc, grid), neigh_south(loc, grid), neigh_west(loc, grid) ],
      !is_nil(neigh), do: neigh
    
    if consider_walls? do
      neighbors
      |> Enum.reject(&MapSet.member?(grid.walls, wall_between(loc, &1)))
    else
      neighbors
    end
  end

  def get_locations(%MazeWalls.Grid{nrows: nrows, ncols: ncols}) do
    for row <- 0..(nrows-1), col <- 0..(ncols-1), into: MapSet.new, do: { row, col }
  end

  # Get all of the locations in a given row
  # TODO: Check that row is legal
  def walk_row(row, grid) do
    for col <- 0..(grid.ncols-1), do: { row, col }
  end

end

defimpl MazeWalls.AnyGrid, for: MazeWalls.Grid do
  def wall_between(_grid, cell, neigh) do
    MazeWalls.Grid.wall_between(cell, neigh)
  end

  def neighbors(grid, cell, consider_walls? \\ true) do
    MazeWalls.Grid.neighbors(cell, grid, consider_walls?)
  end

  def all_cells(grid) do
    MazeWalls.Grid.get_locations(grid)
  end
  def with_walls(grid, walls) do
    %MazeWalls.Grid{ nrows: grid.nrows, ncols: grid.ncols, walls: MapSet.union(grid.walls, walls) }
  end
end
