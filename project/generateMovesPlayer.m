%% generateMovesPlayer(player)
% Generates cell array of all possible moves. Each index in moveList
% represents a possible moves. the moves are coded in vectors. the first
% index in the vector specifies the piece, and then each succesive index
% specifies its path. In cases of multiple captures, there will be several
% 'steps' on the path
%
function generateMovesPlayer(player)
global logicBoard
global moveList
global offsets

% First, create an empty moveList. The moveList is a cell array holding all
% possible moves. moveList{1} holds an array that specifies the indices of
% moveList{} where a capture is possible. In checkers you HAVE to play a
% capture move if one is available to you
%
% indices 2:end of moveList{} hold the moves as a vector. Moves are
% formatted as follows:
%
% moveList{move#} = [index of piece to move, index of space to move to]
%
% The vector will be more than 2 long if we move multiple spaces in a move,
% when capturing for example. When capturing, we move on top of the piece,
% then follow through to the open square past it. The move vector gets even
% longer for chain captures, formatted the same way.
moveList =  {[]};

for i = 1:64
    
% These are the indexes of the squares immediately diaganol to our piece.
ur = i+offsets.ur;
ul = i+offsets.ul;
br = i+offsets.br;
bl = i+offsets.bl;


% Note about the function below: To avoid having a bunch of edge case
% checks for when we are on the sides of the board, we use try-catch
% statements. If an index fails (because we are on a side), we just fall
% into the catch which just exits the current evaluation.
switch logicBoard(i)
    % If black piece, do player ones rules
    case {1, 11} 
        % Only evaluate this if we want moves for player 1
        if player
            if mod(i-1, 8) ~= 0 % If we arent on the top edge of the board
            
            % First, evaluate the upper left square to see if we can move 
            % to it or capture a piece on it
            try
            switch logicBoard(ul) % 
                
                % If the space is empty we can move to it, so write that as
                % a possible move to the moveList
                case 0 
                    moveList{end+1} = [i, ul];
                    
                % If the space has an enemy piece on it, we might be able
                % to capture
                case {2, 22}
                    try
                    % If the space past the enemy piece is open, we can
                    % capture!
                    if logicBoard(ul+offsets.ul) == 0 && mod(i-1,8) > 1
                        % Now we need to see if we can perform a chain
                        % capture. This evaluation is a little complex, so
                        % we call a different function. read evalHop() for
                        % explanation of parameters
                        evalHop(ul+offsets.ul, [i,ul,ul+offsets.ul], true)
                    end
                    catch
                    end
            end
            catch
            end
            
            
            % Now do the same thing for the upper right square. The process
            % is all the same so comments will be sparse.
            try
            switch logicBoard(ur) 
                case 0 % If open square
                    moveList{end+1} = [i, ur];
                case {2, 22} % If enemy piece, see if cappable
                    try
                    if logicBoard(ur+offsets.ur) == 0 && mod(i-1,8) > 1
                        evalHop(ur+offsets.ur, [i,ur,ur+offsets.ur], true)
                    end
                    catch
                    end
            end
            catch
            end
            end
            
            % IF OUR PIECE IS A KING: then we need to check the other two
            % directions
            if mod(i,8) ~= 0 && logicBoard(i) == 11
            try
            switch logicBoard(bl) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, bl];
                case {2, 22}
                    try
                    if logicBoard(bl+offsets.bl) == 0 && mod(i,8) < 7
                        evalHop(bl+offsets.bl, [i,bl,bl+offsets.bl], true)
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch logicBoard(br) % Check the right side jump
                case 0 % If open square
                    moveList{end+1} = [i, br];
                case {2,22} % If enemy piece, see if cappable
                    try
                    if logicBoard(br+offsets.br) == 0 && mod(i,8) < 7
                        evalHop(br+offsets.br, [i,br,br+offsets.br], true)
                    end
                    catch
                    end
            end
            catch
            end
            end
        end

        
%% Player 2 evaluation. Same as player 1 but we look down instead of up. 
    case {2, 22} 
        if ~player
            if mod(i,8) ~= 0
            try
            switch logicBoard(bl) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, bl];
                case {1, 11}
                    try
                    if logicBoard(bl+offsets.bl) == 0 && mod(i,8) < 7
                        evalHop(bl+offsets.bl, [i,bl,bl+offsets.bl], false)
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch logicBoard(br) % Check the right side jump
                case 0 % If open square
                    moveList{end+1} = [i, br];
                case {1,11} % If enemy piece, see if cappable
                    try
                    if logicBoard(br+offsets.br) == 0 && mod(i,8) < 7
                        evalHop(br+offsets.br, [i,br,br+offsets.br], false)
                    end
                    catch
                    end
            end
            catch
            end
            end
            
            % Now check other direction for kings
            if mod(i-1, 8) ~= 0 && logicBoard(i) == 22
            try
            switch logicBoard(ul) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, ul];
                case {1, 11}
                    try
                    if logicBoard(ul+offsets.ul) == 0 && mod(i-1,8) > 1
                        evalHop(ul+offsets.ul, [i,ul,ul+offsets.ul], false)
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch logicBoard(ur) % Check the right side jump
                case 0 % If open square
                    moveList{end+1} = [i, ur];
                case {1, 11} % If enemy piece, see if cappable
                    try
                    if logicBoard(ur+offsets.ur) == 0 && mod(i-1,8) > 1
                        evalHop(ur+offsets.ur, [i,ur,ur+offsets.ur], false)
                    end
                    catch
                    end
            end
            catch
            end
            end
        end
end
end

% Now, moveList{1} stores the indices in moveList{} where forced captures
% lay. Forced captures MUST be played if available, so they are the only
% legal moves. Only pass legal moves.
if ~isempty(moveList{1})
    moveList = moveList(moveList{1});

% If there are no forced captures, chop off the first index of moveList(),
% as it does not contain any moves.
else
    moveList = moveList(2:end);
end