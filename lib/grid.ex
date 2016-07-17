defmodule MazeWalls.Grid do
  defstruct nrows: 5, ncols: 5, walls: MapSet.new

  defmodule Ascii do

    def as_ascii(grid = %MazeWalls.Grid{nrows: nrows, ncols: ncols, walls: walls}) do
      # Start by drawing the top of the maze
      top = "+" <> String.duplicate("---+", ncols) <> "\n"

      Enum.reduce(
        0..(nrows-1),
        top,
        fn(row, str) ->
          str <> walls_between_columns(grid, row) <> walls_between_rows(grid, row)
        end)
    end

    def walls_between_columns(
      grid = %MazeWalls.Grid{nrows: nrows, ncols: ncols, walls: walls},
      row) do
        Enum.reduce(
          0..(ncols-1), 
          "|", # Start with wall on the west edge
          fn(col, str) ->
            loc = { row, col }
            wall_east = MapSet.new([loc, MazeWalls.Grid.neigh_east(loc)])
            if wall_east in walls or MazeWalls.Grid.is_east_edge?(grid, loc) do
              str <> "   |"
            else
              str <> "    "
            end
          end) <> "\n"
    end

    def walls_between_rows(
      grid = %MazeWalls.Grid{nrows: nrows, ncols: ncols, walls: walls},
      row) do
        Enum.reduce(
          0..(ncols-1), 
          "+", # Start with wall on the west edge
          fn(col, str) ->
            loc = { row, col }
            wall_south = MapSet.new([loc, MazeWalls.Grid.neigh_south(loc)])
            cond do
              MazeWalls.Grid.is_south_edge?(grid, loc) -> str <> "---+"
              wall_south in walls -> str <> "---+"
              true -> str <> "   +"
            end

          end) <> "\n"
    end
  end

  # TODO: Throw errors / return nil if neighbors do not exist?
  def neigh_east({row, col}), do: {row, col+1}
  def neigh_west({row, col}), do: {row, col-1}
  def neigh_north({row, col}), do: {row-1, col}
  def neigh_south({row, col}), do: {row+1, col}

  def get_locations(grid = %MazeWalls.Grid{nrows: nrows, ncols: ncols, walls: walls}) do
    for row <- 0..(nrows-1), col <- 0..(ncols-1), into: MapSet.new, do: { row, col }
  end

  def is_north_edge?(grid, { row, col }), do: row == 0
  def is_south_edge?(grid, { row, col }), do: row == grid.nrows - 1 
  def is_east_edge?(grid, { row, col }), do: col == grid.ncols - 1

end
