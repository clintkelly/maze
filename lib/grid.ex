defmodule MazeWalls.Grid do
  defstruct nrows: 5, ncols: 5, walls: MapSet.new

  defmodule Ascii do

    def as_ascii(grid = %MazeWalls.Grid{nrows: nrows, ncols: ncols}, cell_contents \\ fn(_loc, _grid)  -> " " end ) do
      # Start by drawing the top of the maze
      top = "+" <> String.duplicate("---+", ncols) <> "\n"

      Enum.reduce(
        0..(nrows-1),
        top,
        fn(row, str) ->
          str <> walls_between_columns(grid, row, cell_contents) <> walls_between_rows(grid, row)
        end)
    end

    def walls_between_columns(grid = %MazeWalls.Grid{ncols: ncols}, row, cell_contents \\ fn(_loc, _grid) -> " " end) do
        Enum.reduce(
          0..(ncols-1), 
          "|", # Start with wall on the west edge
          fn(col, str) ->
            if MazeWalls.Grid.wall_to_east?({row,col}, grid) do
              str <> " " <> cell_contents.({row,col}, grid) <> " |"
            else
              str <> " " <> cell_contents.({row,col}, grid) <> "  "
            end
          end) <> "\n"
    end

    def walls_between_rows(grid = %MazeWalls.Grid{ncols: ncols}, row) do
        Enum.reduce(
          0..(ncols-1), 
          "+", # Start with wall on the west edge
          fn(col, str) ->
            if MazeWalls.Grid.wall_to_south?({row,col}, grid) do
              str <> "---+"
            else
              str <> "   +"
            end
          end) <> "\n"
    end
  end

  # Return the neighboring cell, regardless of walls. Returns nil if you are on the edge of the grid.
  def neigh_east( loc={row, col}, grid), do: if is_east_edge?( loc, grid), do: nil, else: {row, col+1}
  def neigh_west( loc={row, col}, grid), do: if is_west_edge?( loc, grid), do: nil, else: {row, col-1}
  def neigh_north(loc={row, col}, grid), do: if is_north_edge?(loc, grid), do: nil, else: {row-1, col}
  def neigh_south(loc={row, col}, grid), do: if is_south_edge?(loc, grid), do: nil, else: {row+1, col}

  def get_locations(%MazeWalls.Grid{nrows: nrows, ncols: ncols}) do
    for row <- 0..(nrows-1), col <- 0..(ncols-1), into: MapSet.new, do: { row, col }
  end

  # Get all of the locations in a given row
  # TODO: Check that row is legal
  def walk_row(row, grid) do
    for col <- 0..(grid.ncols-1), do: { row, col }
  end

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

  def wall_between(cell={_row,_col}, neigh={_row2,_col2}) do
    # TODO: Assert the cells are actually neighbors!
    MapSet.new([cell, neigh])
  end

  def neighbors(loc = { _row, _col }, grid) do
    # Get all of the possible neighbors
    for neigh <- [ neigh_east(loc, grid), neigh_west(loc, grid), neigh_north(loc, grid), neigh_south(loc, grid) ],
      !is_nil(neigh),
      # Filter out any with walls
      !MapSet.member?(grid.walls, wall_between(loc, neigh)), do: neigh
  end

end
