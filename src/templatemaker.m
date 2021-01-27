function [template3d,mask3d]= templatemaker (img)
template3d=zeros(38,480,4);
mask3d=zeros(38,480,4);
for i=1:4
    j=int2str(i);
    s1='.bmp';
    s=strcat(j,s1);
    [img,normnoise]=normalise(s,40,240);
    [template, mask] = encode(img,normnoise, 1, 18,1, 0.5);
    template3d(:,:,i)=template;
    mask3d(:,:,i)=mask;
end
save('gentemp','template3d','mask3d')
