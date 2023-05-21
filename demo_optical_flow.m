function [Vx,Vy,lenghtN] = demo_optical_flow(folder_name,frame_number_1,frame_number_2,lenghtN,sigma)
    % This is a demo to show the optical flow in quiver plot

    if(nargin == 0)
        folder_name = 'Backyard';
        frame_number_1 = 7;
        frame_number_2 = frame_number_1 + 1;
    elseif(nargin == 1)
        frame_number_1 = 7;
        frame_number_2 = frame_number_1 + 1;
    elseif(nargin ==2)
        frame_number_2 = frame_number_1 + 1;
    end
    
    addpath(folder_name);
    
    frame_1 = read_image(folder_name,frame_number_1);
    frame_2 = read_image(folder_name,frame_number_2);

    % this is the size of neighborhood when calculating Second Moment mastrix 
    lenghtN = lenghtN;
    
    % let us call the function that calculate velocity vectors 
    [Vx,Vy] = compute_LK_optical_flow(frame_1,frame_2,lenghtN,sigma);

    % ploting the vectors by using the plotflow function
    set(gcf,'WindowState','fullscreen')
    if (frame_number_1 < 10)
        imshow(fullfile(folder_name,strcat('frame0',num2str(frame_number_1),'.png')));
    end
    if (frame_number_1 >= 10)
        imshow(fullfile(folder_name,strcat('frame',num2str(frame_number_1),'.png')));
    end
    axis image
    hold on
    plotflow(Vx,Vy);
    title('Quiver plot');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function used for ploting velocity vectors
function plotflow(Vx,Vy)
    s = size(Vx);
    % You can change this if you want a finer grid 
    step = max(s)/50; 
    [X, Y] = meshgrid(1:step:s(2), s(1):-step:1);
    u = interp2(Vx, X, Y);
    v = interp2(Vy, X, Y);
    quiver(X,Y, u, v, 1, 'cyan', 'LineWidth', 1);
    axis image;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simple function that just read an png file 
function I = read_image(folder_name,index)
    I = imread(fullfile(folder_name,strcat('image_smoothed_',num2str(index),'.png')));
end