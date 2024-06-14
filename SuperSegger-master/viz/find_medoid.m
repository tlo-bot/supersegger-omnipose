function [x,y] = find_medoid(cellmask)

    %Find skeleton of binary mask
    BW2 = bwmorph(cellmask,'skel',Inf); 

    % Get the coordinates of all pixels in the skeleton
    [rows, cols] = find(BW2 == 1);
    pixels = [rows, cols];
    
    % Calculate the pairwise distance between all pixels
    dist_matrix = pdist2(pixels, pixels);
    
    % The medoid is the pixel with the minimum average distance to all other pixels
    [~, medoid_index] = min(mean(dist_matrix, 2));
    
    % Return the coordinates of the medoid
    x = pixels(medoid_index, 2);
    y = pixels(medoid_index, 1);
    
    % Display results
    % fprintf('The medoid of the cell is located at (%d, %d)\n', x, y);
    % imshow(imoverlay(cellmask, BW2, 'red'))
    % hold on;
    % plot(x,y,'g')

end