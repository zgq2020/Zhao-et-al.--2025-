function IR_trax(vidName, start_time_min, end_time_min,YourPath,z1,z2)
vid = VideoReader(vidName);
addpath(YourPath)

%% Modified parameters
erode = 2;% The parameters of the white-and-black model are used for erosion operations in image processing to reduce the size of detected objects.
sens = 0.1;% A sensitivity parameter of the white-and-black model is used for image segmentation to control the threshold of binarization.

%% Vision.BlobAnalysis 
hblob = vision.BlobAnalysis(...
    'CentroidOutputPort', true, ...
    'AreaOutputPort', true, ...%Return blob area, specified as true or false.
    'BoundingBoxOutputPort', true, ...
    'MinimumBlobAreaSource', 'Property',...
    'MajorAxisLengthOutputPort',true,...
    'MinorAxisLengthOutputPort',true,...
    'BoundingBoxOutputPort',true,...
    'EccentricityOutputPort',true,...
    'OrientationOutputPort',true,...
    'MinimumBlobArea', 50, ...% Minimum Blob Area %     
    'MaximumBlobArea', 1000, ...
    'MaximumCount', 10000);%blob detector

counter = 1;
data = {};
start_time = start_time_min * 60; % s
end_time = end_time_min * 60; % s
vid.CurrentTime = start_time; 
FR = vid.FrameRate;
videoPlayer = vision.VideoPlayer;

%% Save the visual video
% outputVideo = VideoWriter('foreground_extraction.mp4', 'MPEG-4');
% outputVideo.FrameRate = FR;
% open(outputVideo); 
% figure('Position', [0, 0, 1200, 580]); % Create a window to display the image, and set to the size of the original video
% initialFrameSize = size(initialFrame); % Obtain the size of the initial frame.

while vid.CurrentTime <= end_time && hasFrame(vid)
    frame = (readFrame(vid));
    frame = im2gray(frame);

    % white-and-black model
    [BW] = segmentImage5v1(frame,erode,sens);
    BW_inv = ~BW;
    dframe =  BW_inv;

    [Areas,CTs,BB,MALs,MiALs,Orients,Ecens] = hblob(dframe);
    
    % Visualization
%     blobImage = frame;
%     for i = 1:size(Areas, 1)
%         moi = dframe(BB(i, 2):BB(i, 2) + BB(i, 4) - 1, BB(i, 1):BB(i, 1) + BB(i, 3) - 1);
%         mask = (moi > 0);
%         blobImage(BB(i, 2):BB(i, 2) + BB(i, 4) - 1, BB(i, 1):BB(i, 1) + BB(i, 3) - 1, 1) = ...
%             uint8(mask) * 255;  % Red channel
%         blobImage(BB(i, 2):BB(i, 2) + BB(i, 4) - 1, BB(i, 1):BB(i, 1) + BB(i, 3) - 1, 2) = ...
%             uint8(~mask) * 0;  % Green channel
%         blobImage(BB(i, 2):BB(i, 2) + BB(i, 4) - 1, BB(i, 1):BB(i, 1) + BB(i, 3) - 1, 3) = ...
%             uint8(mask) * 255;  % Blue channel
%     end
% 
%     imshowpair(frame, blobImage); % a mixed image of the original video frame and the identified blob frame
%     axis image;
%     drawnow();

    % Ensure that the size of each frame is consistent with the initial frame.
%     frameForVideo = getframe(gcf);
%     frameForVideo = imresize(frameForVideo.cdata, [initialFrameSize(1), initialFrameSize(2)]); 
%     writeVideo(outputVideo, frameForVideo); %% 

    data{counter, 1} = [double(Areas), double(CTs), double(BB), double(MALs), double(MiALs), double(Orients), double(Ecens)];
    DT = data{counter,1};
    counter = counter + 1
% data is a cell array of size counter(frame number)x1, where each element contains information about a blob.
% Areas are the areas of the blobs.
% CT represents the central coordinates of the blobs (x and y).
% BB is the bounding box of a blob, usually a rectangle, containing x, y, width, and height.
% MALs and MiALs are the maximum and minimum axis lengths of the blobs, respectively.
% Orients is the orientation of the blobs, that is, the angle of the long axis relative to the horizontal line.
% Ecens represents the eccentricity of each blob, indicating how elliptical the shape is.
end
% close(outputVideo);

%% Calculate the preference index（PI）
totalInZ1 = 0;
totalInZ2 = 0;
PISum = 0;
frameCount = 0;

for i = 1:size(data, 1)
    currentData = data{i, 1};
    
    % Use the inpolygon function to check which coordinates are within the z1 area.
    inZ1 = inpolygon(currentData(:, 2), currentData(:, 3), z1(:, 1), z1(:, 2));
    inZ2 = inpolygon(currentData(:, 2), currentData(:, 3), z2(:, 1), z2(:, 2));
    
    totalInZ1 = totalInZ1 + sum(inZ1);
    totalInZ2 = totalInZ2 + sum(inZ2);
    
    if (sum(inZ1) + sum(inZ2)) > 0
        PIPerFrame = (sum(inZ2) - sum(inZ1)) / (sum(inZ1) + sum(inZ2));
        PISum = PISum + PIPerFrame;
        frameCount = frameCount + 1; 
    else
        fprintf('Frame %d: No blobs in Z1 or Z2\n', i);
    end
end
    if frameCount > 0
      PI = PISum / frameCount;
        fprintf('PI = %.f\n', PI);
    else
      fprintf('No valid frames with blobs in Z1 or Z2\n');
    end

    masterData.vidName = vidName
    masterData.data = data
    masterData.PI = PI

saveName = sprintf('%s_%d.mat', erase(vidName, '.mp4'), start_time_min + 1);
save(saveName, 'masterData');
end