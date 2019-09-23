
include("board_functions.jl")
include("utils.jl")
include("win_conditions.jl")

using Blink

w = Window()
andantino_board = create_board()
original_board = deepcopy(andantino_board)
move_count = 0

handle(w, "white") do arg
  
  global original_board = deepcopy(andantino_board)
  if play_turn(22, collect(eval(Meta.parse(arg))))
    move_count = move_count + 1

    if move_count > 5 && check_game_end(collect(eval(Meta.parse(arg))), andantino_board)

      body!(w, """<div id="welcome"> WHITE WINS!!!<br/><br/>Play Another Game? <br/><br/><button id="white" onclick='Blink.msg("start", "white")'>WHITE</button><br/><button id="black" onclick='Blink.msg("start", "black")'>BLACK</button><br/><button id="twoplayer" onclick='Blink.msg("start", "twoplayer")'>TWO PLAYER</button></div>""");
      global andantino_board = create_board()
      global move_count = 0

      return
    end
    println("\n************************************************************************\n")

    move = play_turn_search(11, 6)

    if move_count > 5 && check_game_end(move, andantino_board)

      body!(w, """<div id="welcome"> BLACK WINS!!!<br/><br/>Play Another Game? <br/><br/><button id="white" onclick='Blink.msg("start", "white")'>WHITE</button><br/><button id="black" onclick='Blink.msg("start", "black")'>BLACK</button><br/><button id="twoplayer" onclick='Blink.msg("start", "twoplayer")'>TWO PLAYER</button></div>""");
      global andantino_board = create_board()
      global move_count = 0

      return
    end


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
                  (function printBtn() {
                    var container = document.createElement("div");

                    var undo_button = document.createElement("button");
                    undo_button.innerHTML = "UNDO";
                
                    undo_button.setAttribute('id', 'undo');
                    undo_button.setAttribute('onclick', 'Blink.msg("undo","white")');

                    container.style.margin = '15px 0';
                    container.appendChild(undo_button);

                    for (var j=1; j<20; j++){
                    var rowdiv = document.createElement("div");
                        if (j<=10){
                          for (var i = 1; i <= 10 + j - 1; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');
                    
                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("white","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }else{
                        for (var i = 1; i <= 29 - j; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');

                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("white","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }
                  
                      rowdiv.setAttribute('style', 'text-align:center');
                      container.appendChild(rowdiv);
                      document.body.appendChild(container);
                    }
                  
                  })();

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
                  
               
            </script>""");

  end
  prettyprintboard(andantino_board)
end


handle(w, "black") do arg
  println("CURRENT PLAYER: BLACK\n")

  global original_board = deepcopy(andantino_board)

  played_move = collect(eval(Meta.parse(arg)))
  if play_turn(11, played_move)
    move_count = move_count + 1

    println("Move Count: ", move_count)
    if move_count > 5 && check_game_end(played_move, andantino_board)

      body!(w, """<div id="welcome"> BLACK WINS!!!<br/><br/>Play Another Game? <br/><br/><button id="white" onclick='Blink.msg("start", "white")'>WHITE</button><br/><button id="black" onclick='Blink.msg("start", "black")'>BLACK</button><br/><button id="twoplayer" onclick='Blink.msg("start", "twoplayer")'>TWO PLAYER</button></div>""");
      global andantino_board = create_board()
      global move_count = 0

      return
    end

    println("\n************************************************************************\n")
    move = play_turn_search(22, 3)

    if move_count > 5 && check_game_end(move, andantino_board)
      body!(w, """<div id="welcome"> WHITE WINS!!!<br/><br/>Play Another Game? <br/><br/><button id="white" onclick='Blink.msg("start", "white")'>WHITE</button><br/><button id="black" onclick='Blink.msg("start", "black")'>BLACK</button><br/><button id="twoplayer" onclick='Blink.msg("start", "twoplayer")'>TWO PLAYER</button></div>""");
      global andantino_board = create_board()
      global move_count = 0

      return
    end

  
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
    println("White Positions:", white_positions)
    println("Black Positions:", black_positions)
    body!(w, """<script>
    var white_positions = eval('$white_positions'.replace('Any', ''));
    var black_positions = eval('$black_positions'.replace('Any', ''));
                  (function printBtn() {
                    var container = document.createElement("div");
                    container.style.margin = '15px 0';


                    var undo_button = document.createElement("button");
                    undo_button.innerHTML = "UNDO";
                
                    undo_button.setAttribute('id', 'undo');
                    undo_button.setAttribute('onclick', 'Blink.msg("undo","black")');
                    container.appendChild(undo_button);

                    for (var j=1; j<20; j++){
                    var rowdiv = document.createElement("div");
                        if (j<=10){
                          for (var i = 1; i <= 10 + j - 1; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');
                            
                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("black","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }else{
                        for (var i = 1; i <= 29 - j; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');

                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("black","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }
                  
                      rowdiv.setAttribute('style', 'text-align:center');
                      container.appendChild(rowdiv);
                      document.body.appendChild(container);
                    }
                  
                  })();

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
                  
               
            </script>""");

  end


end


handle(w, "undo") do arg
  global andantino_board = deepcopy(original_board)
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
                (function printBtn() {
                  var container = document.createElement("div");

                  container.style.margin = '15px 0';
                  var undo_button = document.createElement("button");
                  undo_button.innerHTML = "UNDO";
              
                  undo_button.setAttribute('id', 'undo');
                  undo_button.setAttribute('onclick', 'Blink.msg("undo","$arg")');
                  container.appendChild(undo_button);
                  
                  for (var j=1; j<20; j++){
                  var rowdiv = document.createElement("div");
                      if (j<=10){
                        for (var i = 1; i <= 10 + j - 1; i++) {
                      var btn = document.createElement("button");
                      btn.innerHTML = "&#x2B21;";
                      btn.setAttribute('class', 'hex-buttons');
                  
                      btn.setAttribute('id', String(j) + ',' + String(i));
                      btn.setAttribute('onclick', 'Blink.msg("$arg","'+ String(j) + ',' + String(i) + '")');
                      rowdiv.appendChild(btn);
                    }
                    }else{
                      for (var i = 1; i <= 29 - j; i++) {
                      var btn = document.createElement("button");
                      btn.innerHTML = "&#x2B21;";
                      btn.setAttribute('class', 'hex-buttons');

                      btn.setAttribute('id', String(j) + ',' + String(i));
                      btn.setAttribute('onclick', 'Blink.msg("$arg","'+ String(j) + ',' + String(i) + '")');
                      rowdiv.appendChild(btn);
                    }
                    }
                
                    rowdiv.setAttribute('style', 'text-align:center');
                    container.appendChild(rowdiv);
                    document.body.appendChild(container);
                  }
                
                })();

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
                
             
          </script>""");

prettyprintboard(andantino_board)
end


handle(w, "blacktwoplayer") do arg

  println("CURRENT PLAYER: BLACK\n")
  global original_board = deepcopy(andantino_board)

  if play_turn(11, collect(eval(Meta.parse(arg))))
    move_count = move_count + 1

    if move_count > 5 && check_game_end(collect(eval(Meta.parse(arg))), andantino_board)

      body!(w, """<div id="welcome"> BLACK WINS!!!<br/><br/>Play Another Game? <br/><br/><button id="white" onclick='Blink.msg("start", "white")'>WHITE</button><br/><button id="black" onclick='Blink.msg("start", "black")'>BLACK</button><br/><button id="twoplayer" onclick='Blink.msg("start", "twoplayer")'>TWO PLAYER</button></div>""");
      global andantino_board = create_board()
      global move_count = 0

      return
    end
    println("\n************************************************************************\n")

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
    println("White Positions:", white_positions)
    println("Black Positions:", black_positions)
    body!(w, """<script>
    var white_positions = eval('$white_positions'.replace('Any', ''));
    var black_positions = eval('$black_positions'.replace('Any', ''));
                  (function printBtn() {
                    var container = document.createElement("div");


                    var undo_button = document.createElement("button");
                    undo_button.innerHTML = "UNDO";
                
                    undo_button.setAttribute('id', 'undo');
                    undo_button.setAttribute('onclick', 'Blink.msg("undo","'+ String(j) + ',' + String(i) + '")');
                    container.appendChild(undo_button);


                    container.style.margin = '15px 0';
                    for (var j=1; j<20; j++){
                    var rowdiv = document.createElement("div");
                        if (j<=10){
                          for (var i = 1; i <= 10 + j - 1; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');
                    
                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("whitetwoplayer","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }else{
                        for (var i = 1; i <= 29 - j; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');

                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("whitetwoplayer","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }
                  
                      rowdiv.setAttribute('style', 'text-align:center');
                      container.appendChild(rowdiv);
                      document.body.appendChild(container);
                    }
                  
                  })();

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
                  
               
            </script>""");

  end
  prettyprintboard(andantino_board)
end

handle(w, "whitetwoplayer") do arg

  println("CURRENT PLAYER: WHITE\n")
  global original_board = deepcopy(andantino_board)

  if play_turn(22, collect(eval(Meta.parse(arg))))
    move_count = move_count + 1

    if move_count > 5 && check_game_end(collect(eval(Meta.parse(arg))), andantino_board)

      body!(w, """<div id="welcome"> WHITE WINS!!!<br/><br/>Play Another Game? <br/><br/><button id="white" onclick='Blink.msg("start", "white")'>WHITE</button><br/><button id="black" onclick='Blink.msg("start", "black")'>BLACK</button><br/><button id="twoplayer" onclick='Blink.msg("start", "twoplayer")'>TWO PLAYER</button></div>""");
      global andantino_board = create_board()
      global move_count = 0

      return
    end
    println("\n************************************************************************\n")

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
    println("White Positions:", white_positions)
    println("Black Positions:", black_positions)
    body!(w, """<script>
    var white_positions = eval('$white_positions'.replace('Any', ''));
    var black_positions = eval('$black_positions'.replace('Any', ''));
                  (function printBtn() {
                    var container = document.createElement("div");


                    var undo_button = document.createElement("button");
                    undo_button.innerHTML = "UNDO";
                
                    undo_button.setAttribute('id', 'undo');
                    undo_button.setAttribute('onclick', 'Blink.msg("undo","'+ String(j) + ',' + String(i) + '")');
                    container.appendChild(undo_button);


                    container.style.margin = '15px 0';
                    for (var j=1; j<20; j++){
                    var rowdiv = document.createElement("div");
                        if (j<=10){
                          for (var i = 1; i <= 10 + j - 1; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');
                    
                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("blacktwoplayer","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }else{
                        for (var i = 1; i <= 29 - j; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');

                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("blacktwoplayer","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }
                  
                      rowdiv.setAttribute('style', 'text-align:center');
                      container.appendChild(rowdiv);
                      document.body.appendChild(container);
                    }
                  
                  })();

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
                  
               
            </script>""");

  end
  prettyprintboard(andantino_board)
  #println(arg)
end


handle(w, "start") do arg
    println("Player Selected: ", arg)
    if arg == "white"
        body!(w, """<script>
                  (function printBtn() {
                    var container = document.createElement("div");
                    container.style.margin = '15px 0';

                    var undo_button = document.createElement("button");
                    undo_button.innerHTML = "UNDO";
                
                    undo_button.setAttribute('id', 'undo');
                    undo_button.setAttribute('onclick', 'Blink.msg("undo","undo")');

                    container.style.margin = '15px 0';
                    container.appendChild(undo_button);


                    for (var j=1; j<20; j++){
                    var rowdiv = document.createElement("div");
                        if (j<=10){
                          for (var i = 1; i <= 10 + j - 1; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');
                    
                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("white","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }else{
                        for (var i = 1; i <= 29 - j; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');

                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("white","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }
                  
                      rowdiv.setAttribute('style', 'text-align:center');
                      container.appendChild(rowdiv);
                      document.body.appendChild(container);
                    }
                    
                  })();
                  var added_piece = document.getElementById("10,10");
                  added_piece.innerHTML = "&#x2B22;";
                  added_piece.removeAttribute('onclick');
            </script>""");
      play_turn(11, [10, 10])
      prettyprintboard(andantino_board) 

    elseif arg == "black"
      body!(w, """<script>
                  (function printBtn() {
                    var container = document.createElement("div");
                    container.style.margin = '15px 0';

                    var undo_button = document.createElement("button");
                    undo_button.innerHTML = "UNDO";
                
                    undo_button.setAttribute('id', 'undo');
                    undo_button.setAttribute('onclick', 'Blink.msg("undo","undo")');

                    container.appendChild(undo_button);

                    for (var j=1; j<20; j++){
                    var rowdiv = document.createElement("div");
                        if (j<=10){
                          for (var i = 1; i <= 10 + j - 1; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');
                    
                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("black","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }else{
                        for (var i = 1; i <= 29 - j; i++) {
                        var btn = document.createElement("button");
                        btn.innerHTML = "&#x2B21;";
                        btn.setAttribute('class', 'hex-buttons');

                        btn.setAttribute('id', String(j) + ',' + String(i));
                        btn.setAttribute('onclick', 'Blink.msg("black","'+ String(j) + ',' + String(i) + '")');
                        rowdiv.appendChild(btn);
                      }
                      }
                  
                      rowdiv.setAttribute('style', 'text-align:center');
                      container.appendChild(rowdiv);
                      document.body.appendChild(container);
                    }
                  
                  })();

               
            </script>""");

    elseif arg == "twoplayer"
            body!(w, """<script>
            (function printBtn() {
              var container = document.createElement("div");
              container.style.margin = '15px 0';
              for (var j=1; j<20; j++){
              var rowdiv = document.createElement("div");
                  if (j<=10){
                    for (var i = 1; i <= 10 + j - 1; i++) {
                  var btn = document.createElement("button");
                  btn.innerHTML = "&#x2B21;";
                  btn.setAttribute('class', 'hex-buttons');
              
                  btn.setAttribute('id', String(j) + ',' + String(i));
                  btn.setAttribute('onclick', 'Blink.msg("whitetwoplayer","'+ String(j) + ',' + String(i) + '")');
                  rowdiv.appendChild(btn);
                }
                }else{
                  for (var i = 1; i <= 29 - j; i++) {
                  var btn = document.createElement("button");
                  btn.innerHTML = "&#x2B21;";
                  btn.setAttribute('class', 'hex-buttons');

                  btn.setAttribute('id', String(j) + ',' + String(i));
                  btn.setAttribute('onclick', 'Blink.msg("whitetwoplayer","'+ String(j) + ',' + String(i) + '")');
                  rowdiv.appendChild(btn);
                }
                }
            
                rowdiv.setAttribute('style', 'text-align:center');
                container.appendChild(rowdiv);
                document.body.appendChild(container);
              }
              
            })();
            var added_piece = document.getElementById("10,10");
            added_piece.innerHTML = "&#x2B22;";
            added_piece.removeAttribute('onclick');
      </script>""");
      play_turn(11, [10, 10])
      prettyprintboard(andantino_board) 
        
  
    end
end

load!(w, "static/app.css")
body!(w, """<div id="welcome"> Welcome to Andantino!!!<br/><br/>Select your color: <br/><br/><button id="white" onclick='Blink.msg("start", "white")'>WHITE</button><br/><button id="black" onclick='Blink.msg("start", "black")'>BLACK</button><br/><button id="twoplayer" onclick='Blink.msg("start", "twoplayer")'>TWO PLAYER</button></div>""");

while true  
    yield() 
end