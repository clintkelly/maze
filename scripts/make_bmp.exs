# Run with `mix run scripts/make_bmp.exs`
MazeWalls.Sidewinder.generate_with_sidewinder(20,20) |> MazeWalls.Bmp.as_bmp
