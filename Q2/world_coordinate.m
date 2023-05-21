%% if you want to run this code by its own, you need to add: 

% imageNumber = 1

% imgaeNumber could accept these values: 1 - 2 - 3
%% the main code 
% add the corresponding folder name to the path 
addpath([num2str(imageNumber) '\']);

% You can remove any inputs you think you might not need for this part:
rgbImageFileName = strcat('rgbImage_',num2str(imageNumber),'.jpg');
depthImageFileName = strcat('depthImage_',num2str(imageNumber),'.png');
extrinsicFileName = strcat('extrinsic_',num2str(imageNumber),'.txt');
intrinsicsFileName = strcat('intrinsics_',num2str(imageNumber),'.txt');

% load png data (RGB data + Depth information)
rgbImage = imread(rgbImageFileName);
depthImage = imread(depthImageFileName);

% show loaded data
figure;subplot(1,2,1); imshow(rgbImage); title('RGB image');
subplot(1,2,2); imshow(depthImage); title('Depth image');

% change the type of the depth map
depthImage = double(depthImage);
rgbImage = double(rgbImage);

% load the intrinsic and the extrinsic matricesintrinsicsFileName
Ec = load(extrinsicFileName)
Ic = load(intrinsicsFileName)
%% find the world coordinate 
WorldCoordinate = zeros(size(rgbImage,1),size(rgbImage,2),3,1);
CameraCoordinate = zeros(size(rgbImage,1),size(rgbImage,2),3,1);

for xpixel = 1:1:size(rgbImage,1)
    for ypixel = 1:1:size(rgbImage,2)

        % find world equation
        pixelCoordinate = depthImage(xpixel,ypixel)*double([xpixel;ypixel;1]);
        CameraCoordinate = inv(Ic)*pixelCoordinate;
        WorldCoordinate(xpixel,ypixel,:) = inv(Ec(:,1:3))*CameraCoordinate;

        % define world coordinate: X - Y - Z
        X(xpixel,ypixel) = WorldCoordinate(xpixel,ypixel,1);
        Y(xpixel,ypixel) = WorldCoordinate(xpixel,ypixel,2);
        Z(xpixel,ypixel) = WorldCoordinate(xpixel,ypixel,3);
       
    end
end

% plot in 3D - world coordinate
figure
rgbImage = imread(rgbImageFileName);
J = (imresize(rgbImage,size(X)));
pcshow([X(:),Y(:),Z(:)],reshape(J,[],3));
%% get back to the image coordinate
Coordinate_back_img = zeros(size(rgbImage,1),size(rgbImage,2),3);
for i = 1:1: size(rgbImage,1)
    for j = 1:1: size(rgbImage,2)
        % calculate image coordinate
        Coordinate_back_img(i,j,1:3) = (Ic*Ec)*transpose([X(i,j),Y(i,j),Z(i,j),1]);
        Coordinate_back_img(i,j,1:3) = Coordinate_back_img(i,j,1:3)./depthImage(i,j);
    end
end