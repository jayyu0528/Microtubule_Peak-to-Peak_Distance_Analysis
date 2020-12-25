function action = select_action_at_main_frame(fig_handle)

global cLim
global MIPS_z
contrast_adj_increment = 50;

title('Space: Proceed to next segment | C: Adjust contrast | S: Save and Exit','fontsize',16);

while 1
    btn = detect_button_press();
    
    switch btn
%         case 28 % left key
%             if check_value_in_range(x_loc - 1, 1, size(img_crop,1) )
%                 x_loc = x_loc - 1;
%             end
%         case 29 % right key
%             if check_value_in_range(x_loc + 1, 1, size(img_crop,1) )
%                 x_loc = x_loc + 1;
%             end
%         case 30 % up key
%             if check_value_in_range(y_loc + 1, 1, size(img_crop,2) )
%                 y_loc = y_loc + 1;
%             end
        case 32 % space key
            action = 'proceed_to_next_segment';
            return
        case 99 % C key - adjust contrast
            while 1
                figure(fig_handle); clf;
                imagesclim(MIPS_z,cLim); hold on;
                
                title(sprintf('left right keys: adjust lower boundary \n up down keys: adjust higher boundary \n Space: continue'));
                btn2 = detect_button_press();
                switch btn2
                    case 28 % left key
                        if check_value_in_range(cLim(1) - contrast_adj_increment, 1, min([65535 cLim(2)-1]) )
                            cLim(1) = cLim(1) - contrast_adj_increment;
                        end
                    case 29 % right key
                        if check_value_in_range(cLim(1) + contrast_adj_increment, 1, min([65535 cLim(2)-1]) )
                            cLim(1) = cLim(1) + contrast_adj_increment;
                        end
                    case 30 % up key
                        if check_value_in_range(cLim(2) + contrast_adj_increment, max([1 cLim(1)+1]) ,  65535)
                            cLim(2) = cLim(2) + contrast_adj_increment;
                        end
                    case 31 % down key
                        if  check_value_in_range(cLim(2) - contrast_adj_increment, max([1 cLim(1)+1]) , 65535)
                            cLim(2) = cLim(2) - contrast_adj_increment;
                        end
                    case 32 % space key
                        action = 'contrast adjusted';
                        return;
                end
            end
%             
        case 115 % save key -- save workspace and exit
            action = 'save_and_exit';
            return
            
    end
end