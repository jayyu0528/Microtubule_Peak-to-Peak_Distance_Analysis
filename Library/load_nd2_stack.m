function img_stack = load_nd2_stack(filePath, fileName)

meta = imreadBFmeta([filePath fileName]);
numX = meta.width;
numY = meta.height;
numZ = meta.zsize;
numC = meta.channels;

img_stack = zeros( numX, numY, numZ , 'uint16') ;


img_stack(:,:,:) = uint16( imreadBF([filePath fileName], 1:numZ , 1 , 1 ) );