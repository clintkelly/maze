defmodule MazeWalls.AldousBroder do
  alias MazeWalls.AnyGrid
  alias MazeWalls.Grid

  @moduledoc """
  Aldous-Broder algorithm.

  Start anywhere in the grid you want, and choose a random neighbor. Move to
  that neighbor, and if it hasn’t previously been visited, link it to the prior
  cell. Repeat until every cell has been visited.

  """

  def generate(grid \\ %Grid{nrows: 5, ncols: 5}) do
    # Start somewhere!
    [starting_cell] = Enum.take(AnyGrid.all_cells(grid), 1)

    links = step(starting_cell, grid, MapSet.new, MapSet.new)
    AnyGrid.with_walls(grid, walls_from_links(links, grid))
  end

  def go_to_neighbor(cell={_,_}, grid, visited, links, neighbor_chooser \\ &Enum.random/1) do
    # Get the neighbors of the cell.
    neighbors = MazeWalls.AnyGrid.neighbors(grid, cell, false)
    
    # Pick a random cell.
    neigh = neighbor_chooser.(neighbors)

    # If it is not visited, add a link.
    updated_links = if MapSet.member?(visited, neigh) do
      links
    else
      MapSet.put(links, link_between(cell, neigh))
    end

    {neigh, MapSet.put(visited, cell), updated_links }
  end

  def step(cell={_,_}, grid, visited, links, neighbor_chooser \\ &Enum.random/1) do
    # If we have visited all cells, then we are done.
    if MapSet.size(visited) == grid.ncols * grid.nrows do
      links
    else
      # Add the cell to the visited list
      {neigh={_,_}, updated_visited, updated_links} = go_to_neighbor(cell, grid, visited, links, neighbor_chooser)
      step(neigh, grid, updated_visited, updated_links)
    end
  end

  def link_between(cell_a={_,_}, cell_b={_,_}) do
    MapSet.new [ cell_a, cell_b ]
  end

  def walls_from_links(links, grid) do
    walls = for cell <- AnyGrid.all_cells(grid),
      neigh <- AnyGrid.neighbors(grid, cell, false),
      link = link_between(cell, neigh),
      !MapSet.member?(links, link),
      into: MapSet.new,
      do: AnyGrid.wall_between(grid, cell, neigh)
    walls
  end
end
