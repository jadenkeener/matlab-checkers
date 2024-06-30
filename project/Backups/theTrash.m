%% evaluateHop

function evaluateHop(i, move, player)
global logicBoard
global moveList
global offsets
          
ur = i+offsets.ur;
ul = i+offsets.ul;
br = i+offsets.br;
bl = i+offsets.bl;
          
fail = 0; % Fail keeps track of whether or not our chip has run out of
          % captures. Failing twice writes the move string to
          % moveList{}

switch player
case true % For player 1
    if i < 9
        if (logicBoard(ur) == 2) || (logicBoard(ur) == 22)
            if logicBoard(ur+offsets.ur) == 0
                move = [move, ur+offsets.ur];
                evaluateHop(ur+offsets.ur, move, true)
            else
                moveList{end+1} = move;
            end
        end
    elseif i > 56
        if (logicBoard(ul) == 2) || (logicBoard(ul) == 22)
            if logicBoard(ul+offsets.ul) == 0
                move = [move, ul+offsets.ul];
                evaluateHop(ul+offsets.ul, move, true)
            else
                moveList{end+1} = move;
            end
        end
    else % Default case
        if (logicBoard(ul) == 2) || (logicBoard(ul) == 22)
            if logicBoard(ul+offsets.ul) == 0
                move = [move, ul+offsets.ul];
                evaluateHop(ul+offsets.ul, move, true)
            else
                fail = fail+1;
            end
        end
        if (logicBoard(ur) == 2) || (logicBoard(ur) == 22)
            if logicBoard(ur+offsets.ur) == 0
                move = [move, ur+offsets.ur];
                evaluateHop(ur+offsets.ur, move, true)
            else
                fail = fail+1;
            end
        end
        if fail == 2
            moveList{end+1} = move;
        end
    end
    
    
    
    
case false
    if i < 9
        if (logicBoard(br) == 1) || (logicBoard(br) == 11)
            if logicBoard(br+offsets.br) == 0
                move = [move, br+offsets.br];
                evaluateHop(br+offsets.br, move, true)
            else
                moveList{end+1} = move;
            end
        end
    elseif i > 56
        if (logicBoard(bl) == 1) || (logicBoard(bl) == 11)
            if logicBoard(bl+offsets.bl) == 0
                move = [move, bl+offsets.bl];
                evaluateHop(bl+offsets.bl, move, true)
            else
                moveList{end+1} = move;
            end
        end
    else % Default case
        if (logicBoard(bl) == 1) || (logicBoard(bl) == 11)
            if logicBoard(bl+offsets.bl) == 0
                move = [move, bl+offsets.bl];
                evaluateHop(bl+offsets.bl, move, true)
            else
                fail = fail+1;
            end
        end
        if (logicBoard(br) == 1) || (logicBoard(br) == 11)
            if logicBoard(br+offsets.br) == 0
                move = [move, br+offsets.br];
                evaluateHop(br+offsets.br, move, true)
            else
                fail = fail+1;
            end
        end
        if fail == 2
            moveList{end+1} = move;
        end
    end
end
end






%% generateMoves
% Generates cell array of all possible moves. Each index in moveList
% represents a possible moves. the moves are coded in vectors. the first
% index in the vector specifies the piece, and then each succesive index
% specifies its path. In cases of multiple captures, there will be several
% 'steps' on the path
%
function generateMovesTotal()
global logicBoard
global moveList
global offsets

% First, empty our moveList
moveList =  {[captures]};

for i = 1:64
ur = i+offsets.ur;
ul = i+offsets.ul;
br = i+offsets.br;
bl = i+offsets.bl;

switch logicBoard(i)
    case {1, 11} % Player 1 rules
            if mod(i-1, 8) ~= 0
            try
            switch logicBoard(ul) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, ul];
                case {2, 22}
                    try
                    if logicBoard(ul+offsets.ul) == 0
                        evalHop(ul+offsets.ul, [i,ul,ul+offsets.ul], true)
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
                case {2, 22} % If enemy piece, see if cappable
                    try
                    if logicBoard(ur+offsets.ur) == 0
                        evalHop(ur+offsets.ur, [i,ur,ur+offsets.ur], true)
                    end
                    catch
                    end
            end
            catch
            end
            end
            
            % Now check the other direction for kings
            if mod(i,8) ~= 0 && logicBoard(i) == 11
            try
            switch logicBoard(bl) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, bl];
                case {2, 22}
                    try
                    if logicBoard(bl+offsets.bl) == 0
                        evalHop(bl+offsets.bl, [i,b1,bl+offsets.bl], true)
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
                    if logicBoard(br+offsets.br) == 0
                        evalHop(br+offsets.br, [i,br,br+offsets.br], true)
                    end
                    catch
                    end
            end
            catch
            end
            end

        
         
    case {2, 22} % Player 1 rules
            if mod(i,8) ~= 0
            try
            switch logicBoard(bl) % Check the left side jump
                case 0 % If open square
                    moveList{end+1} = [i, bl];
                case {1, 11}
                    try
                    if logicBoard(bl+offsets.bl) == 0
                        evalHop(bl+offsets.bl, [i,b1,bl+offsets.bl], true)
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
                    if logicBoard(br+offsets.br) == 0
                        evalHop(br+offsets.br, [i,br,br+offsets.br], true)
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
                    if logicBoard(ul+offsets.ul) == 0
                        evalHop(ul+offsets.ul, [i,ul,ul+offsets.ul], true)
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
                    if logicBoard(ur+offsets.ur) == 0
                        evalHop(ur+offsets.ur, [i,ur,ur+offsets.ur], true)
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
