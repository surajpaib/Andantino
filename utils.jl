include("game_moves.jl")

function play_random_turn(player)
    moves_to_play = possible_moves(andantino_board)
    move = moves_to_play[rand(1:end)]
    andantino_board[move[1]][move[2]] = player
    return move
end


function play_turn(player, move)
    moves_to_play = possible_moves(andantino_board)
    if move in moves_to_play
        #println(move)
        andantino_board[move[1]][move[2]] = player
        return true
    else
        println("Invalid Move, Pick a different move: ", moves_to_play)
        return false
    end
end