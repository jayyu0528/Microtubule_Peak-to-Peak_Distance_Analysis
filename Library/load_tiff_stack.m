function img_stack = load_tiff_stack(filePath, fileName)

% meta = imreadBFmeta([filePath fileName]);
% numX = meta.width;
% numY = meta.height;
% numZ = meta.zsize;
% numC = meta.channels;
% 
% img_stack = zeros( numX, numY, numZ , 'uint16') ;
% 
% 
% img_stack(:,:,:) = uint16( imreadBF([filePath fileName], 1:numZ , 1 , 1 ) );

meta = imfinfo([filePath fileName]);
numX = meta(1).Width;
numY = meta(1).Height;
numZ = numel(meta);

img_stack = zeros( numX, numY, numZ , 'uint16');

for z = 1:numZ
    img_stack(:,:,z) = imread([filePath fileName], z);
end

