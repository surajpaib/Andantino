
include("board_functions.jl")
include("utils.jl")
include("win_conditions.jl")

using DelimitedFiles
andantino_board = create_board()

board_arrays = []
game_results = []
for i in 1:100000
    move_count = 0
    board_array = []
    global andantino_board = create_board()

    while true
        move = play_turn(22)

        flat_board = Int64[]
        

        for row in andantino_board
            for col in row
                push!(flat_board, col)
            end
        end
        push!(board_array, flat_board)
        move_count = move_count + 1
       
        if move_count > 4 && check_game_end(move, andantino_board)
            println("Finished Game: ", i)
            prettyprintboard(andantino_board)
            println("\n Result: ", 1)
            for board in board_array
                push!(board_arrays, board)
                push!(game_results, 1)

            end
            break

        end

        move = play_turn(11)
        flat_board = Int64[]

        for row in andantino_board
            for col in row
                push!(flat_board, col)
            end
        end
        push!(board_array, flat_board)

        if move_count > 3 && check_game_end(move, andantino_board)
            println("Finished Game: ", i)
            prettyprintboard(andantino_board)
            println("\n Result: ", -1)


            for board in board_array
                push!(board_arrays, board)
                push!(game_results, -1)

            end

            break
        end
    end


    if i % 100 == 0
        writedlm( "training_input.csv",  board_arrays, ',')
        writedlm( "training_output.csv",  game_results, ',')
    end
end



writedlm( "training_input.csv",  board_arrays, ',')
writedlm( "training_output.csv",  game_results, ',')