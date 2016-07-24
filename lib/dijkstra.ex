defmodule MazeWalls.Dijkstra do
  @moduledoc """
  Implements Dijkstra's algorithm for finding the distance from a starting
  point to every other point in the maze.
  """

  @doc """


  """
  def dijkstra(root = {_,_}, grid) do
    dijkstra_step([root], grid, %{root => 0})
  end

  def get_new_frontier(frontier, grid, distances) do
    for cell = {_row, _col} <- frontier, 
      neigh = {_nrow, _ncol} <- MazeWalls.Grid.neighbors(cell, grid), 
      !Map.has_key?(distances, neigh),
      dist = distances[cell],
      into: Map.new,
      do: { neigh, dist + 1 }
  end

  @doc """
  Distances should include every cell in "frontier".
  """
  def dijkstra_step([], grid, distances) do
    # Assertion that you have the distance to every cell.
    for cell <- MazeWalls.Grid.get_locations(grid), do: %{ ^cell => _dist } = distances
    distances
  end

  def dijkstra_step(frontier, grid, distances) do
    new_frontier = get_new_frontier(frontier, grid, distances)
    dijkstra_step(Map.keys(new_frontier), grid, Map.merge(distances, new_frontier))
  end
end
