
include("board_functions.jl")
include("utils.jl")
include("win_conditions.jl")
include("ui_render.jl")
include("transposition_tables.jl")


ZobristTable = initTable()
debug = false
andantino_board = create_board()
original_board = deepcopy(andantino_board)
move_count = 0
pvs = false
iterativedeepening = false

function runAIvsAI()
  while true
  
    global original_board = deepcopy(andantino_board)
    if iterativedeepening
      hash = computeHash(ZobristTable, andantino_board)
      move = play_turn(22, search_ply, 3, hash)

    elseif pvs
      move = play_turn(22, search_ply, 3)

    else
      move = play_turn(22, search_ply)
    end
    
    move_count = move_count + 1

    if move_count > 4 && check_game_end(move, andantino_board)
      render_win_page("WHITE")
      global andantino_board = create_board()
      global move_count = 0
      return
    end

    if iterativedeepening
      hash = computeHash(ZobristTable, andantino_board)
      move = play_turn(11, search_ply, 3, hash)

    elseif pvs
      move = play_turn(11, search_ply, 3)

    else
      move = play_turn(11, search_ply)
    end 

    if move_count > 3 && check_game_end(move, andantino_board)
      render_win_page("BLACK")
      global andantino_board = create_board()
      global move_count = 0

      return
    end

    render_body("none")

    if debug
      prettyprintboard(andantino_board)
    end

  end


end


function play_handler(turn::String, search_ply::Int64, arg)
    global original_board = deepcopy(andantino_board)
    piece_map = Dict()

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

    if play_turn(player, collect(eval(Meta.parse(arg))))
      move_count = move_count + 1


      if move_count > 4 && check_game_end(collect(eval(Meta.parse(arg))), andantino_board)
        render_win_page(piece_map[player])
        global andantino_board = create_board()
        global move_count = 0

        return
      end

      if iterativedeepening
        move = play_turn(opponent, search_ply, 3)
  
      else
        move = play_turn(opponent, search_ply)
      end
      
      if move_count > 3 && check_game_end(move, andantino_board)

        render_win_page(piece_map[opponent])
        global andantino_board = create_board()
        global move_count = 0

        return
      end
      render_body(turn)

    end
end

render_page("Welcome to Andantino")
ui_logs("GAME STARTED")

while true  
    yield() 
end