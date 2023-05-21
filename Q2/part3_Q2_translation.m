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
for t = 1:1:10
    omegax = 0;
    omegay = 0;
    omegaz = 0;
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
    General_rotation_matrix = Xrotationmatrix*Yrotationmatrix*Zrotationmatrix;
    %% transition added - rotation + translation
    Tx = 500*t;
    Ty = 0;
    Tz = 0;
    TranslationVector = [Tx;Ty;Tz];
    
    RT_manual = horzcat(General_rotation_matrix, TranslationVector);
    %% creat image - get back to the image coordinate
    Coordinate_back_img = zeros(size(rgbImage,1),size(rgbImage,2),3);
    for i = 1:1: size(rgbImage,1)
        for j = 1:1: size(rgbImage,2)
            Coordinate_back_img(i,j,1:3) = ((Ic*Ec(1:3,1:3))*RT_manual)*([X(i,j);Y(i,j);Z(i,j);1]);
        end
    end
    a = Coordinate_back_img(:,:,1:3)./Coordinate_back_img(:,:,3);

    a = single(a);
    a1 =a(:,:,1);
    a2 =a(:,:,2);
    a3 =a(:,:,3);

    a1 = single(round(a1));
    a2 = single(round(a2));
    
    rgbImage = imread(rgbImageFileName);
    c = 0;
    for i = 1:1:size(rgbImage,1)
        for j = 1:1:size(rgbImage,2)
            rgbImage(i,j,:) = [0,0,0];
        end
    end
    rgbImage1 = imread(rgbImageFileName);
    for i = 1:1:size(rgbImage,1)
        for j = 1:1:size(rgbImage,2)
            if ((a1(i,j) <= 480) && (a1(i,j) >=1) && (a2(i,j)<= 640) && (a2(i,j) >=1) )
                rgbImage(a1(i,j),a2(i,j),:) = rgbImage1(i,j,:);
                c = c+1;
            end 
        end
    end

    imshow(rgbImage);
    F(t) = getframe;
    tempF = F(t);
    sizeF(t,:,:) = size(tempF.cdata);
    pause(.01);
end

video = VideoWriter([num2str(imageNumber) '_Tx_' num2str(Tx) '_Ty_' num2str(Ty) '_Tz_' num2str(Tz) '_RotationXYZ_' num2str(omegax*t) '_' num2str(omegay*t) '_' num2str(omegaz*t) '.avi']);
%open the file for writing
open(video);
for ii = 1:10
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