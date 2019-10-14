
#=

UI Render Javascript Code

=#


using Blink
w = Window()
load!(w, "static/app.css")
search_ply = 4

function render_page(message)
    body!(w, """<div id="welcome"><h1>$message</h1><br/><br/><br/>
    Select the Game Mode:
    <br/>
    <select id="game_mode">
    <option value="ai">AI vs AI</option>
      <option value="twoplayer">Two Player</option>
      <option value="white">White</option>
      <option value="black">Black</option>
    </select>
    <br><br>

    Pick the search ply:
    <br/>

    <div class="slidecontainer">
    <input type="range" min="1" max="10" value="3" class="slider" id="search_ply">
    <p><h4>Search Ply: <span id="demo"></span></h4></p>

    </div>

    <br/><br/>
    <label class="container">Alpha Beta Search
    <input type="checkbox" id="alphabeta">
    <span class="checkmark"></span>
    </label><br/>
    <label class="container">Transposition Tables
    <input type="checkbox" id="iterativedeep">
    <span class="checkmark"></span>
    </label><br/>
    <label class="container">PVS
    <input type="checkbox" id="pvs">
    <span class="checkmark"></span>
    </label>

    <button onclick="onSubmit()" id="white">SUBMIT</button>
    </div>
  <script>
    
    var search_ply = document.getElementById("search_ply");

    var output = document.getElementById("demo");
    output.innerHTML = search_ply.value;

    search_ply.oninput = function() {
    output.innerHTML = this.value;
    }

  function onSubmit(){
    var white = document.getElementById("white");
    white.removeAttribute('onclick');
    var game_mode = document.getElementById("game_mode").value;
    var search_ply = document.getElementById("search_ply");
    var iterativedeepval = document.getElementById("iterativedeep").checked;
    var pvsval = document.getElementById("pvs").checked;
    var alphabeta = document.getElementById("alphabeta").checked;

    Blink.msg("start", [game_mode, search_ply.value, iterativedeepval, pvsval, alphabeta]);
  }


  </script>
""");
end

function render_win_page(winner)
    render_page("$winner WINS!!!")
end

function render_body(turn)
    playable_moves = possible_moves(andantino_board)
    occupied_hexagons = evaluate_board(andantino_board)
    white_positions = []
    black_positions = []
    for hex in occupied_hexagons
      if andantino_board[hex[1]][hex[2]] == 11
        push!(black_positions, hex)
      
      elseif andantino_board[hex[1]][hex[2]] == 22
        push!(white_positions, hex)
      end
    end
  
    body!(w, """<script>
    var white_positions = eval('$white_positions'.replace('Any', ''));
    var black_positions = eval('$black_positions'.replace('Any', ''));
    var playable_moves = eval('$playable_moves'.replace('Array{Int64,1}', ''));

    (function printBtn() {
      var container = document.createElement("div");
      container.style.margin = '15px 0';
  
      var undo_button = document.createElement("button");
      undo_button.innerHTML = "UNDO";

 
  
      undo_button.setAttribute('id', 'undo');
      undo_button.setAttribute('onclick', 'Blink.msg("undo", "$turn")');
  
      container.style.margin = '15px 0';
      container.appendChild(undo_button);

  
      var rowmappings = document.createElement("div");
      for (var i=0; i <10; i++){

        var mappings = document.createElement("span");
        mappings.setAttribute('class', 'toprow');
        mappings.innerHTML = String.fromCharCode(65+i);
        rowmappings.appendChild(mappings);
      }
      rowmappings.setAttribute('style', 'text-align:center');

      container.appendChild(rowmappings);
      for (var j=1; j<20; j++){
      var rowdiv = document.createElement("div");
      var mappings = document.createElement("span");
          if (j<=10){

            mappings.innerHTML = j + "  ";
            mappings.setAttribute('class', 'inlinerow');

            rowdiv.appendChild(mappings);

          for (var i = 1; i <= 10 + j - 1; i++) {
          var btn = document.createElement("button");
          btn.innerHTML = "&#x2B21;";
          btn.setAttribute('class', 'hex-buttons');
      
          btn.setAttribute('id', String(j) + ',' + String(i));
          btn.setAttribute('onclick', 'Blink.msg("$turn","'+ String(j) + ',' + String(i) + '")');
          rowdiv.appendChild(btn);
        }
        var mappings = document.createElement("span");
        mappings.setAttribute('class', 'inlinerow');

        mappings.innerHTML = " " + String.fromCharCode(75+j);
        rowdiv.appendChild(mappings);
        }else{

          mappings.innerHTML = j;
          mappings.setAttribute('class', 'inlinerow');
          rowdiv.appendChild(mappings);


          for (var i = 1; i <= 29 - j; i++) {
          var btn = document.createElement("button");
          btn.innerHTML = "&#x2B21;";
          btn.setAttribute('class', 'hex-buttons');
  
          btn.setAttribute('id', String(j) + ',' + String(i));
          btn.setAttribute('onclick', 'Blink.msg("$turn","'+ String(j) + ',' + String(i) + '")');
          rowdiv.appendChild(btn);
        }
        var mappings = document.createElement("span");
        mappings.innerHTML = ' ';
        rowdiv.appendChild(mappings);
        }
    
        rowdiv.setAttribute('style', 'text-align:center');
        container.appendChild(rowdiv);
      }
      document.body.appendChild(container);

        white_positions.forEach(function(element) {
        var added_piece = document.getElementById(String(element[0])+","+String(element[1]));
        added_piece.innerHTML = "&#x2B22;";
        added_piece.style.color = '#ffffff';
        added_piece.removeAttribute('onclick');
        });
  
  
        black_positions.forEach(function(element) {
        var added_piece = document.getElementById(String(element[0])+","+String(element[1]));
        added_piece.innerHTML = "&#x2B22;";
        added_piece.style.color = '#000000';
        added_piece.removeAttribute('onclick');
        });


        playable_move_count = 1;
        playable_moves.forEach(function(element) {
          var added_piece = document.getElementById(String(element[0])+","+String(element[1]));
          added_piece.innerHTML = "&#x2B21;";
     
          added_piece.style.setProperty('animation-name', 'increasesize');
          added_piece.style.setProperty('animation-duration', playable_move_count * 0.5 + 's');
          added_piece.style.setProperty('animation-direction', 'alternate');
          added_piece.style.setProperty('animation-iteration-count', 'infinite');

          added_piece.setAttribute('class', 'hex-buttons playablebuttons');
          
          added_piece.setAttribute('class', 'hex-buttons playablebuttons');
        
          added_piece.style.color = '#00B3CE';
          if (playable_move_count == 5){
            playable_move_count = 0;
          }
          playable_move_count++;
          });
      
    })();
  
  
  
  
  </script>""");
  end


  #=

  CLICK HANDLERS

  =#


handle(w, "start") do arg
    println(arg)
    global iterativedeepening = arg[3]
    global pvs = arg[4]
    global alphabeta= arg[5]
    global search_ply = parse(Int, arg[2])
    if arg[1] == "white"
      play_turn(11, [10, 10])
      render_body("white")
       
    elseif arg[1] == "ai"
      play_turn(11, [10, 10])
      play_turn(22)
      play_turn(11)
      global move_count = 3
      render_body("white")
      runAIvsAI()

    elseif arg[1] == "black"
      render_body("black")

    elseif arg[1] == "twoplayer"
      play_turn(11, [10, 10])
      render_body("whitetwoplayer") 
        
    end
end



handle(w, "white") do arg
    println("Search Ply: ", search_ply)
    play_handler("white", search_ply, arg)
  end
  
  
  handle(w, "black") do arg
    play_handler("black", search_ply, arg)
  end
  
  
  handle(w, "undo") do arg
    global andantino_board = deepcopy(original_board)
    render_body(arg)
  end
  
  
  handle(w, "blacktwoplayer") do arg
    global original_board = deepcopy(andantino_board)
    if play_turn(11, collect(eval(Meta.parse(arg))))
      move_count = move_count + 1
      if move_count > 5 && check_game_end(collect(eval(Meta.parse(arg))), andantino_board)
        render_win_page("BLACK")
        global andantino_board = create_board()
        global move_count = 0
        return
      end
      render_body("whitetwoplayer")
    end
  end
  
  
  
  handle(w, "whitetwoplayer") do arg
  
    global original_board = deepcopy(andantino_board)
    if play_turn(22, collect(eval(Meta.parse(arg))))
      move_count = move_count + 1
  
      if move_count > 5 && check_game_end(collect(eval(Meta.parse(arg))), andantino_board)
        render_win_page("WHITE")
        global andantino_board = create_board()
        global move_count = 0
  
        return
      end
      render_body("blacktwoplayer")
    end
  end


function ui_logs(message)
  js(w, Blink.JSString("""console.log("$message")"""))
end