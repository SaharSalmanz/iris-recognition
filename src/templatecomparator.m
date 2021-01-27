function [o,q,output]=templatecomparator(mask3d,template3d,eyeimage,img)
load('gentemp','template3d')
load('gentemp','mask3d')
[img,normnoise]=normalise(eyeimage,40,240);
 [templatetest, masktest] = encode(img,normnoise, 1, 18,1, 0.5);
hd1=1;
for i=1:4
    templatebank=template3d(:,:,i);
    maskbank=mask3d(:,:,i);
    [hd] = matching(templatetest, masktest, templatebank, maskbank, 1);
    if hd<hd1
        hd1=hd;
        k=i;
    end
end

     if hd1<0.35
         o='matching sample';
         q=int2str(k);
         output=strcat(o,q);
     else
         output='no matching sample';
     end