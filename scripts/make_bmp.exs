# Run with `mix run scripts/make_bmp.exs`

# Generate some maze.
grid = MazeWalls.Sidewinder.generate_with_sidewinder(10,10)

# Get the parts that are farthest apart
[a, b] = MapSet.to_list(MazeWalls.Dijkstra.farthest_apart_points(grid))
distances = MazeWalls.Dijkstra.dijkstra(a, grid)
path = MazeWalls.Dijkstra.trace_backward(a, b, grid, distances)

MazeWalls.Bmp.as_bmp(
  grid, 
  _cell_size = 10, 
  _cell_color = fn(loc) -> if Enum.member?(path, loc), do: Color.named(:blue), else: Color.named(:black) end)
