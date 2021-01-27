 function [hd] = matching(template1, mask1, template2, mask2, scales)
% nonzero element is converted to 1  and zeros are converted to 0 
scales=1;
template1 = logical(template1);
mask1 = logical(mask1);
template2 = logical(template2);
mask2 = logical(mask2);
hd = 1;
% shift template left and right=rotation of iris region
for shifts=-8:8
    
    template1new = shiftbits1(template1, shifts,scales);
    mask1new = shiftbits1(mask1, shifts,scales);
    
    % Calculate HD FOR bits than mask=0
    %HD=SUM(template1 xor template2 and mask1 and mask2)/N(Without 1)
    mask = mask1new | mask2;
    %mask is 2D matrix
    nummaskbits = sum(sum(mask == 1));
   % N(Without 1)
    totalbits = (size(template1new,1)*size(template1new,2)) - nummaskbits;
    %SUM(template1 xor template2 and mask1 and mask2)
    C = xor(template1new,template2);
    
    C = C & ~mask;
    bitsdiff = sum(sum(C==1));
    
    if totalbits ~= 0
        
     
        hd1 = bitsdiff / totalbits;
        
        %the lowest Hamming distance
        if  hd1 < hd
            
            hd = hd1;
            
        end
        
        
    end
    
end





