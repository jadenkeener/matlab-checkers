function playHuman(piece, place)
    global logicBoard
    logicBoard(place(1), place(2)) = logicBoard(piece(1), piece(2));
    logicBoard(piece(1), piece(2)) = 0;
end