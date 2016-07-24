defmodule MazeWalls.Ascii do

  alias MazeWalls.Grid

  def as_ascii(grid = %Grid{nrows: nrows, ncols: ncols}, cell_contents \\ fn(_loc, _grid)  -> " " end ) do
    # Start by drawing the top of the maze
    top = "+" <> String.duplicate("---+", ncols) <> "\n"

    Enum.reduce(
      0..(nrows-1),
      top,
      fn(row, str) ->
        str <> walls_between_columns(grid, row, cell_contents) <> walls_between_rows(grid, row)
      end)
  end

  def walls_between_columns(grid = %Grid{ncols: ncols}, row, cell_contents \\ fn(_loc, _grid) -> " " end) do
      Enum.reduce(
        0..(ncols-1), 
        "|", # Start with wall on the west edge
        fn(col, str) ->
          if Grid.wall_to_east?({row,col}, grid) do
            str <> " " <> cell_contents.({row,col}, grid) <> " |"
          else
            str <> " " <> cell_contents.({row,col}, grid) <> "  "
          end
        end) <> "\n"
  end

  def walls_between_rows(grid = %Grid{ncols: ncols}, row) do
      Enum.reduce(
        0..(ncols-1), 
        "+", # Start with wall on the west edge
        fn(col, str) ->
          if Grid.wall_to_south?({row,col}, grid) do
            str <> "---+"
          else
            str <> "   +"
          end
        end) <> "\n"
  end
end
