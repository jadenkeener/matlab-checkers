%% drawBoard()
% draw board based on current game state. this board is stored in
% imageBoard.
function imageBoard = drawBoard()
global logicBoard
res = 100;
res = res*8;

% Initialize our image array (imageBoard)
imageBoard = zeros(res);

% These arrays make light and dark squares, and are slid into imageBoard in
% the following for loop to create the checkerboard.
boardDark = 3*ones(res/8);
boardLight = 4*ones(res/8);




% Create checker background pattern
for r = 1:8 % For each row
    for c = 1:8 % and each column
        % The following operations grab an eighth of the board at a time,
        % then set it to its correct color
        if mod(r+c,2) == 0
            imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = boardDark;
        else
            imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = boardLight;
        end
    end
end

% This is super jank, but for the colormap to work correctly we need
% atleast one pixel of each color is on the board at all times. 
% This ensures that happens.
imageBoard(1) = 5;
imageBoard(res) = 1;
imageBoard(end) = 2;




% Creating a 'circular' array mask used to paint the chips on to imageBoard
x = 1:res/8;
y = 1:res/8;
cx = res/8/2; % circle center
cy = res/8/2; % circle center
r = res/8/2; % radius 
mask =((x-cx).^2 + (y'-cy).^2) < r^2  ; % Creating a mask


% Now create a another circular mask with half the radius. This is used to
% signify a piece as a king
kingMask =((x-cx).^2 + (y'-cy).^2) < (r/2)^2  ; % Creating a mask



% Now draw the chips on the board. We find piece locations from logicBoard,
% then paint them on to the corresponding positions in imageBoard.
for r = 1:8
    for c = 1:8
    switch logicBoard(r,c)
        % Draw our pawns
        case {1, 2} 
            % We take the 'tile', spraypaint the checker over it, then load
            % it back into the imageBoard
            tile = imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8);
            tile(mask) = logicBoard(r,c);
            imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = tile;
        
        % For Kings we first paint the pawn, then paint the king gold over
        % it
        case {11, 22} 
            tile = imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8);
            tile(mask) = logicBoard(r,c)/11;
            tile(kingMask) = 5;
            imageBoard(1+(r-1)*res/8:r*res/8, 1+(c-1)*res/8:c*res/8) = tile;  
    end
    end
end

% Build custom colormap
% color order is: player1, player2, boardDark, boardLight, king color
colors = [0, 0, 0; 255, 0, 0; 112, 72, 19;240, 221, 161; 255, 196, 0];
colors = colors./255;

% Draw our board image
colormap(colors)
imagesc(imageBoard)
set(gca, 'YTickLabel', [], 'XTickLabel', [], 'xtick', [], 'ytick', [])
axis square
end