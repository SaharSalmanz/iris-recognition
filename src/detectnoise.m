function [imagewithnoise,ci,ri,cp,rp]=detectnoise(eyeimage)
g=imread(eyeimage);
%g=rgb2gray(i);
%[ci1,cp1,~]=thresh(g,50,120)
%ci=[xi yi ri]    cp=[xp yp rp]
[ci,ri,cp,rp]=findirisandpupil1(eyeimage);
%image iris show a rectangular containing the iris
%imageiris = g( ci(1)-ci(3):ci(1)+ci(3),ci(2)-ci(3):ci(2)+ci(3));
imageiris = g(round(ci(2)-ri):round(ci(2)+ri),round(ci(1)-ri):round(ci(1)+ri));
%finding the top eyelid
%crop the upper half of imageiris
croppedup=imageiris(1:round(0.5*(size(imageiris,1))),:);
%figure,imshow(imageiris);
%applying canny for using linear hough transform
%%%%%%f=edge(croppedup,'canny');
f=croppedup;
%linear hough transform
[H2,T2,R2] = hough(f);
%detecting the peaks in hough space (which are the lines in x-y coordinate)
P2  = houghpeaks(H2,1,'threshold',ceil(0.8*max(H2(:))));
%transforming the peaks into line coordinates
lines2 = houghlines(f,T2,R2,P2,'minlength',40);
%figure, imshow(croppedup), hold on
%if it detected any lines then ...
 if size(lines2,1) > 0
    %starting point and ending point of the line
    wz = [lines2(1).point1; lines2(1).point2];
    %ploting the line with the points on the croppedup image
    %plot(wz(:,1),wz(:,2),'LineWidth',1);
    hold off;
    imagewithnoise=double(g);
    %storing the x coordinates of the start and end point in xl
    xl= wz(:,1);
    %storing the y coordinates of the start and end point in yl
    yl= wz(:,2);
    %transfering the coordinates inorder to fit in the original image
    yl = (yl) + (ci(2)-ri)-1;
    xl = (xl) + (ci(1)-ri)-1;
    yla = round(0.5*(max(yl)+ min(yl)));
    y2 = 1:yla;
    x1= xl(1):xl(2);
    %replacing the data with x coordinates between the start and end point
    %and more than the mean of their y coordinates with NaN (omitting the
    %noise caused by eyelids)
    %sub2ind finds the linear equivalent for the row and column of matrix elements 
    ind3 = sub2ind(size(g),round(yl),round(xl));
    imagewithnoise(ind3) = NaN;
    imagewithnoise(round(y2),round(x1)) = NaN;
    
end
%figure, imshow(imagewithnoise);
%crop the lower half of the imageiris
f=round(0.5*(size(imageiris,1)))+30;
q=(size(imageiris,1));
cropeddn=imageiris(f:q,:);
%applying canny for using linear hough transform
%%%%%%%%%%%%%%%%e=edge(cropeddn,'canny');
e=cropeddn;
%linear hough transform
[H1,T1,R1] = hough(e);
%detecting the peaks in hough space (which are the lines in x-y coordinate)
P1  = houghpeaks(H1,1,'threshold',ceil(0.1*max(H1(:))));
%transforming the peaks into line coordinates
lines1 = houghlines(e,T1,R1,P1,'minlength',40);
%figure, imshow(cropeddn), hold on
%if it detected any lines then ...
if size(lines1,1) > 0
    %starting point and ending point of the line
    xy = [lines1(1).point1; lines1(1).point2];
    %ploting the line with the points on the croppedup image
    %plot(xy(:,1),xy(:,2),'LineWidth',1);
    hold off;
    %storing the x coordinates of the start and end point in xl
    xl= xy(:,1);
    %storing the y coordinates of the start and end point in yl
    yl= xy(:,2);
    %transfering the coordinates inorder to fit in the original image
    yl = (yl) + ci(2)-ri+f-2;
    xl = (xl) + (ci(1)-ri)-2;
    yla = max(yl);
    y2 = yla:size(g,1);
    x1= xl(1):xl(2);
    %replacing the data with x coordinates between the start and end point
    %and less than the minimum of their y coordinates with NaN (omitting the
    %noise caused by eyelids)
    %sub2ind finds the linear equivalent for the row and column of matrix elements
    ind2 = sub2ind(size(g),round(yl),round(xl));
    imagewithnoise(ind2) = NaN;
    imagewithnoise(round(y2),round(x1)) = NaN;
end
%detecting the noise caused by eyelashes as they are darker than the other
%parts and replace the data with NaN
ref = g < 100; 
coords = find(ref==1);
imagewithnoise(coords) = NaN;
%ref1=g>230;
%coords1=find(ref1==1);
%imagewithnoise(coords1)=NaN;
%p = find(isnan(imagewithnoise));
%figure,imshow(imagewithnoise)
imagewithnoise=imagewithnoise./255;
%h=find(isnan(imagewithnoise));
figure, imshow(imagewithnoise);
end