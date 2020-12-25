function img_output = make_contrasted_image( img, contrast_low, contrast_high )

img_output = imadjust(img ./ 6, [contrast_low contrast_high] ./ [65535 65535]);

end