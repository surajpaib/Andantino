
include("board_functions.jl")
include("utils.jl")
include("win_conditions.jl")
include("ui_render.jl")
include("transposition_tables.jl")
include("performance_analysis.jl")


# Global Variables

# Max time allowed per move
max_time = 2

andantino_board = create_board()

# Board copy for undo move
original_board = deepcopy(andantino_board)

# Global variables selecting enhancements

alphabeta = true
move_count = 0
pvs = false
search_ply = 5
iterativedeepening = true


# performance_table = create_performance_table()
current_time = time()



# AI vs AI mode Play
function runAIvsAI()
    while true
      global current_time = time()
      global original_board = deepcopy(andantino_board)
      move = run_search_algorithm(22)
      global move_count = move_count + 1
      # Adapt Time based on Game status
      adapt_time_bound()

      # CSV.write("metrics/performance_table.csv", performance_table)

      if move_count > 4 && check_game_end(move, andantino_board)
        restart_game("WHITE")
        return
      end

      global current_time = time()
      move = run_search_algorithm(11)
      # CSV.write("metrics/performance_table.csv", performance_table)

      if move_count > 3 && check_game_end(move, andantino_board)
        restart_game("BLACK")
        return
      end

      render_body("none")

    end
end


function play_handler(turn::String, search_ply::Int64, arg)
      global original_board = deepcopy(andantino_board)
      piece_map = Dict()
      global current_time = time()
      if turn == "white"
        player = 22
        opponent = 11
        piece_map[player] = "WHITE"
        piece_map[opponent] = "BLACK"

      else
        player = 11
        opponent = 22
        piece_map[player] = "BLACK"
        piece_map[opponent] = "WHITE"

      end

      # Check if played move is valid 
      if play_turn(player, collect(eval(Meta.parse(arg))))
        global move_count = move_count + 1

        # Adapt Time based on Game status
        adapt_time_bound()

        # CSV.write("metrics/$current_time-$alphabeta-$search_ply-$iterativedeepening-$pvs.csv", performance_table)

        if move_count > 4 && check_game_end(collect(eval(Meta.parse(arg))), andantino_board)
          render_body(turn)
          sleep(2)
          restart_game(piece_map[player])
          return
        end

        # Run search algorithm for the AI player 
        move = run_search_algorithm(opponent)
        
        if move_count > 3 && check_game_end(move, andantino_board)
          render_body(turn)
          sleep(2)
          restart_game(piece_map[opponent])

          return
        end
        render_body(turn)

      end
  end


function play_game()
  render_page("Welcome to Andantino")
  ui_logs("GAME STARTED")

  while true  
      yield() 
  end

end


play_game()