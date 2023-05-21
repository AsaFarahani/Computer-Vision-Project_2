clc
close all
clear all
%% choose a dataset that you want to work with 
imageNumber = 3 ;
%% load the matlab code which find the world coordinate 
world_coordinate;
close all
%% rotation
% define omega
figure
for t = 1:1:30
    omegax = 0;
    omegay = 0;
    omegaz =1;
    % define rotation matrices
    Xrotationmatrix = [1,0,0;...
        0,cosd(omegax*t), -sind(omegax*t), ;...
        0, sind(omegax*t),cosd(omegax*t);];
    Yrotationmatrix = [cosd(omegay*t),0,sind(omegay*t);...
          0,1,0;...
        -sind(omegay*t), 0,cosd(omegay*t);];
    Zrotationmatrix = [cosd(omegaz*t), -sind(omegaz*t),0;...
        sind(omegaz*t),cosd(omegaz*t), 0;...
        0,0,1;];
    General_rotation_matrix  = Xrotationmatrix*Yrotationmatrix*Zrotationmatrix;
    
    %% transition added - rotation + translation
    Tx = 0;
    Ty = 500*t;
    Tz = 0;
    TranslationVector = [Tx;Ty;Tz];
    rotated = Ec(1:3,1:3)*General_rotation_matrix;
    RT_new = horzcat(rotated, TranslationVector);
    %% creat image - get back to the image coordinate
    Coordinate_back_img = zeros(size(rgbImage,1),size(rgbImage,2),3);
    for i = 1:1: size(rgbImage,1)
        for j = 1:1: size(rgbImage,2)
            Coordinate_back_img(i,j,1:3) = ((Ic)*RT_new)*([X(i,j);Y(i,j);Z(i,j);1]);
        end
    end
    % make  w  = 1 
    a = Coordinate_back_img(:,:,1:3)./Coordinate_back_img(:,:,3);

    %  find x-pixel and y-pixel
    a = single(a);
    a1 =a(:,:,1);
    a2 =a(:,:,2);
    a3 =a(:,:,3);

    a1 = single(round(a1));
    a2 = single(round(a2));

    % camera coordinate reconstruction would give us w 
    Coordinate_camera = zeros(size(rgbImage,1),size(rgbImage,2),3);
    for i = 1:1: size(rgbImage,1)
        for j = 1:1: size(rgbImage,2)
            Coordinate_camera(i,j,1:3) = (RT_new)*transpose([X(i,j),Y(i,j),Z(i,j),1]);
        end
    end
    Xcam = Coordinate_camera(:,:,1);
    Ycam = Coordinate_camera(:,:,2);
    Zcam = Coordinate_camera(:,:,3);


    depthImage1 = imread(depthImageFileName);
    depthImage1 = zeros(size(depthImage1,1),size(depthImage1,2));

    for i = 1:1:size(depthImage1,1)
        for j = 1:1:size(depthImage1,2)
            if ((a1(i,j) <= 480) && (a1(i,j) >=1) && (a2(i,j)<= 640) && (a2(i,j) >=1) )
                depthImage1(a1(i,j),a2(i,j),:) = Coordinate_back_img(i,j,3);
            end 
        end
    end

    imshow(depthImage1,[0,50000]);
    F(t) = getframe;
    tempF = F(t);
    sizeF(t,:,:) = size(tempF.cdata);
    pause(.01);
end

video = VideoWriter(['D' num2str(imageNumber) '_Tx_' num2str(Tx) '_Ty_' num2str(Ty) '_Tz_' num2str(Tz) '_RotationXYZ_' num2str(omegax*t) '_' num2str(omegay*t) '_' num2str(omegaz*t) '.avi']);
%open the file for writing
open(video);
for ii = 1:30
  a = sizeF(:,:,1);
  b = sizeF(:,:,2);
  m = F(ii)
  m = m.cdata;
  I=  m(1:1:min(a(a>0)),1:1:min(b(b>0)),:);
  for i = 1:1:12
     %write the image to file
     writeVideo(video,I);
  end
end

%close the file
close(video); 
