function [normimage,normnoise]=normalise(image,radialresolution,angularresolution)
%radial resolution is the number of points with the points on the iris and
%pupil boundaries
%angular resolution is the number of lines that divide the circle including
%theta=0

[imagewithnoise,ci,ri,cp,rp]=detectnoise(image);
normimage=imagewithnoise;

x_iris=ci(1);
y_iris=ci(2);
r_iris=ri;
x_pupil=cp(1);
y_pupil=cp(2);
r_pupil=rp;
%radialresolution=360;
%angularresolution=360;
ox=x_pupil-x_iris;
oy=y_pupil-y_iris;
a=ox^2+oy^2;
% note that theta is a 1*angularresolution matrix
theta=0:2*pi/(angularresolution-1):2*pi;
if ox <= 0
    sgn = -1;
elseif ox > 0
    sgn = 1;
end

if ox==0 && oy > 0 
    sgn = 1;
end

theta = double(theta);
%ox can not be 0 because (oy/ox) would be NaN
if ox == 0
    phi = pi/2;
    else
    phi = atan(oy/ox);
end
%un balaeia lazem nist mn negah kardam khodesh javab mide vase atan
b=cos(pi-phi-theta);
b=abs(b);
%since b is a 1*angularresolution matrix we should make (a) a 1*angularresolution matrix as
%well
a=ones(1,angularresolution)*a;
r= sqrt(a).*b+sqrt(abs(a.*b.^2-a-r_iris^2));

%note that r is the distance of the points in iris region with respect to
%the centre of the pupil so for dividing the distance into
%radialresolution+1 parts we define the new r as:
r = r - r_pupil; 

%r_theta_space (radial resolution*angular resolution) matrix: each row is a discrete set of points with a specific r that
%rotates from 0 to 2pi creating a  circle
%as we change the rows we change r in iris region
%creating a matrix with the same r in each row and n=radial resolution
%columns
r1=ones(radialresolution,1)*r;
r_theta_space=r1.*(ones(angularresolution,1)*[0:1/(radialresolution-1):1])';
r_theta_space = r_theta_space + r_pupil;

%exclude the borders of pupil_iris and iris_scelra
r_theta_space(1,:)=NaN;
r_theta_space(radialresolution,:)=NaN;
r_theta_space  = r_theta_space(2:(radialresolution-1), :);

%converting polar to cartesian
x1 = ones(radialresolution-2,1)*cos(theta);
y1 = ones(radialresolution-2,1)*sin(theta);

xo = r_theta_space.*x1;    
yo = r_theta_space.*y1;
%note that xo and yo are with respect to centre of pupil
I=imread(image);
%figure,imshow(I)
hold on
%plot(xo,yo,'*');
hold on;

xo = x_pupil+xo;
yo = y_pupil-yo; %chera menha?

hold on;
%plot(xo,yo,'.');
%imagewithnoise = insertShape(imagewithnoise, 'circle', [xo,yo,2*ones(size(yo(:)))],'Color','r');
% extract intensity values into the normalised polar representation through
% interpolation 
%ba meshgrid miad ye matris n*m misaze ke n tedad deraye hae bordare
%1:size(image,1) e ke hamun tedad moalefe haye x e tasviremune va m tedad
%molafehaye (1:size(image,2)) e yani moalefe hae y tasivr (baraks
%nanveshtam tabash injurie) pas miad ye matris ba deraye hae 1 misaze ke
%abadesh mesle abade tasvire aslimune hala ma ye tedad az in noghato tu
%ghesmate bala nemune bardari kardim ba interp2 miad darunyabi mikone beine
%noghat (inja daunyabie khati)va noghate dige tasviro hads mizane. be helpe
%matlab morajee shavad
%[x,y] = meshgrid(1:size(image,2),1:size(image,1))  
%polar_array = interp2(x,y,image,xo,yo)


normimage = reshape(normimage(sub2ind(size(normimage),round(yo),round(xo))),size(r_theta_space,1),size(r_theta_space,2));
normnoise = zeros(size(normimage));
coords = find(isnan(normimage));
normnoise(coords) = 1;
%image=I(round(xo),round(yo));
%figure(10), imshow(normimage);
%pas ta inja mokhtasate un dayere hae ke bayad bardare az enabiaro darim
%(fek konam)

coords = find(isnan(normimage));
imagewithnoise1 = normimage;
imagewithnoise1(coords) = 0.5;
avg = sum(sum(imagewithnoise1)) / (size(normimage,1)*size(normimage,2));
normimage(coords) = avg;
%figure(11), imshow(normimage);

end




