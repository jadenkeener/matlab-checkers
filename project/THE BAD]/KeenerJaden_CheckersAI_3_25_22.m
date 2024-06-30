%% KeenerJaden_CheckersAI.m
% This machine plays checkers!
%
% TO DO:
% * Fix bug where some capture moves are not being detected
% * Fix bug where pieces can dimension warp when capturing from rank 2 or 7
% * Implement forced capture
% * Implement AI

%% Cleanup
clear;clc;clf;


%% Initialization
% The arrays in this section only hold game information. They are not used
% to draw the game! The AI makes all choices based on the logic arrays.

% intialize board
% place pieces on board. player one (black) pieces are represented by 1 for
% pawns and 11 for kings. player two (red) pieces are 2 and 22.
%
global logicBoard
logicBoard = zeros(8,8);

for r = 1:3
    for c = 1:8
        if mod(r+c, 2) == 0
            %Creating player 1 (bottom of board). Player 1 has pawns on
            %bottom three rows where r+c is even.
            logicBoard(r+5,c) = 1; 
        else
            %Creating player 2 (top of board). Player 2 has pawns on
            %top three rows where r+c is odd.
            logicBoard(r,c) = 2;
        end
    end
end

% Struct containing offset values for ease of use. Contains index offsets
% to upper left/right and bottom left/right


global offsets
offsets = struct;
offsets.ul = -9;
offsets.ur = 7;
offsets.bl = -7;
offsets.br = 9;

global moveList
moveList = {};






%% Main
generateMovesPlayer(true);
drawBoard();


player = false;
while true
player = ~player;

if ~isempty(moveList{1})
    forcedMoves = moveList{1};
    playMove(moveList{forcedMoves(randi(length(forcedMoves)))}, player)
else
playMove(moveList{randi([2,length(moveList)])}, player);
end
% pause(0.5)
end





%% drawBoard()
% draw board based on current game state
function drawBoard()
global logicBoard
res = 100;
res = res*8;

% Initialize a few useful arrays
imageBoard = zeros(res);
boardDark = 3*ones(res/8);
boardLight = 4*ones(res/8);




% Create checker background pattern
for r = 1:8
    for c = 1:8
        % The following operations grab an eighth of the board at a time,
        % then set it to its correct color
        if mod(r,2) == 0
            if mod(c,2) == 0
                imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = boardDark;
            else
                imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = boardLight;
            end
        else
            if mod(c,2) == 0
                imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = boardLight;
            else
                imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = boardDark;
            end
        end
    end
end

% This is super jank, but for the colormap to work correctly we need
% atleast one king color pixel on the board at all times. This ensures that
imageBoard(1) = 5;




% Creating a 'circular' array mask to put chips on the board
x = 1:res/8;
y = 1:res/8;
cx = res/8/2; % circle center
cy = res/8/2; % circle center
r = res/8/2; % radius 
mask =((x-cx).^2 + (y'-cy).^2) < r^2  ; % Creating a mask


% Now create a king mask with smaller radius
kingMask =((x-cx).^2 + (y'-cy).^2) < (r/2)^2  ; % Creating a mask



% Now draw the chips on the board
for r = 1:8
    for c = 1:8
    switch logicBoard(r,c)
        case {1, 2} % For pawns
            % We take the 'tile', spraypaint the checker over it, then load
            % it back into the imageBoard
            tile = imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8);
            tile(mask) = logicBoard(r,c);
            imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = tile;
        case {11, 22} % For Kings
            tile = imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8);
            tile(mask) = logicBoard(r,c)/11;
            tile(kingMask) = 5;
            imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = tile;  
    end
    end
end

% Build custom colormap
% color order is: player1, player2, boardDark, boardLight, king color
colors = [0, 0, 0; 255, 0, 0; 112, 72, 19;240, 221, 161; 255, 196, 0];
colors = colors./255;

% Draw our board image
colormap(colors)
imagesc(imageBoard)
set(gca, 'YTickLabel', [], 'XTickLabel', [], 'xtick', [], 'ytick', [])
axis square


end





%% generateMovesPlayer(player)
% Generates cell array of all possible moves. Each index in moveList
% represents a possible moves. the moves are coded in vectors. the first
% index in the vector specifies the piece, and then each succesive index
% specifies its path. In cases of multiple captures, there will be several
% 'steps' on the path
%
function generateMovesPlayer(player)
global logicBoard
global moveList
global offsets

% First, empty our moveList
moveList =  {[]};

for i = 1:64
ur = i+offsets.ur;
ul = i+offsets.ul;
br = i+offsets.br;
bl = i+offsets.bl;

switch logicBoard(i)
    case {1, 11} % Player 1 rules
        if player
            if mod(i-1, 8) ~= 0
            try
            switch logicBoard(ul) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, ul];
                case {2, 22}
                    try
                    if logicBoard(ul+offsets.ul) == 0
                        evalHop(ul+offsets.ul, [i,ul,ul+offsets.ul], true)
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch logicBoard(ur) % Check the right side jump
                case 0 % If open square
                    moveList{end+1} = [i, ur];
                case {2, 22} % If enemy piece, see if cappable
                    try
                    if logicBoard(ur+offsets.ur) == 0
                        evalHop(ur+offsets.ur, [i,ur,ur+offsets.ur], true)
                    end
                    catch
                    end
            end
            catch
            end
            end
            
            % Now check the other direction for kings
            if mod(i,8) ~= 0 && logicBoard(i) == 11
            try
            switch logicBoard(bl) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, bl];
                case {2, 22}
                    try
                    if logicBoard(bl+offsets.bl) == 0
                        evalHop(bl+offsets.bl, [i,b1,bl+offsets.bl], true)
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch logicBoard(br) % Check the right side jump
                case 0 % If open square
                    moveList{end+1} = [i, br];
                case {2,22} % If enemy piece, see if cappable
                    try
                    if logicBoard(br+offsets.br) == 0
                        evalHop(br+offsets.br, [i,br,br+offsets.br], true)
                    end
                    catch
                    end
            end
            catch
            end
            end
        end

        
         
    case {2, 22} % Player 1 rules
        if ~player
            if mod(i,8) ~= 0
            try
            switch logicBoard(bl) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, bl];
                case {1, 11}
                    try
                    if logicBoard(bl+offsets.bl) == 0
                        evalHop(bl+offsets.bl, [i,b1,bl+offsets.bl], true)
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch logicBoard(br) % Check the right side jump
                case 0 % If open square
                    moveList{end+1} = [i, br];
                case {1,11} % If enemy piece, see if cappable
                    try
                    if logicBoard(br+offsets.br) == 0
                        evalHop(br+offsets.br, [i,br,br+offsets.br], true)
                    end
                    catch
                    end
            end
            catch
            end
            end
            
            % Now check other direction for kings
            if mod(i-1, 8) ~= 0 && logicBoard(i) == 22
            try
            switch logicBoard(ul) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, ul];
                case {1, 11}
                    try
                    if logicBoard(ul+offsets.ul) == 0
                        evalHop(ul+offsets.ul, [i,ul,ul+offsets.ul], true)
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch logicBoard(ur) % Check the right side jump
                case 0 % If open square
                    moveList{end+1} = [i, ur];
                case {1, 11} % If enemy piece, see if cappable
                    try
                    if logicBoard(ur+offsets.ur) == 0
                        evalHop(ur+offsets.ur, [i,ur,ur+offsets.ur], true)
                    end
                    catch
                    end
            end
            catch
            end
            end
        end
end
end
end










%% evalHop
% Special function for evaluating captures. Used to detect and
% write capture chain moves to moveList.
%
% i = index of piece AFTER performing a hop
% move = array of piece location history
% player = true if p1, false if p2.
%
% This function is designed to be called recursively
%
function evalHop(i, move, player)
global logicBoard
global moveList
global offsets

% Define locations around us
ur = i+offsets.ur;
ul = i+offsets.ul;
br = i+offsets.br;
bl = i+offsets.bl;

fail = 0; % Fail keeps track of whether or not our chip has run out of
          % captures. Failing twice writes the move string to
          % moveList{}. 

          
          
% The try-catch statements here let us escape the horror of trying to make
% sure that the index of our logicBoard is always a positive number. Now if
% i is negative, we simply error out and catch it by adding one to our fail
% counter
switch player
    case true % For player 1
        if ((logicBoard(ul) == 2) || (logicBoard(ul) == 22)) && mod(i-1, 8) ~= 0
            try
            if logicBoard(ul+offsets.ul) == 0
                move = [move, ul, ul+offsets.ul];
                evalHop(ul+offsets.ul, move, true)
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        if ((logicBoard(ur) == 2) || (logicBoard(ur) == 22)) && mod(i-1, 8) ~= 0
            try
            if logicBoard(ur+offsets.ur) == 0
                move = [move, ur, ur+offsets.ur];
                evalHop(ur+offsets.ur, move, true)
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        if fail == 2
            moveList{end+1} = move;
            moveList{1} = [moveList{1}, length(moveList)];
        end
        
        
    case false % Player 2 rules 
        if ((logicBoard(bl) == 1) || (logicBoard(bl) == 11)) && mod(i, 8) ~= 0
            try
            if logicBoard(bl+offsets.bl) == 0
                move = [move, bl, bl+offsets.bl];
                evalHop(bl+offsets.bl, move, true)
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        end
        if ((logicBoard(br) == 1) || (logicBoard(br) == 11)) && mod(i, 8) ~= 0
            try
            if logicBoard(br+offsets.br) == 0
                move = [move, br, br+offsets.br];
                evalHop(br+offsets.br, move, true)
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        end
        if fail == 2
            moveList{end+1} = move;
            moveList{1} = [moveList{1}, length(moveList)];
        end
        
end
end


%% playMove(move, player)
% move is a vector with minimum length two from moveList{}
function playMove(move, player)
global logicBoard

% Play the move by dragging the piece across the board. This also
% eliminates any pieces captured. 
for i = 1:length(move)-1
    logicBoard(move(i+1)) = logicBoard(move(i));
    logicBoard(move(i)) = 0;
end

% After each move, check for kings
for c = 1:8
    if logicBoard(1,c) == 1
        logicBoard(1,c) = 11;
    end
    if logicBoard(8, c) == 2
        logicBoard(8,c) = 22;
    end
end


drawBoard();
generateMovesPlayer(~player);

end










