function [x_loc, y_loc, point_handle] = select_point_with_fine_control(img_handle, point_color)

% Select point by mouse click first
[x_loc,y_loc] = select_point();

% Create red point
point_handle = plot(x_loc,y_loc,'Marker','*','Color',point_color);

img_crop = img_handle.CData;

% Fine control by keyboard
while 1
    set(point_handle,'XData',x_loc,'YData',y_loc);
    
    title('Arrow keys: move point | Space: Continue','fontsize',16)
    
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
%         case 99 % C key - adjust contrast
%             while 1
%                 [~, ~, img_crop] = display_global_and_local_panels(fig_handle, stack, particle_data_2, p, x1, y1, z_plane, lineLength2, contrast_low, contrast_high);
%                 update_panel_title_II(fig_handle,[1,4],sprintf('left right keys: adjust lower boundary \n up down keys: adjust higher boundary \n Space: continue'),12,[0 0 0])
%                 btn2 = detect_button_press();
%                 switch btn2
%                     case 28 % left key
%                         if check_value_in_range(contrast_low - 100, 1, min([65535 contrast_high-1]) )
%                             contrast_low = contrast_low - 100;
%                         end
%                     case 29 % right key
%                         if check_value_in_range(contrast_low + 100, 1, min([65535 contrast_high-1]) )
%                             contrast_low = contrast_low + 100;
%                         end
%                     case 30 % up key
%                         if check_value_in_range(contrast_high + 300, max([1 contrast_low+1]) ,  65535)
%                             contrast_high = contrast_high + 300;
%                         end
%                     case 31 % down key
%                         if  check_value_in_range(contrast_high - 300, max([1 contrast_low+1]) , 65535)
%                             contrast_high = contrast_high - 300;
%                         end
%                     case 32 % space key
%                         break;
%                 end
%             end
%             
%         case 115 % save key -- save workspace and exit
%             WidthMeasurement.Status = 'SaveSignal';
%             return
        case 32 % space key
            break % continue to next stage
            
    end
end