clc
close all
clear all
%% Try the code with images in a specific folder 
% define the dataset
folder_name =  'Mequon';

% you may change parameters here 
% parametes include: spatial smoothing - temporal smoothing - neighborhood size
smoothing_time = 0.1;
Neighborhoodsize = 25;
Sigma_spatial = 1; 

% do temporal smoothing 
smooth_frames(folder_name,smoothing_time,7,14)

% ploting the results 
for i = 7:13
    demo_optical_flow(folder_name,i,i+1,Neighborhoodsize,Sigma_spatial);
    fprintf('Frame: %d\n',i);
    F(i) = getframe;
    tempF = F(i);
    sizeF(i,:,:) = size(tempF.cdata);
    pause(.02);
end
imshow([folder_name '/frame14.png']);
F(14) = getframe;
%% save the results as a video file
%create the video object
video = VideoWriter([folder_name '_simga_spatial_' num2str(Sigma_spatial) '_sigma_temporal_' num2str(smoothing_time) '_Neighborhood_size_' num2str(Neighborhoodsize) '.avi']);
%open the file for writing
open(video);
for ii = 7:1:14
  a = sizeF(:,:,1);
  b = sizeF(:,:,2);
  m = F(ii)
  m = m.cdata;
  I=  m(1:1:min(a(a>0)),1:1:min(b(b>0)),:);
  for i = 1:1:24
     %write the image to file
     writeVideo(video,I);
  end
end

%close the file
close(video); 