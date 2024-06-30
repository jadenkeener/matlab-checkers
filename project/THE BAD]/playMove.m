%% playMove(move, player)
% move is a vector with minimum length two from moveList{}
function playMove(move, player)
global logicBoard
global logicDebug
logicDebug(:,:,end+1) = logicBoard;

% Play the move by dragging the piece across the board. This also
% eliminates any pieces captured. 
for i = 1:length(move)-1
    if sum(mod(fix(move/8) + mod(move+1,8),2)) == 0
        disp('SOMETHING FUCKED!!!')
        disp('')
    end
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


drawBoard;
generateMovesPlayer(~player);

end