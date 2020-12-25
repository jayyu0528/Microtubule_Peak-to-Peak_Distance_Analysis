function segment_data = start_segment_selection_and_analysis(fig_handle)

% Conserve across all gel types and samples
global window_radius % radius of intermediate ROI
global lineLength % length of line intensity profile
global lineWidth % width of line intensity profile
global rotation_method 

% Conserve within a sample
global cLim % contrast seetings
global img_stack
global zSize
global MIPS_z % MIP
global exp_factor
global pixel_size_nm_pre
global lineLength_pixel
global lineWidth_half_pixel

% Select ROI from global image (Point 0)
title('Select ROI to zoom into','fontsize',16)
[x0,y0] = select_point();
img_crop = MIPS_z(y0-window_radius : y0+window_radius, x0-window_radius : x0+window_radius);
img_handle = imagesclim(img_crop,cLim); hold on;

% Select P1 from local image
title('Select Point#1 for rotation','fontsize',16)
[x1, y1, ~] = select_point_with_fine_control(img_handle, [1 0 0]);

% Select P1 from local image
title('Select Point#2 for rotation','fontsize',16)
[x2, y2, ~] = select_point_with_fine_control(img_handle, [0 1 0]);

% Show guide line
plot([x1 x2],[y1 y2],'Color',[1 1 0])

% dist_pixel = sqrt((x2-x1).^2 + (y2-y1).^2);
% dist_nm_pre = dist_pixel .* pixel_size_nm_pre;

% Rotate img_crop based on P1 P2

angle_p1_to_p2 = calc_angle_between_points(x1,y1,x2,y2);

angle_rot = angle_p1_to_p2;

img_crop_rot = imrotate(img_crop,angle_rot,rotation_method);

figure(fig_handle);clf;
img_handle = imagesclim(img_crop_rot,cLim); hold on;

% figure;
% subplot(1,2,1); imagesc( imrotate(img_crop,angle_p1_to_p2) ); colormap gray
% subplot(1,2,2); imagesc( imrotate(img_crop,angle_p1_to_p2 ,'bilinear')); colormap gray

% Re-select centerline point
title('Select starting point of to-be-analyzed segment','fontsize',16)
[x3, y3, x_range, y_range] = select_segment_start_point(img_handle, [1 0 0]);


%% Validation: can recreate analyzed 2D image from source
% figure(5);clf
% subplot(1,2,1);
% imagesc( img_crop_rot(y_range,x_range) ); colormap gray; axis square; axis xy; hold on;
%
% % Recreate image from source stack
% imgR = MIPS_z;
% imgR_crop = imgR(y0-window_radius : y0+window_radius, x0-window_radius : x0+window_radius);
% imgR_crop_rot = imrotate(imgR_crop,angle_p1_to_p2);
%
% subplot(1,2,2);
% imagesc( imgR_crop_rot(y_range,x_range) ); colormap gray; axis square; axis xy; hold on;


%% Plot single-z-plane profiles at multiple planes from P0 to P1 with width W

% Cropped stack
img_stack_crop = img_stack(y0-window_radius : y0+window_radius, x0-window_radius : x0+window_radius, :);

img_stack_crop_rot = zeros(size(img_crop_rot,1),size(img_crop_rot,1),size(img_stack,3));
for z = 1:zSize
    img_stack_crop_rot(:,:,z) = imrotate(img_stack_crop(:,:,z),angle_rot);
end

img_stack_crop_rot_ROI = img_stack_crop_rot(y_range,x_range,:);

profile_avg_over_length = mean(img_stack_crop_rot_ROI,2);


mean_value_of_plane = squeeze(mean(profile_avg_over_length,1));
z_plane = find( mean_value_of_plane == max(mean_value_of_plane));

%%
figure(fig_handle);clf;

subplot(1,2,1);
img_handle = imagesclim( img_stack_crop_rot_ROI(:,:,z_plane),cLim);

subplot(1,2,2); hold on;

for z = 1:zSize
    plot(profile_avg_over_length( : , 1 , z) ,'Color',[1 1 1]*0.8);
end
red_line_handle = plot(profile_avg_over_length( : , 1 , z_plane) ,'Color',[1 0 0],'LineWidth',2);
black_pts_handle = plot(profile_avg_over_length( : , 1 , z_plane) ,'ok');

xlim([1 length(profile_avg_over_length(:,1,z))])

yLim = get(gca,'YLim');
set(gca,'YLim',yLim);

% Fine control by keyboard
while 1
    title('Up and Down Buttons: change z-plane | Space: continue','fontsize',16);
    set(img_handle,'CData',img_stack_crop_rot_ROI(:,:,z_plane));
    set(red_line_handle,'YData',profile_avg_over_length( : , 1 , z_plane));
    set(black_pts_handle,'YData',profile_avg_over_length( : , 1 , z_plane));
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
        case 30 % up key
            if check_value_in_range(z_plane + 1, 1, zSize )
                z_plane = z_plane + 1;
            end
        case 31 % down key
            if check_value_in_range(z_plane - 1, 1, zSize )
                z_plane = z_plane - 1;
            end
            
        case 32 % space key
            break % continue to next stage
            
    end
end


%%
subplot(1,2,2); cla; hold on;

% Raw data points
y_vals = profile_avg_over_length(:,z_plane); % full profile
x_vals = 1:length(y_vals);
plot(x_vals, y_vals,'ok')

% Gaussian fitting is simplified with BKG subtraction
BKG = min(y_vals);
y_vals = y_vals - BKG;
two_term_Gau_cfit = fit(x_vals',y_vals,'gauss2');

% 2-term-Gaussian-fit
x_vals_dummy = x_vals(1):0.1:x_vals(end);
y_vals_dummy = two_term_Gau_cfit(x_vals_dummy) + BKG;
plot(x_vals_dummy,y_vals_dummy,'r')

peak_to_peak_dist_pixel = abs(two_term_Gau_cfit.b2-two_term_Gau_cfit.b1);
peak_to_peak_dist_nm_pre = peak_to_peak_dist_pixel .* pixel_size_nm_pre ;

title('Space: Accept | R: Reject','fontsize',16,'fontweight','bold');

while 1
    btn = detect_button_press();
    
    switch btn
        case 114 % R key
            acceptance = 'Rejected';
            break % continue to next stage
        case 32 % space key
            acceptance = 'Accepted';
            break % continue to next stage
    end
end
    

%% Package output

% Do not need to save the global parameter -- saved 
% outside (in the stack_data)

segment_data = struct();
% Global -> Intermediate
segment_data.user_selected_pts.x0 = x0;
segment_data.user_selected_pts.y0 = y0;
% Rotation
segment_data.user_selected_pts.x1 = x1;
segment_data.user_selected_pts.y1 = y1;
segment_data.user_selected_pts.x2 = x2;
segment_data.user_selected_pts.y2 = y2;
% Analysis center point
segment_data.user_selected_pts.x3 = x3;
segment_data.user_selected_pts.y3 = y3;

segment_data.intermediate_vars.angle_p1_to_p2 = angle_p1_to_p2;
segment_data.intermediate_vars.angle_rot = angle_rot;
segment_data.intermediate_vars.x_range = x_range;
segment_data.intermediate_vars.y_range = y_range;

segment_data.fitting.profile_avg_over_length = profile_avg_over_length;
segment_data.fitting.z_plane = z_plane;
segment_data.fitting.x_vals = x_vals;
segment_data.fitting.y_vals = y_vals;
segment_data.fitting.BKG = BKG;
segment_data.fitting.two_term_Gau_cfit = two_term_Gau_cfit;
segment_data.fitting.peak_to_peak_dist_pixel = peak_to_peak_dist_pixel;
segment_data.fitting.peak_to_peak_dist_nm_pre = peak_to_peak_dist_nm_pre;
segment_data.fitting.acceptance = acceptance;

