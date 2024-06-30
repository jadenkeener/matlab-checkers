%% playMove(move, player)
% move is a vector with minimum length two from moveList{}
function playMove(move)
checkers.logicDebug(:,:,end+1) = checkers.logicBoard;

% Play the move by dragging the piece across the board. This also
% eliminates any pieces captured. 
for i = 1:length(move)-1
    if sum(mod(fix(move/8) + mod(move+1,8),2)) == 0
        disp('SOMETHING FUCKED!!!')
        disp('')
    end
    checkers.logicBoard(move(i+1)) = checkers.logicBoard(move(i));
    checkers.logicBoard(move(i)) = 0;
end

% After each move, check for kings
for c = 1:8
    if checkers.logicBoard(1,c) == 1
        checkers.logicBoard(1,c) = 11;
    end
    if checkers.logicBoard(8, c) == 2
        checkers.logicBoard(8,c) = 22;
    end
end

player = ~player;
drawBoard;
generateMovesPlayer();

end