function [x_loc, y_loc, x_range, y_range] = select_segment_start_point(img_handle, point_color)

global lineLength_pixel;
global lineWidth_half_pixel;

% Select point by mouse click first
[x_loc,y_loc] = select_point();

% Create red point
point_handle = plot(x_loc,y_loc,'Marker','*','Color',point_color);
% Create yellow line
line_handle = plot([x_loc x_loc+lineLength_pixel-1],[y_loc y_loc],'color',[1 1 0]);
% Create yellow block
x_range = x_loc:(x_loc+lineLength_pixel-1);
y_range = (y_loc-lineWidth_half_pixel):(y_loc+lineWidth_half_pixel);
block_handle = fill([x_range(1) x_range(end) x_range(end) x_range(1)],...
    [y_range(end) y_range(end) y_range(1) y_range(1)],...
    [1 1 0],...
    'edgeColor','none',...
    'facealpha',0.5);

img_crop = img_handle.CData;

% Fine control by keyboard
while 1
    
    title('Arrow keys: move point | Space: Continue','fontsize',16)
    
    set(point_handle,'XData',x_loc,'YData',y_loc);
    set(line_handle,'XData',[x_loc x_loc+lineLength_pixel-1],'YData',[y_loc y_loc]);
    x_range = x_loc:(x_loc+lineLength_pixel-1);
    y_range = (y_loc-lineWidth_half_pixel):(y_loc+lineWidth_half_pixel);
    set(block_handle,'XData',[x_range(1) x_range(end) x_range(end) x_range(1)],'YData',[y_range(end) y_range(end) y_range(1) y_range(1)]);
    
    btn = detect_button_press();
    
    switch btn
        case 28 % left key
            if check_value_in_range(x_loc - 1, 1, size(img_crop,1) )
                x_loc = x_loc - 1;
            end
        case 29 % right key
            if check_value_in_range(x_loc + 1, 1, size(img_crop,1) )
                x_loc = x_loc + 1;
            end
        case 30 % up key
            if check_value_in_range(y_loc + 1, 1, size(img_crop,2) )
                y_loc = y_loc + 1;
            end
        case 31 % down key
            if check_value_in_range(y_loc - 1, 1, size(img_crop,2) )
                y_loc = y_loc - 1;
            end
        case 32 % space key
            break % continue to next stage
            
    end
end