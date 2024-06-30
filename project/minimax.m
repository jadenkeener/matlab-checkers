%% minimax(depth, maximizing)
% This function contains our implementation of the minimax function, and
% therefore is the logic for our AI opponent
% 
% depth is algorithm depth greater than or equal to 0
% maximizing is a boolean, true to evaluate from maximizing players
% perspective, false for minimizing.
%
function [eval, bestMove] = minimax(depth, maximizing)
global logicBoard
global moveList

bestMove = 0; % Placeholder value for bestMove

% If at bottom of depth, perform static evaluation of the board and return
% that value.
if depth == 0
    eval = 0;
    for i = 1:64
        switch logicBoard(i)
            case 1
                eval = eval+3;
            case 11
                eval = eval+5;
            case 2
                eval = eval-3;
            case 22
                eval = eval-5;
        end
    end
    return
end



% Lets get some moves in here. maximizing tells us player info
generateMovesPlayer(maximizing);

% Because I made the terrible mistake of using globals, store these for
% later
logicStore = logicBoard;
moves = moveList;




% If we are the maximizing player, then play all of our moves and perform
% minimax on each of those children with depth-1.
if maximizing
    maxEval = -inf;
    eval = maxEval;
    for i = 1:length(moves)
        % We need to reload our logicBoard every time because globals lol
        logicBoard = logicStore;
        playMove(moves{i})
        eval = minimax(depth-1, false);
        if eval > maxEval
            maxEval = eval;
            bestMove = moves{i};
        end 
        % Lets choose randomly which move to use if they are equally good
        if (eval == maxEval) && (randi([0, 1], 1, 1) == 1)
            bestMove = moves{i};
        end
            
    end
    logicBoard = logicStore;
    moveList = moves;
    return
    
% Minimizing case
else
    minEval = inf;
    eval = minEval;
    for i = 1:length(moveList)
        logicBoard = logicStore;
        playMove(moves{i})
        eval = minimax(depth-1, true);
        if eval < minEval
            minEval = eval;
            bestMove = moves{i};
        end 
        % Lets choose randomly which move to use if they are equally good
        if (eval == minEval) && (randi([0, 1], 1, 1) == 1)
            bestMove = moves{i};
        end
    end
    logicBoard = logicStore;
    moveList = moves;
    return
end
end