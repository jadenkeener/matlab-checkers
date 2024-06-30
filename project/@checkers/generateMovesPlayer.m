%% generateMovesPlayer(player)
% Generates cell array of all possible moves. Each index in checkers.moveList
% represents a possible moves. the moves are coded in vectors. the first
% index in the vector specifies the piece, and then each succesive index
% specifies its path. In cases of multiple captures, there will be several
% 'steps' on the path
%
function generateMovesPlayer()

% First, create an empty checkers.moveList. The checkers.moveList is a cell array holding all
% possible moves. checkers.moveList{1} holds an array that specifies the indices of
% checkers.moveList{} where a capture is possible. In checkers you HAVE to play a
% capture move if one is available to you
%
% indices 2:end of checkers.moveList{} hold the moves as a vector. Moves are
% formatted as follows:
%
% checkers.moveList{move#} = [index of piece to move, index of space to move to]
%
% The vector will be more than 2 long if we move multiple spaces in a move,
% when capturing for example. When capturing, we move on top of the piece,
% then follow through to the open square past it. The move vector gets even
% longer for chain captures, formatted the same way.
checkers.moveList =  {[]};

for i = 1:64
    
% These are the indexes of the squares immediately diaganol to our piece.
ur = i+checkers.offsets.ur;
ul = i+checkers.offsets.ul;
br = i+checkers.offsets.br;
bl = i+checkers.offsets.bl;


% Note about the function below: To avoid having a bunch of edge case
% checks for when we are on the sides of the board, we use try-catch
% statements. If an index fails (because we are on a side), we just fall
% into the catch which just exits the current evaluation.
switch checkers.logicBoard(i)
    % If black piece, do player ones rules
    case {1, 11} 
        % Only evaluate this if we want moves for player 1
        if player
            if mod(i-1, 8) ~= 0 % If we arent on the top edge of the board
            
            % First, evaluate the upper left square to see if we can move 
            % to it or capture a piece on it
            try
            switch checkers.logicBoard(ul) % 
                
                % If the space is empty we can move to it, so write that as
                % a possible move to the checkers.moveList
                case 0 
                    checkers.moveList{end+1} = [i, ul];
                    
                % If the space has an enemy piece on it, we might be able
                % to capture
                case {2, 22}
                    try
                    % If the space past the enemy piece is open, we can
                    % capture!
                    if checkers.logicBoard(ul+checkers.offsets.ul) == 0 && mod(i-1,8) > 1
                        % Now we need to see if we can perform a chain
                        % capture. This evaluation is a little complex, so
                        % we call a different function. read evalHop() for
                        % explanation of parameters
                        evalHop(ul+checkers.offsets.ul, [i,ul,ul+checkers.offsets.ul])
                    end
                    catch
                    end
            end
            catch
            end
            
            
            % Now do the same thing for the upper right square. The process
            % is all the same so comments will be sparse.
            try
            switch checkers.logicBoard(ur) 
                case 0 % If open square
                    checkers.moveList{end+1} = [i, ur];
                case {2, 22} % If enemy piece, see if cappable
                    try
                    if checkers.logicBoard(ur+checkers.offsets.ur) == 0 && mod(i-1,8) > 1
                        evalHop(ur+checkers.offsets.ur, [i,ur,ur+checkers.offsets.ur])
                    end
                    catch
                    end
            end
            catch
            end
            end
            
            % IF OUR PIECE IS A KING: then we need to check the other two
            % directions
            if mod(i,8) ~= 0 && checkers.logicBoard(i) == 11
            try
            switch checkers.logicBoard(bl) % Check the left side jump
                case 0 % If open square
                    checkers.moveList{end+1} = [i, bl];
                case {2, 22}
                    try
                    if checkers.logicBoard(bl+checkers.offsets.bl) == 0 && mod(i,8) < 7
                        evalHop(bl+checkers.offsets.bl, [i,bl,bl+checkers.offsets.bl])
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch checkers.logicBoard(br) % Check the right side jump
                case 0 % If open square
                    checkers.moveList{end+1} = [i, br];
                case {2,22} % If enemy piece, see if cappable
                    try
                    if checkers.logicBoard(br+checkers.offsets.br) == 0 && mod(i,8) < 7
                        evalHop(br+checkers.offsets.br, [i,br,br+checkers.offsets.br])
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
            switch checkers.logicBoard(bl) % Check the left side jump
                case 0 % If open square
                    checkers.moveList{end+1} = [i, bl];
                case {1, 11}
                    try
                    if checkers.logicBoard(bl+checkers.offsets.bl) == 0 && mod(i,8) < 7
                        evalHop(bl+checkers.offsets.bl, [i,bl,bl+checkers.offsets.bl])
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch checkers.logicBoard(br) % Check the right side jump
                case 0 % If open square
                    checkers.moveList{end+1} = [i, br];
                case {1,11} % If enemy piece, see if cappable
                    try
                    if checkers.logicBoard(br+checkers.offsets.br) == 0 && mod(i,8) < 7
                        evalHop(br+checkers.offsets.br, [i,br,br+checkers.offsets.br])
                    end
                    catch
                    end
            end
            catch
            end
            end
            
            % Now check other direction for kings
            if mod(i-1, 8) ~= 0 && checkers.logicBoard(i) == 22
            try
            switch checkers.logicBoard(ul) % Check the left side jump
                case 0 % If open square
                    checkers.moveList{end+1} = [i, ul];
                case {1, 11}
                    try
                    if checkers.logicBoard(ul+checkers.offsets.ul) == 0 && mod(i-1,8) > 1
                        evalHop(ul+checkers.offsets.ul, [i,ul,ul+checkers.offsets.ul])
                    end
                    catch
                    end
            end
            catch
            end
            try
            switch checkers.logicBoard(ur) % Check the right side jump
                case 0 % If open square
                    checkers.moveList{end+1} = [i, ur];
                case {1, 11} % If enemy piece, see if cappable
                    try
                    if checkers.logicBoard(ur+checkers.offsets.ur) == 0 && mod(i-1,8) > 1
                        evalHop(ur+checkers.offsets.ur, [i,ur,ur+checkers.offsets.ur])
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
end