% Tubulin analysis

%% Parameter Setup
clear; clc; close all

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

%%
answer = questdlg('Load existing data?','Load option','Yes','No','No');

switch answer
    case 'No' % Start fresh
        %% Select and load stack
        
        [fileName, filePath] = uigetfile('*','Select nd2 or tif file');
        
        answers = inputdlg('Expansion Factor','Input',1);
        exp_factor = str2double(answers{1});
        
        window_radius = 30; % pixels
        lineLength = 200; % nm_pre
        lineWidth = 300; % nm_pre
        cLim = [100 300]; % intensity values
        pixel_size_nm_pre = 162.5 ./ exp_factor;
        rotation_method = 'nearest'; % nearest neighbor
        
        lineLength_pixel = ceil(lineLength ./ pixel_size_nm_pre);
        lineWidth_half_pixel = ceil(lineWidth ./ pixel_size_nm_pre / 2);
        
        [img_stack, zSize, MIPS_z] = load_image_stack(filePath, fileName);
        
        % Initialize saved structure
        stack_data.parameters.filePath = filePath;
        stack_data.parameters.fileName = fileName;
        stack_data.parameters.window_radius = window_radius;
        stack_data.parameters.lineLength = lineLength;
        stack_data.parameters.lineWidth = lineWidth;
        stack_data.parameters.rotation_method = rotation_method;
        stack_data.parameters.cLim = cLim;
        % stack_data.parameters.img_stack = img_stack; % too large
        stack_data.parameters.zSize = zSize;
        % stack_data.parameters.MIPS_z = MIPS_z; % too large
        stack_data.parameters.exp_factor = exp_factor;
        stack_data.parameters.pixel_size_nm_pre = pixel_size_nm_pre;
        stack_data.parameters.lineLength_pixel = lineLength_pixel;
        stack_data.parameters.lineWidth_half_pixel = lineWidth_half_pixel;
        
        segments_data = struct([]);
        
        current_segment_index = 1;
        
    case 'Yes'
        [loadName, loadPath] = uigetfile('*','Select .mat file');
        load([loadPath loadName],'stack_data','current_segment_index');
        
        % Extract info into workspace
        
        filePath = stack_data.parameters.filePath;
        fileName = stack_data.parameters.fileName;
        window_radius = stack_data.parameters.window_radius;
        lineLength = stack_data.parameters.lineLength;
        lineWidth = stack_data.parameters.lineWidth;
        rotation_method = stack_data.parameters.rotation_method;
        cLim = stack_data.parameters.cLim;
        zSize = stack_data.parameters.zSize;
        exp_factor = stack_data.parameters.exp_factor;
        pixel_size_nm_pre = stack_data.parameters.pixel_size_nm_pre;
        lineLength_pixel = stack_data.parameters.lineLength_pixel;
        lineWidth_half_pixel = stack_data.parameters.lineWidth_half_pixel;
        
        segments_data = stack_data.segments_data;
        
        % Load stack and MIPS
        [img_stack, zSize, MIPS_z] = load_image_stack(filePath, fileName);
        
end

%% Main Loop after all previous states are setup

% Get display resolution
set(0,'units','pixels');  % 0 is root object
display_size = get(0,'screensize');
display_size = display_size(3:4);

fig_handle = figure(1); clf;
set(fig_handle,'Position',[display_size(1)*0.05 display_size(2)*0.10 display_size(1)*0.90 display_size(2)*0.75])

% Main Loop
while 1 
    try
        display_main_frame_Z_MIPS_and_analyzed_segments(fig_handle, segments_data)

        action = select_action_at_main_frame(fig_handle);
        switch action
            case 'proceed_to_next_segment'
                % Go into segment selection and analysis
                segment_data = start_segment_selection_and_analysis(fig_handle);
                segments_data = [segments_data segment_data];
                current_segment_index = current_segment_index + 1;
            case 'save_and_exit'
                % Store segments data into the framing stack_data
                % and then save stack_data
                stack_data.segments_data = segments_data;
                save_data_and_close_figure('Tubulin_Segments_Data_', fig_handle, stack_data, current_segment_index);
                break;
        end
    catch curr_exception
        % if error occured
        disp(curr_exception);
        answer = questdlg('An error has caused the code to crash. Save stack_data up to this point?','Emergency saving option','Yes','No','Yes');
        if strcmp(answer,'Yes')
            stack_data.segments_data = segments_data;
            save_data_and_close_figure('Tubulin_Segments_Data_', fig_handle, stack_data, current_segment_index, curr_exception);
        else
            close(fig_handle);
        end
        break;
    end
    
end
