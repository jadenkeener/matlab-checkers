%% drawMoves
% this function is very similar to drawBoard, but with slight modifications
% to preview a draw a preview of a pieces possible moves on the board
function drawMoves(mousePos)
global imageBoard
global logicBoard
global moveList

% guideBoard will be used
previewLogicBoard = logicBoard;
previewImageBoard = imageBoard;

% convert mousePos into the row and column clicked by dividing by the
% size of each square and rounding down
mousePos = fix(mousePos);
mousePos = mousePos/(length(imageBoard)/8);
r = mousePos(1);
c = mousePos(2);

% Convert row and column to absolute index i
i = r + 8*(c-1);


% now before anything else, we need to see if the piece we are looking at
% can play. first check: if there is a capture move available, is the piece
% we selected able to capture?
forcedMoves = moveList{1};
forcedMoveList = moveList{forcedMoves}



% Generate the moves for the piece in question
generateMovesPiece(i);

% Now, update our preview logic board with the possible moves

end
