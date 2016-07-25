defmodule SidewinderTest do
  use ExUnit.Case

  alias MazeWalls.Sidewinder
  alias MazeWalls.Grid
  alias MazeWalls.Dijkstra

  test "does not create any walls for the north edge" do
    grid = %Grid{ nrows: 5, ncols: 5 }
    north_row = Grid.walk_row(0, grid)
    walls = Sidewinder.generate_walls_for_row(north_row, grid)
    assert walls == MapSet.new
  end

  test "creates walls for a non-north edge" do
    grid = %Grid{ nrows: 5, ncols: 5 }
    north_row = Grid.walk_row(1, grid)
    walls = Sidewinder.generate_walls_for_row(north_row, grid)
    assert walls != MapSet.new
  end

  test "stepping through a cell on the north edge always adds to the current run" do
    grid = %Grid{ nrows: 5, ncols: 5 }
    { run, walls, _grid } = Sidewinder.step_through_cell( { 0, 1 }, { [], MapSet.new, grid } )
    assert walls == MapSet.new
    assert run == [ { 0, 1 } ]
  end

  test "stepping through the north-east corner adds to the current run" do
    grid = %Grid{ nrows: 5, ncols: 5 }
    { run, walls, _grid } = Sidewinder.step_through_cell( { 0, 4 }, { [], MapSet.new, grid } )
    assert walls == MapSet.new
    assert run == [ { 0, 4 } ]
  end

  test "stepping through a cell on the east edge ends the run" do
    grid = %Grid{ nrows: 5, ncols: 5 }
    { run,  walls, _grid } = Sidewinder.step_through_cell( { 1, 4 }, { [], MapSet.new, grid } )
    assert walls == MapSet.new
    assert run == []
  end

  test "should have north walls for all but one cell in a run" do
    grid = %Grid{ nrows: 5, ncols: 5 }
    run = [ {1,1}, {1,2} ]
    walls = Sidewinder.get_north_walls_for_run(run, grid)
    assert MapSet.size(walls) == 1
  end

  test "works with dijkstra" do
    for _ <- 0..100 do
      grid = Sidewinder.generate_with_sidewinder(20, 20)
      _distances = Dijkstra.dijkstra({0,0}, grid)
    end
  end
end


