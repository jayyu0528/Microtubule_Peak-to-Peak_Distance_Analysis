function img_handle = imagesclim(img,cLim)

% does not include hold on to avoid some bugs; add externally
cla;
img_handle = imagesc(img); colormap gray; axis square; axis xy;
set(gca,'Clim',cLim);