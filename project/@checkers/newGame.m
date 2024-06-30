function newGame()
clear;clf;

% Initialize board
checkers.logicBoard = zeros(8,8); 

% Initialize checkers.offsets used in generateMovesPlayer() and playMove()
checkers.offsets = struct;
checkers.offsets.ul = -9;
checkers.offsets.ur = 7;
checkers.offsets.bl = -7;
checkers.offsets.br = 9;

checkers.player = true;

% Build the board
for r = 1:3
    for c = 1:8
        if mod(r+c, 2) == 0
            %Creating player 1 (bottom of board). Player 1 has pawns on
            %bottom three rows where r+c is even.
            checkers.logicBoard(r+5,c) = 1; 
        else
            %Creating player 2 (top of board). Player 2 has pawns on
            %top three rows where r+c is odd.
            checkers.logicBoard(r,c) = 2;
        end
    end
end
end