defmodule MazeWalls.AldousBroder do
  @moduledoc """
  Aldous-Broder algorithm.

  Start anywhere in the grid you want, and choose a random neighbor. Move to
  that neighbor, and if it hasn’t previously been visited, link it to the prior
  cell. Repeat until every cell has been visited.

  """

  alias MazeWalls.Grid

  def generate(num_rows \\ 5, num_cols \\ 5) do
    g = %MazeWalls.Grid{nrows: num_rows, ncols: num_cols}
    links = step({0,0}, g, MapSet.new, MapSet.new)
    walls = walls_from_links(links, g)
    %MazeWalls.Grid{ nrows: num_rows, ncols: num_cols, walls: walls }
  end

  def go_to_neighbor(cell={_,_}, grid, visited, links, neighbor_chooser \\ &Enum.random/1) do
    # Get the neighbors of the cell.
    neighbors = Grid.neighbors(cell, grid, consider_walls?=false)
    
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
    walls = for cell <- Grid.get_locations(grid),
      neigh <- Grid.neighbors(cell, grid, consider_walls?=false),
      link = link_between(cell, neigh),
      !MapSet.member?(links, link),
      into: MapSet.new,
      do: Grid.wall_between(cell, neigh)
  end
end
