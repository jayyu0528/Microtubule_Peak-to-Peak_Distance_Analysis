function [img_stack, zSize, MIPS_z] = load_image_stack(filePath, fileName)

% Load stack into RAM
switch fileName(end-2:end)
    case 'nd2'
        img_stack = load_nd2_stack(filePath, fileName);
    case'tif'
        img_stack = load_tiff_stack(filePath, fileName);
end

zSize = size(img_stack,3);

% Make Z-MIPS
[~, ~, MIPS_z] = make_MIPS_for_stack(img_stack);