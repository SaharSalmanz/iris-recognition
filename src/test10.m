[img,normnoise]=normalise('020_1_3.bmp',40,240);
 %gaborArray = gaborFilterBank(5,8,39,39);  % Generates the Gabor filter bank
 %featureVector = gaborFeatures(img,gaborArray,4,4);   % Extracts Gabor feature vector, 'featureVector', from the image, 'img'.
 [template1, mask1] = encode(img,normnoise, 1, 18,1, 0.5);
 
 [img,normnoise]=normalise('003_1_3.bmp',40,240);
 %gaborArray = gaborFilterBank(5,8,39,39);  % Generates the Gabor filter bank
 %featureVector = gaborFeatures(img,gaborArray,4,4);   % Extracts Gabor feature vector, 'featureVector', from the image, 'img'.
 [template2, mask2] = encode(img,normnoise, 1, 18,1, 0.5);
 
 [hd] = matching(template1, mask1, template2, mask2, 1)
 