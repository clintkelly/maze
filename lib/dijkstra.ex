defmodule MazeWalls.Dijkstra do
  @moduledoc """
  Implements Dijkstra's algorithm for finding the distance from a starting
  point to every other point in the maze.
  """

  alias MazeWalls.AnyGrid

  @doc """


  """
  def dijkstra(root = {_,_}, grid) do
    dijkstra_step([root], grid, %{root => 0})
  end

  def get_new_frontier(frontier, grid, distances) do
    for cell = {_row, _col} <- frontier, 
      neigh = {_nrow, _ncol} <- AnyGrid.neighbors(grid, cell), 
      !Map.has_key?(distances, neigh),
      dist = distances[cell],
      into: Map.new,
      do: { neigh, dist + 1 }
  end

  @doc """
  Distances should include every cell in "frontier".
  """
  def dijkstra_step([], grid, distances) do
    # This is an empty frontier -> we are done!
    # Just assert that we have the distance to every cell.
    for cell <- AnyGrid.all_cells(grid), do: %{ ^cell => _dist } = distances
    distances
  end

  def dijkstra_step(frontier, grid, distances) do
    new_frontier = get_new_frontier(frontier, grid, distances)
    dijkstra_step(Map.keys(new_frontier), grid, Map.merge(distances, new_frontier))
  end

  def farthest_from(loc, grid) do
    distances_from_root = dijkstra(loc, grid)
    Enum.max_by(distances_from_root, fn {_loc, dist} -> dist end)
  end

  def farthest_apart_points(grid) do
    { start_point, _dist } = farthest_from({0,0}, grid)
    { end_point,   _dist } = farthest_from(start_point, grid)
    MapSet.new([start_point, end_point])
  end

  def path_between_points(start_point, end_point, grid) do
    # Get all of the distances from the starting point
    distances = dijkstra(start_point, grid)

    # Now walk backward from the destination point
    trace_backward(start_point, end_point, grid, distances)
  end

  # A little confusing because the eventually path actually starts with "origin" and ends with "current"...
  def trace_backward(origin = {_,_}, current = {_, _}, grid, distances, path_so_far \\ []) do
    new_path = [ current | path_so_far ]
    if current == origin do
      new_path
    else
      # Get all of the neighbors.
      neighbors = AnyGrid.neighbors(grid, current)

      # Should be exactly one neighbor with distance one less than current node.
      [ predecessor ] = Enum.filter(neighbors, fn loc -> distances[loc] == distances[current] - 1 end)

      trace_backward(origin, predecessor, grid, distances, new_path)
    end
  end
end
