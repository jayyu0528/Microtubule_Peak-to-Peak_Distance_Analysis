function [MIPS_x, MIPS_y, MIPS_z] = make_MIPS_for_stack(img_stack)

% Load landmark & ExFISH channels of .nd2 stacks into workspace
% img_stack = load_nd2_stack(filePath, fileName, channel_order);

[numX, numY, numZ, ~] = size(img_stack);

% Pre-allocate MIPS image with RGB
MIPS_x = uint16(zeros(numY, numZ));
MIPS_y = uint16(zeros(numX, numZ));
MIPS_z = uint16(zeros(numX, numY));

MIPS_x(:,:) = squeeze(max(img_stack,[],1));
MIPS_y(:,:) = squeeze(max(img_stack,[],2));
MIPS_z(:,:) = squeeze(max(img_stack,[],3));

% MIPS_folder_name = 'MIPS/';
% MIPS_write_path = [filePath,  MIPS_folder_name];
% 
% if ~exist(MIPS_write_path,'dir')
%     mkdir(MIPS_write_path)
% end
% 
% imwrite(MIPS_x, [MIPS_write_path 'MIPS_X ' fileName(1:end-4) '.tif' ] )
% imwrite(MIPS_y, [MIPS_write_path 'MIPS_Y ' fileName(1:end-4) '.tif' ] )
% imwrite(MIPS_z, [MIPS_write_path 'MIPS_Z ' fileName(1:end-4) '.tif' ] )
