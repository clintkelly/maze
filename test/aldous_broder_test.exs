defmodule AldousBroderTest do
  use ExUnit.Case

  alias MazeWalls.Grid
  alias MazeWalls.AldousBroder
  alias MazeWalls.Dijkstra

  setup do
    grid = %Grid{
      nrows: 2,
      ncols: 2,
      walls: MapSet.new([
        Grid.wall_between({0,0}, {1,0})
      ])
    }

    _grid_as_ascii = """
      +---+---+
      |       |
      +---+   +
      |       |
      +---+---+
      """

    {:ok, grid: grid}
  end

  test "walls from links", %{grid: grid} do
    links = MapSet.new([
      AldousBroder.link_between({0,0}, {0,1}),
      AldousBroder.link_between({0,1}, {1,1}),
      AldousBroder.link_between({1,1}, {1,0}),
    ])

    walls = MapSet.new([
      Grid.wall_between({0,0}, {1,0})
    ])
    assert AldousBroder.walls_from_links(links, grid) == walls
  end

  test "go to neighbor when neighbor is already visited", %{grid: grid} do
    root = {0,0}
    neigh_east = {0,1}

    { neigh, visited, links } = AldousBroder.go_to_neighbor(
      root,
      grid,
      MapSet.new([ neigh_east ]), # east neighbor is already visited
      MapSet.new,
      fn neigh_list=[a=^neigh_east, b] -> a end)

    assert neigh == neigh_east
    assert visited == MapSet.new [ root, neigh_east ]
    assert links == MapSet.new
  end

  test "go to neighbor when neighbor has not been visited", %{grid: grid} do
    root = {0,0}
    neigh_east = {0,1}
    neigh_south = {1,0}

    { neigh, visited, links } = AldousBroder.go_to_neighbor(
      root,
      grid,
      MapSet.new([ neigh_east ]), # east neighbor is already visited
      MapSet.new,
      fn neigh_list=[a=^neigh_east, b=^neigh_south] -> b end)

    assert neigh == neigh_south
    assert visited == MapSet.new [ root, neigh_east ]
    assert links == MapSet.new [ AldousBroder.link_between(root, neigh_south) ]
  end

  test "works with Dijkstra's algorithm (maze is valid)" do
    for _ <- 1..100 do
      maze = AldousBroder.generate(10,10)
      Dijkstra.dijkstra({0,0}, maze)
    end
  end

end


