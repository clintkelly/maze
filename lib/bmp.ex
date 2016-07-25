defmodule MazeWalls.Bmp do

  import Canvas
  import Size
  import Color

  alias MazeWalls.Grid

  def as_bmp(grid, cell_size \\ 10, cell_color \\ fn(_loc) -> Color.named(:black) end) do

    # Add 1 to height and width for walls on south and east
    canvas = Canvas.size(%Size{height: grid.nrows*cell_size+1, width: grid.ncols*cell_size+1}) 
    |> Canvas.fill(color: Color.named(:black))

    canvas = Enum.reduce(
      Grid.get_locations(grid),
      canvas,
      fn cell, canvas -> with_cell(canvas, cell, grid, cell_size, cell_color) end)

    Bump.write(filename: "foo.bmp", canvas: canvas)

  end

  def with_cell(canvas, cell={_row,_col}, grid, cell_size \\ 10, cell_color \\ fn(_loc) -> Color.named(:black) end) do
    canvas
    |> maybe_with_wall_to_north(cell, grid, cell_size)
    |> maybe_with_wall_to_west(cell, grid, cell_size)
    |> maybe_with_wall_to_east(cell, grid, cell_size)
    |> maybe_with_wall_to_south(cell, grid, cell_size)
    |> with_cell_fill(cell, grid, cell_size, cell_color)
  end

  def with_cell_fill(canvas, cell={row,col}, grid, cell_size, cell_color) do
      x1 = col * cell_size + 1
      y1 = (grid.nrows - (row+1)) * cell_size + 1
      Canvas.fill(
        canvas, 
        color: cell_color.(cell),
        rect: %Rect{ 
          origin: %Point{ x: x1, y: y1 }, 
          size: %Size{ height: cell_size-1, width: cell_size-1 },
        }
      )
  end

  def maybe_with_wall_to_east(canvas, cell={row,col}, grid, cell_size \\ 10) do
    if !Grid.wall_to_east?(cell, grid) do
      canvas
    else
      # SE corner
      _ = """
      If we have a 5x5 grid and we are looking at cell 0,0 and we want to draw a wall to the east:
      x1 should be 10 (beginning of next cell's border)
      y1 should be 40
      """
      x1 = (col+1) * cell_size
      y1 = (grid.nrows - (row+1)) * cell_size
      Canvas.fill(
        canvas, 
        color: Color.named(:red), 
        rect: %Rect{ 
          origin: %Point{ x: x1, y: y1 }, 
          size: %Size{ height: cell_size+1, width: 1 },
        }
      )
    end
  end

  def maybe_with_wall_to_south(canvas, cell={row,col}, grid, cell_size \\ 10) do
    if !Grid.wall_to_south?(cell, grid) do
      canvas
    else
      # SW corner
      _ = """
      If we have a 5x5 grid and we are looking at cell 0,0 and we want to draw a wall to the south:
      x1 should be 0
      y1 should be 40

      If we have a 5x5 grid and we are looking at cell 0,4 and we want to draw a wall to the south:
      y1 should be 0
      """
      x1 = col * cell_size
      y1 = (grid.nrows - (row+1)) * cell_size
      Canvas.fill(
        canvas, 
        color: Color.named(:red), 
        rect: %Rect{ 
          origin: %Point{ x: x1, y: y1 }, 
          size: %Size{ height: 1, width: cell_size+1 },
        }
      )
    end
  end

  def maybe_with_wall_to_north(canvas, cell={row,col}, grid, cell_size \\ 10) do
    if !Grid.is_north_edge?(cell, grid) do
      canvas
    else
      # NW corner
      x1 = col * cell_size
      y1 = (grid.nrows - row) * cell_size
      Canvas.fill(
        canvas, 
        color: Color.named(:red), 
        rect: %Rect{ 
          origin: %Point{ x: x1, y: y1 }, 
          size: %Size{ height: 1, width: cell_size+1 },
        }
      )
    end
  end

  def maybe_with_wall_to_west(canvas, cell={row,col}, grid, cell_size \\ 10) do
    if !Grid.is_west_edge?(cell, grid) do
      canvas
    else
      # NW corner
      x1 = col * cell_size
      y1 = (grid.nrows - (row+1)) * cell_size
      Canvas.fill(
        canvas,
        color: Color.named(:red),
        rect: %Rect{
          origin: %Point{ x: x1, y: y1 },
          size: %Size{ height: cell_size+1, width: 1 },
        }
      )
    end
  end
end
