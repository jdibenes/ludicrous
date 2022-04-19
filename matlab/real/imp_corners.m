
function c = imp_corners(im, box)
c = detectHarrisFeatures(im, 'ROI', box);
c = c.selectStrongest(1);
end
