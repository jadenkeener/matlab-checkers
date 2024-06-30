%% playMove(move)
% Plays a move by updating the logicBoard. Also upgrades pieces to kings.
% 
% move is a vector with minimum length two from moveList{}
% 
function playMove(move)
global logicBoard

% Play the move by dragging the piece across the board. This also
% eliminates any pieces captured. 
logicBoard(move(end)) = logicBoard(move(1));
logicBoard(move(1:end-1)) = 0;

% After each move, check for kings
for c = 1:8
    if logicBoard(1,c) == 1
        logicBoard(1,c) = 11;
    end
    if logicBoard(8, c) == 2
        logicBoard(8,c) = 22;
    end
end
end