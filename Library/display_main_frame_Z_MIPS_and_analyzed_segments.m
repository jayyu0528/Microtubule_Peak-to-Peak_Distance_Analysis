function display_main_frame_Z_MIPS_and_analyzed_segments(fig_handle, segments_data)

global MIPS_z
global cLim

% Plot Z-MIPS
figure(fig_handle); clf;
imagesclim(MIPS_z,cLim); hold on;
% Plot analyzed locations
if size(segments_data,2) > 0
    for s = 1:size(segments_data,2)
        switch segments_data(s).fitting.acceptance
            case 'Accepted'
                text_color = [1 0 0];
            case 'Rejected'
                text_color = [0 1 1];
        end
        text(segments_data(s).user_selected_pts.x0,...
            segments_data(s).user_selected_pts.y0,...
            num2str(s),'Color',text_color,...
            'FontSize',14,'FontWeight','bold','HorizontalAlignment','center',...
            'VerticalAlignment','middle');
    end
end
hold off;