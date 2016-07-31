defmodule MazeWalls.AldousBroder do
  alias MazeWalls.AnyGrid

  @moduledoc """
  Aldous-Broder algorithm.

  Start anywhere in the grid you want, and choose a random neighbor. Move to
  that neighbor, and if it hasn’t previously been visited, link it to the prior
  cell. Repeat until every cell has been visited.

  """

  def generate(num_rows \\ 5, num_cols \\ 5) do
    g = %MazeWalls.Grid{nrows: num_rows, ncols: num_cols}

    # Sanity test
    _ = AnyGrid.wall_between(g, {0,0}, {0,0})

    links = step({0,0}, g, MapSet.new, MapSet.new)
    walls = walls_from_links(links, g)
    %MazeWalls.Grid{ nrows: num_rows, ncols: num_cols, walls: walls }
  end

  def go_to_neighbor(cell={_,_}, grid, visited, links, neighbor_chooser \\ &Enum.random/1) do
    # Get the neighbors of the cell.
    #neighbors = MazeWalls.Grid.neighbors(cell, grid, consider_walls?=false)
    neighbors = MazeWalls.Grid.neighbors(cell, grid, false)
    
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
    walls = for cell <- MazeWalls.Grid.get_locations(grid),
      neigh <- MazeWalls.Grid.neighbors(cell, grid, false),
      link = link_between(cell, neigh),
      !MapSet.member?(links, link),
      into: MapSet.new,
      #do: MazeWalls.Grid.wall_between(cell, neigh)
      do: AnyGrid.wall_between(grid, cell, neigh)
    walls
  end
end
