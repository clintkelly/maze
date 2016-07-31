# MazeWalls

Implement maze algorithms, but use the approach from _Clojure Programming_ in which we model only
the walls between cells (and don't recreate an entire grid with lots of state and so on).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add maze_walls to your list of dependencies in `mix.exs`:

        def deps do
          [{:maze_walls, "~> 0.0.1"}]
        end

  2. Ensure maze_walls is started before your application:

        def application do
          [applications: [:maze_walls]]
        end

## Weirdness

I have found that sometimes `mix` does not compile the `AnyGrid` protocol properly when I run tests.
Very strange! So sometimes I have to run `mix test` twice. The time produces an error, the second
time works:

    in /Users/clint_kelly/play/elixir/maze_walls/ on master
    › mix test
    Compiling 1 file (.ex)
    ** (EXIT from #PID<0.46.0>) an exception was raised:
        ** (MatchError) no match of right hand side value: {:error, :no_beam_info}
            (mix) lib/mix/tasks/compile.protocols.ex:123: Mix.Tasks.Compile.Protocols.consolidate/4
            (elixir) lib/task/supervised.ex:94: Task.Supervised.do_apply/2
            (elixir) lib/task/supervised.ex:45: Task.Supervised.reply/5
            (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3

    16:10:50.356 [error] Task #PID<0.85.0> started from #PID<0.46.0> terminating
    ** (MatchError) no match of right hand side value: {:error, :no_beam_info}
        (mix) lib/mix/tasks/compile.protocols.ex:123: Mix.Tasks.Compile.Protocols.consolidate/4
        (elixir) lib/task/supervised.ex:94: Task.Supervised.do_apply/2
        (elixir) lib/task/supervised.ex:45: Task.Supervised.reply/5
        (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
    Function: #Function<8.10854390/0 in Mix.Tasks.Compile.Protocols.consolidate/6>
        Args: []

    in /Users/clint_kelly/play/elixir/maze_walls/ on master
    › mix test
    .....................................

    Finished in 1.2 seconds
    37 tests, 0 failures

    Randomized with seed 945302

    in /Users/clint_kelly/play/elixir/maze_walls/ on master
    ›

¯\\_(ツ)_/¯

## Example usage:

    Interactive Elixir (1.3.0) - press Ctrl+C to exit (type h() ENTER for help)
    iex(1)> maze = MazeWalls.AldousBroder.generate(%MazeWalls.Hex{})
    %MazeWalls.Hex{ncols: 5, nrows: 5,
     walls: #MapSet<[#MapSet<[{0, 0}, {1, 0}]>, #MapSet<[{0, 1}, {0, 2}]>,
      #MapSet<[{0, 1}, {1, 1}]>, #MapSet<[{0, 3}, {1, 2}]>,
      #MapSet<[{0, 3}, {1, 3}]>, #MapSet<[{0, 3}, {1, 4}]>,
      #MapSet<[{1, 0}, {2, 0}]>, #MapSet<[{1, 1}, {1, 2}]>,
      #MapSet<[{1, 1}, {2, 2}]>, #MapSet<[{1, 2}, {1, 3}]>,
      #MapSet<[{1, 2}, {2, 2}]>, #MapSet<[{1, 3}, {1, 4}]>,
      #MapSet<[{1, 3}, {2, 2}]>, #MapSet<[{1, 3}, {2, 4}]>,
      #MapSet<[{2, 0}, {2, 1}]>, #MapSet<[{2, 1}, {2, 2}]>,
      #MapSet<[{2, 1}, {3, 0}]>, #MapSet<[{2, 1}, {3, 1}]>,
      #MapSet<[{2, 1}, {3, 2}]>, #MapSet<[{2, 2}, {3, 2}]>,
      #MapSet<[{2, 3}, {3, 2}]>, #MapSet<[{2, 3}, {3, 3}]>,
      #MapSet<[{2, 4}, {3, 4}]>, #MapSet<[{3, 0}, {3, 1}]>,
      #MapSet<[{3, 0}, {4, 0}]>, #MapSet<[{3, 1}, {4, 1}]>,
      #MapSet<[{3, 1}, {4, 2}]>, #MapSet<[{3, 2}, {4, 2}]>,
      #MapSet<[{3, 3}, {4, 2}]>, #MapSet<[{3, 3}, {4, 4}]>,
      #MapSet<[{3, 4}, {4, 4}]>, #MapSet<[{4, 0}, {4, 1}]>]>}
    iex(2)> [a,b] = MapSet.to_list(MazeWalls.Dijkstra.farthest_apart_points(maze))
    [{3, 0}, {4, 0}]
    iex(3)> path = MazeWalls.Dijkstra.path_between_points(a, b, maze)
    [{3, 0}, {2, 0}, {1, 1}, {1, 0}, {0, 1}, {1, 2}, {0, 2}, {0, 3}, {0, 4}, {1, 4},
     {2, 4}, {2, 3}, {3, 4}, {3, 3}, {3, 2}, {3, 1}, {4, 0}]
    iex(4)> IO.puts MazeWalls.AnyGrid.as_text(maze, fn(loc,grid) -> if Enum.member?(path,loc), do: "*", else: " " end)
     ___     ___     ___
    /   \___/ * \___/ * \
    \___  * \     *     /
    / *  ___  * \___/ * \
    \___  * \___/   \   /
    / *     /   \   / * \
    \   /   \___  *  ___/
    / * \___/ * \___  * \
    \___/ *  ___  *  ___/
    / *  ___/   \   /   \
    \___/    ___     ___/
        \___/   \___/

    :ok
    iex(5)>
