function [Vx,Vy] = compute_LK_optical_flow(frame_1,frame_2,lenghtN,sigma)
    % lenghtN = what is the lenght of the neighborhood square?
    % You have to implement the Lucas Kanade algorithm to compute the
    % frame to frame motion field estimates. 
    % frame_1 and frame_2 are two gray frames where you are given as inputs to 
    % this function and you are required to compute the motion field (Vx,Vy)
    % based upon them. 
    % -----------------------------------------------------------------------%
    % get the images which are already experienced the temporal smoothing
    % the frames are already gone through temporal smoothing - get through
    % inputz
    frame_1 = double(frame_1) /double(max(frame_1(:)));
    frame_2 = double(frame_2) /double(max(frame_2(:)));

    % smooth the images - spatial smoothing - make differentation possible
     Frame_1_Smoothed = imgaussfilt(frame_1,sigma);
     Frame_2_Smoothed = imgaussfilt(frame_2,sigma);
    
    % calculate difference of two sucsessive frames
    Diff_of_Frames = Frame_1_Smoothed - Frame_2_Smoothed;

    % compute gradients
    [Gx,Gy] = gradient(Frame_1_Smoothed);
    
    % compute diff_frame * Gx and also compute diff_frame*Gy
    diff_Gx = Diff_of_Frames .* Gx;
    diff_Gy = Diff_of_Frames .* Gy;
   
    
    % compute structure tensor
    Structural_Tensor= zeros(size(Frame_1_Smoothed,1),size(Frame_1_Smoothed,2),2,2);
    for i = 1:1: size(Frame_1_Smoothed,1)
        for j = 1:1:size(Frame_1_Smoothed,2)
            Structural_Tensor(i,j,:,:) = [Gx(i,j)^2,Gx(i,j)*Gy(i,j);Gx(i,j)*Gy(i,j), Gy(i,j)^2];
        end
    end
    
    % generate second moment matrix
    Second_Momrnt_Matrix = zeros(size(Frame_1_Smoothed,1),size(Frame_1_Smoothed,2),2,2);
    Avg_filter = ones(lenghtN);
    for i = 1:1:2
        for j = 1:1:2
            Second_Momrnt_Matrix(:,:,i,j) = conv2(Structural_Tensor(:,:,i,j),Avg_filter,'same');
        end
    end
    
    % calculate sum of product of difference of images by gradient
    sum_diff_Gx = conv2(diff_Gx,Avg_filter,'same');
    sum_diff_Gy = conv2(diff_Gy,Avg_filter,'same');
    
    % define Vx, Vy
    velocity = zeros(size(Frame_1_Smoothed,1),size(Frame_1_Smoothed,2),2);
    for i = 1:1: size(Frame_1_Smoothed,1)
        for j = 1:1:size(Frame_1_Smoothed,2)
            for n = 1:1:2
                for m = 1:1:2
                    a(n,m)= Second_Momrnt_Matrix(i,j,n,m);
                end
            end
            if (1)
                velocity(i,j,:) = pinv(a) * ([sum_diff_Gx(i,j);sum_diff_Gy(i,j)]);
            end
        end
    end
    Vx =  velocity(:,:,1);
    Vy =  velocity(:,:,2);
    
end