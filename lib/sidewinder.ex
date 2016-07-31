defmodule MazeWalls.Sidewinder do
  @moduledoc """
  Sidewinder algorithm for making mazes.

  For each row from west to east:
  - For each cell, decide whether you want to remove a wall on the north or the east
  - If east (and not at the end of the row!) keep going
  - If north, pick a random location from all of the previous connected cells
    to your west in which to put the hole in the wall

  """

  @doc """
  Runs sidewinder algorithm to create a maze.
  """
  def generate_with_sidewinder(num_rows \\ 5, num_cols \\ 5) do
    g = %MazeWalls.Grid{nrows: num_rows, ncols: num_cols}

    # Go through every location
    # Keep track of the current "run" -> use reduce
    walls = 0..(g.nrows-1)
    |> Enum.map(&MazeWalls.Grid.walk_row(&1, g)) # Provides a list of lists
    |> Enum.map(&generate_walls_for_row(&1, g)) # Gives a list of sets of walls
    |> Enum.reduce(&MapSet.union/2)

    %MazeWalls.Grid{ nrows: num_rows, ncols: num_cols, walls: walls }
  end

  # Row is a list of { row, col } tuples, from west to east
  def generate_walls_for_row(row_list, grid) do
    # Accumulator is current run, walls, and grid
    { _run, walls, _grid } = Enum.reduce(row_list, { [], MapSet.new, grid }, &step_through_cell/2)
    walls
  end

  def get_possible_path_dirs(loc, grid) do
    cond do
      # If you are on the north edge, hole must go to the east
      MazeWalls.Grid.is_north_edge?(loc, grid) -> [:east]
      # Otherwise, if you are on the east edge, hole must go to the north
      MazeWalls.Grid.is_east_edge?(loc, grid) -> [:north]
      true -> [:north, :east]
    end
  end

  @doc """
  Run the sidewinder algorithm for a single cell.

  - Choose a direction (east or north) for a hole in the grid
  - If north, pick a cell in the run for the north hole and reset the run
  - If east, just add the current cell to the run
  """
  def step_through_cell(loc, { current_run, walls, grid }) do
    # Should be at least one of [:north, :east]
    possible_path_dirs = get_possible_path_dirs(loc, grid)
    dir = Enum.random(possible_path_dirs)

    run = [ loc | current_run ]

    case dir do
      :north ->
        # Add walls to the north of all but one cell in the run
        north_walls = get_north_walls_for_run(run, grid)

        # Add wall to the east of the current cell
        east_wall = create_wall_to_east_of(loc, grid)

        new_walls = north_walls
        |> MapSet.put(east_wall)
        |> Enum.reject(&(is_nil(&1)))
        |> MapSet.new
        |> MapSet.union(walls)


        # Make the run empty
        { [], new_walls, grid }

      :east ->
        # Add the current cell to the run and continue
        # (Note that this works out fine when you are processing the north-most row)
        { run, walls, grid}
    end
  end

  def get_north_walls_for_run(run, grid) do
        # Add walls to the north of all but one cell in the run
        run
        |> Enum.take_random(length(run)-1)
        |> Enum.map(&create_wall_to_north_of(&1, grid))
        |> MapSet.new
  end

  def create_wall_to_north_of(loc, grid) do
    # If this is the northern row, just return nil
    cond do
      MazeWalls.Grid.is_north_edge?(loc, grid) -> nil
      true -> MapSet.new([loc, MazeWalls.Grid.neigh_north(loc, grid)])
    end
  end

  def create_wall_to_east_of(loc = { _row, _col }, grid) do
    # If this is the east edge, return nil
    cond do
      MazeWalls.Grid.is_east_edge?(loc, grid) -> nil
      true -> MapSet.new([loc, MazeWalls.Grid.neigh_east(loc, grid)])
    end
  end
end
