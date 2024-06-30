%% evalHop
% Special function for evaluating captures. Used to detect and
% write capture chain moves to moveList.
%
% i = index of piece AFTER performing a hop
% move = array of piece location history
% player = true if p1, false if p2.
%
% This function is designed to be called recursively
%
function evalHop(i, move, player)
global logicBoard
global moveList
global offsets




% Define locations around us
ur = i+offsets.ur;
ul = i+offsets.ul;
br = i+offsets.br;
bl = i+offsets.bl;

fail = 0; % Fail keeps track of whether or not our chip has run out of
          % captures. Failing twice writes the move string to
          % moveList{}. 
          
% We need to take some precautions. Because a king can go in
% any direction it will jump a piece, then, when checking for another
% piece to capture, it will see the same piece and capture it again.
% So on and so forth ad infinitum. For this reason, we need to
% create a temporary copy of hopBoard where all the move indexes listed
% in move() are set to zero, so that it doesnt see them as potential
% captures any more.
% We keep hopBoard(move(1)) the same because it holds useful information
% about the piece we are playing.
hopBoard = logicBoard;
hopBoard(move(2:end)) = 0;  

     


          
% The try-catch statements below let us escape the horror of trying to make
% sure that the index of our hopBoard is always a positive number. Now if
% i is negative, we simply error out and catch it by adding one to our fail
% counter
switch player
    case true % For player 1
        
        % If there is a piece to caputure to our upper left, and we can 
        % capture it without going off the board
        try
        if ((hopBoard(ul) == 2) || (hopBoard(ul) == 22)) && ...
            mod(i-1,8) > 1
            try
                
            % And if there is an empty spot to jump to past it.
            if hopBoard(ul+offsets.ul) == 0
                
                % Take the capture and see if we can cap again (recursive)
                moveWIP = [move, ul, ul+offsets.ul];
                evalHop(ul+offsets.ul, moveWIP, true)
                
            % In any other situation, fail additional capture
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        catch
            fail = fail+1;
        end
        
        
        
        % Now do the same thing, but for the upper right spot
        try
        if ((hopBoard(ur) == 2) || (hopBoard(ur) == 22)) &&...
            mod(i-1,8) > 1
        
            try
            if hopBoard(ur+offsets.ur) == 0
                
                moveWIP = [move, ur, ur+offsets.ur];
                evalHop(ur+offsets.ur, moveWIP, true)
              
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        catch
            fail = fail+1;
        end
        
        % If there were no other available captures (fail ==2), write the
        % move sequence to moveList and go home. However, only do this for
        % pawns. Kings need to fail 4 times. move(1) holds the index of the
        % playing piece.
        if fail == 2 && hopBoard(move(1)) == 1
            moveList{end+1} = move;
            moveList{1} = [moveList{1}, length(moveList)];
        end
        
        % Now, check the other direction if our piece is a king. Kings are
        % denoted by 11 or 22. move(1) holds the index of the playing piece.
        if hopBoard(move(1)) == 11
        try
        if ((hopBoard(bl) == 2) || (hopBoard(bl) == 22)) &&...
            mod(i,8) < 7
            try
            if hopBoard(bl+offsets.bl) == 0
                moveWIP = [move, bl, bl+offsets.bl];
                evalHop(bl+offsets.bl, moveWIP, true)
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        catch
            fail = fail+1;
        end
        
        try
        if ((hopBoard(br) == 2) || (hopBoard(br) == 22)) &&...
            mod(i,8) < 7
            try
            if hopBoard(br+offsets.br) == 0
                moveWIP = [move, br, br+offsets.br];
                evalHop(br+offsets.br, moveWIP, true)
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        catch
            fail = fail+1;
        end
        
        
        if fail == 4
            moveList{end+1} = move;
            moveList{1} = [moveList{1}, length(moveList)];
        end
        end
        
        
        
        
        
        
        
        
        
        
%% Player 2 rules. Same concept as player 1 rules
    case false 
        
        try
        if ((hopBoard(bl) == 1) || (hopBoard(bl) == 11)) &&...
            mod(i,8) < 2
            try
            if hopBoard(bl+offsets.bl) == 0
                moveWIP = [move, bl, bl+offsets.bl];
                evalHop(bl+offsets.bl, moveWIP, false)
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        catch
            fail = fail+1;
        end
        
        try
        if ((hopBoard(br) == 1) || (hopBoard(br) == 11)) &&...
            mod(i,8) < 7
            try
            if hopBoard(br+offsets.br) == 0
                moveWIP = [move, br, br+offsets.br];
                evalHop(br+offsets.br, moveWIP, false)
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        catch
            fail = fail+1;
        end
        
        
        if fail == 2 && hopBoard(move(1)) == 2
            moveList{end+1} = move;
            moveList{1} = [moveList{1}, length(moveList)];
        end
        
        
        
        % Now, check the other direction if our piece is a king. Kings are
        % denoted by 11 or 22. move(1) holds the index of the playing piece
        if hopBoard(move(1)) == 22
        try
        if ((hopBoard(ul) == 1) || (hopBoard(ul) == 11)) &&...
            mod(i-1,8) > 1
            try
                
            % And if there is an empty spot to jump to past it.
            if hopBoard(ul+offsets.ul) == 0
                
                % Take the capture and see if we can cap again (recursive)
                moveWIP = [move, ul, ul+offsets.ul];
                evalHop(ul+offsets.ul, moveWIP, false)
                
            % In any other situation, fail additional capture
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        catch
            fail = fail+1;
        end
        
        
        
        % Now do the same thing, but for the upper right spot
        try
        if ((hopBoard(ur) == 1) || (hopBoard(ur) == 11)) &&...
            mod(i-1,8) > 1
        
            try
            if hopBoard(ur+offsets.ur) == 0
                
                moveWIP = [move, ur, ur+offsets.ur];
                evalHop(ur+offsets.ur, moveWIP, false)
              
            else
                fail = fail+1;
            end
            catch
                fail = fail+1;
            end
        else
            fail = fail+1;
        end
        catch
            fail = fail+1;
        end
        
        
        if fail == 4
            moveList{end+1} = move;
            moveList{1} = [moveList{1}, length(moveList)];
        end
        end
        
end
end