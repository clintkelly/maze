defmodule MazeWalls.Hex do
  @moduledoc """
  Hex grid.
  """
  defstruct nrows: 5, ncols: 5, walls: MapSet.new

  require Integer
  alias MazeWalls.AnyGrid

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
  def neigh_north(_loc={row, col}, grid), do: cell_at(grid, row-1, col)
  def neigh_south(_loc={row, col}, grid), do: cell_at(grid, row+1, col)

  # East / west
  defp north_diagonal_row(_loc={row, col}) do
    if Integer.is_even(col), do: row - 1, else: row
  end
  
  defp south_diagonal_row(_loc={row, col}) do
    if Integer.is_even(col), do: row, else: row + 1
  end

  def neigh_northeast( loc={_row, col}, grid), do: cell_at(grid, north_diagonal_row(loc), col+1 )
  def neigh_southeast( loc={_row, col}, grid), do: cell_at(grid, south_diagonal_row(loc), col+1 )
  
  def neigh_northwest( loc={_row, col}, grid), do: cell_at(grid, north_diagonal_row(loc), col-1 )
  def neigh_southwest( loc={_row, col}, grid), do: cell_at(grid, south_diagonal_row(loc), col-1 )

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


  # ----------------------------------------------------------------------------
  # Code for drawing the hex grid as ASCII.

  @doc """
  Return a text version of the maze.

  Should look something like:

   ___     ___
  /   \___/   \
  \___    \   /
  /    ___    \
  \___/   \___/
  """

  def as_text(grid) do
    # For every cell, get {row,col} => char entry / entries for every wall
    # Then turn that map of {row,col} => char into text (fill in blank with " ")
    AnyGrid.all_cells(grid)
    |> Enum.flat_map(fn cell -> text_walls_for_cell(grid, cell) end)
    |> Map.new
    |> draw
  end

  defp draw(positions_to_walls) do
    # Get the biggest column
    {_row, max_text_col} = positions_to_walls
    |> Map.keys
    |> Enum.max_by(fn {_row, col} -> col end)

    {max_text_row, _col} = positions_to_walls
    |> Map.keys
    |> Enum.max_by(fn {row, _col} -> row end)

    for row <- 0..max_text_row,
      col <- 0..max_text_col,
      into: "" do
        char = Map.get(positions_to_walls, {row,col}, " ")
        if col == max_text_col, do: char <> "\n", else: char
      end
  end

  defp text_walls_for_cell(grid, cell = {_row, _col} ) do
    []
    |> with_wall_to_northwest(grid, cell)
    |> with_wall_to_northeast(grid, cell)
    |> with_wall_to_southeast(grid, cell)
    |> with_wall_to_southwest(grid, cell)
    |> with_wall_to_north(grid, cell)
    |> with_wall_to_south(grid, cell)
  end

  # Helper methods for creating text walls.
  # Note that every character from an even logical column is one text row lower.
  defp twall(_cell={_gridrow, gridcol}, row, col, char) when Integer.is_even(gridcol), do: { { row  , col }, char }
  defp twall(_cell={_gridrow, gridcol}, row, col, char) when Integer.is_odd(gridcol),  do: { { row+1, col }, char }

  @diag_slash "/"
  @diag_backslash "\\"
  # Use these instead for slightly-nicer-looking unicode.
  #@diag_slash to_string([0x2571])
  #@diag_backslash to_string([0x2572])

  defp with_wall_to_northwest(text_walls, grid, cell={row, col}) do
    if wall_to_northwest?(cell, grid), do: [ twall(cell, 2 * row + 1, 4 * col, @diag_slash) | text_walls ], else: text_walls
  end

  defp with_wall_to_northeast(text_walls, grid, cell={row, col}) do
    if wall_to_northeast?(cell, grid), do: [ twall(cell, 2 * row + 1, 4 * col + 4, @diag_backslash) | text_walls ], else: text_walls
  end

  defp with_wall_to_southwest(text_walls, grid, cell={row, col}) do
    # Wall to southwest is one text row below wall to northwest
    if wall_to_southwest?(cell, grid), do: [ twall(cell, 2 * row + 2, 4 * col, @diag_backslash) | text_walls ], else: text_walls
  end

  defp with_wall_to_southeast(text_walls, grid, cell={row, col}) do
    # Wall to southeast is one text row below wall to northeast
    if wall_to_southeast?(cell, grid), do: [ twall(cell, 2 * row + 2, 4 * col + 4, @diag_slash) | text_walls ], else: text_walls
  end

  defp with_wall_to_north(text_walls, grid, cell={row, col}) do
    # Wall to north is at tcol = 4 * col + 1, trow = 2 * row
    if wall_to_north?(cell, grid) do
      [
        twall(cell, 2 * row, 4 * col + 1, "_"),
        twall(cell, 2 * row, 4 * col + 2, "_"),
        twall(cell, 2 * row, 4 * col + 3, "_") | text_walls
      ]
    else
      text_walls
    end
  end

  defp with_wall_to_south(text_walls, grid, cell={row, col}) do
    # Wall to south is at tcol = 4 * col + 1, trow = 2 * row + 2
    if wall_to_south?(cell, grid) do
      [
        twall(cell, 2 * row + 2, 4 * col + 1, "_"),
        twall(cell, 2 * row + 2, 4 * col + 2, "_"),
        twall(cell, 2 * row + 2, 4 * col + 3, "_") | text_walls
      ]
    else
      text_walls
    end
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

  def as_text(grid) do
    MazeWalls.Hex.as_text(grid)
  end
end
