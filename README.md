
# Andantino with Alpha-Beta Search

Andantino game and rules: http://www.di.fc.ul.pt/~jpn/gv/andantino.htm

# Installation and Running the Game.
## Windows 64 bit

 1. Install the Julia self-extracting executable from this link: https://julialang-s3.julialang.org/bin/winnt/x64/1.2/julia-1.2.0-win64.exe
 2. Run the .exe as administrator and install it in an easily accessbile location.
 3. Open the folder selected for installation and run the julia.exe file
 4. Once the Julia REPL opens, enter the following commands
 `
 julia> cd("<Location_of_the_andantino_zip_folder>")`
 ` julia>include("install_deps.jl")`
` julia>include("andantino_game.jl")`

## Linux

 1. Download the Linux binaries: https://julialang-s3.julialang.org/bin/linux/x64/1.2/julia-1.2.0-linux-x86_64.tar.gz
 2. Extract the `.tar.gz` file downloaded and then add Julia's `bin` folder to your system `PATH` environment variable
 3. Run `julia` in a shell and follow the same instructions from 4. for windows.
 
