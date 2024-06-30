classdef checkers

properties
    logicBoard % game state
    imageBoard % game drawing
    moveList % possible moves
    offsets % useful offsets (static)
    res % width of each tile (static)
    player
end


methods (Static, Access = public)
    newGame();
    generateMovesPlayer();
    imageBoard = drawBoard();
    evalHop();
    playMove();
end







end