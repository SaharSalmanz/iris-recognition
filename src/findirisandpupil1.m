function [ci,ri,cp,rp]=findirisandpupil1(image)
rgb = imread(image);
 figure,imshow(rgb)
d = imdistline;
delete(d);
% gray_image = rgb2gray(rgb);
gray_image=rgb;
imshow(gray_image);
hold on
%find pupil center && radius
[cp, rp,~] = imfindcircles(rgb,[40 50],'ObjectPolarity','dark','Sensitivity',0.96,'EdgeThreshold',0.05);
% find iris center && radius
[ci, ri,~] = imfindcircles(rgb,[100 115],'ObjectPolarity','dark','Sensitivity',0.988,'EdgeThreshold',0.01);
%find circle with minimum distance of x_pupil && x_iris
distance=[300 300 300 300 300 300];
for i=1:size(ci,1)
distance(i)=abs(cp(1,1)-ci(i,1));
end
c2=[0,0];
n=find(distance==min(distance));
c2(1)=ci(n,1);
c2(2)=ci(n,2);
ci=c2;
ri=ri(n);
% show circles
h1 = viscircles(cp, rp);
h2 = viscircles(ci, ri);
end
