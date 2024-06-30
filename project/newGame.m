%% newGame()
% No input or outputs
% Initializes the important variables used by other functions in the
% checkers game.
function newGame()
clear;clf;
global logicBoard
global offsets
global repeat

% Initialize board
logicBoard = zeros(8,8); 

% Initialize repeat
repeat(:,:,1) = logicBoard;
repeat(1,1,2) = 0;

% Initialize offsets used in generateMovesPlayer() and playMove()
offsets = struct;
offsets.ul = -9;
offsets.ur = 7;
offsets.bl = -7;
offsets.br = 9;

% Build the board
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
end