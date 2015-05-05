function main()
    img_folder = 'jerry';
    focal_len = 428; %grail=628 jerry=428
    result_output = ['../results/' img_folder '_panorama.png'];
    %for harris
    sigma = 3;
    w = 5;
    threshold = 10000;
    k = 0.04;
    
    img_path = ['../images/' img_folder];
    
    disp('read images');
    [images, img_count, img_h, img_w] = readImages(img_path);
    
    disp('inverse warping (cylindrical projection)');
    [warped_images] = inverseWarping(images, img_count, img_h, img_w, focal_len);
    
    disp('harris corner detection');
    [featureX, featureY, R]= harrisDetection(warped_images, sigma, w, threshold, k);
    disp(length(featureX));
    figure;imshow(warped_images(:,:,:,1));
    hold on
    plot(featureX, featureY, 'r*');
    
    disp('feature description');
    [feature_pos, feature_descriptor] = siftDescriptor(warped_images, featureX, featureY);
    %[pos, orient, desc] = descriptorSIFT(warped_images(:,:,:,1), featureX, featureY);
    
    disp('feature matching'); % use KD-tree expedite the calculation
    disp('RANSAC'); % exclude outlier
    disp('image matching'); % use inliers to count translation amount between images
    disp('blender'); % blend images together
end