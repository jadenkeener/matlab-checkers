%% KeenerJaden_CheckersAI.m
% This machine plays checkers!
%
% TO DO:
% * Implement AI

%% Cleanup
clear;clc;


%% Initialization
% The arrays in this section only hold game information. They are not used
% to draw the game! The AI makes all choices based on the logic arrays.

% intialize board
% place pieces on board. player one (black) pieces are represented by 1 for
% pawns and 11 for kings. player two (red) pieces are 2 and 22.
%
global logicBoard
logicBoard = zeros(8,8);



% Struct containing offset values for ease of use. Contains index offsets
% to upper left/right and bottom left/right

newGame();







%% Main
global logicDebug
global moveList

drawBoard();
generateMovesPlayer(true);
turnCounter = 0;
player = true;

logicDebug = [];

% % Play random legal moves!
% try
% while true
%     turnCounter = turnCounter + 1;
%     playMove(moveList{randi([1,length(moveList)])}, player);
%     player = ~player;
% end
% catch
%     disp("Game over in "+turnCounter+" turns!")
%     drawBoard;
% end

% Player 1 gets minimax, player 2 is random
% try
% while true
%     if player
%         [eval, bestMove] = minimax(3, true);
%         playMove(bestMove, true);
%     else
%         playMove(moveList{randi([1,length(moveList)])}, player);
%     end
%     turnCounter = turnCounter + 1;
%     player = ~player;
%     drawBoard;
% end
% catch
%     disp("Game over in "+turnCounter+" turns!")
%     drawBoard;
% end


%Both players get minimax
while true
    if player
        [eval, bestMove] = minimax(5, true);
        playMove(bestMove, true);
    else
        [eval, bestMove] = minimax(3, false);
        playMove(bestMove, false);
    end
    turnCounter = turnCounter + 1;
    player = ~player;
    drawBoard;
end

% PVE (jank)
% while true
%     [eval, bestMove] = minimax(5, false);
%     playMove(bestMove, false);
%     drawBoard
% end