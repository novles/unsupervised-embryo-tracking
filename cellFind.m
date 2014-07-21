function loc = cellFind(in)

    imFFT = fftshift(fft2(in));
    
    imThr = im2bw(normalize((abs(imFFT))),1e-3);
    figure,imshow(imThr);
    
    xSize = size(in,2);
    ySize = size(in,1);
    
    
    xLP_start = xSize;
    xLP_end = 0;
    yLP_start = ySize;
    yLP_end = 0;
    
    for i = 1:xSize
        top = 0;
        bottom = 0;
        left = 0;
        right = 0;
        for j = 1:ySize
            
            if imThr(j,i) == 1;
                top = j;
                if bottom == 0
                    bottom = j;
                end
            end
            
            if imThr(i,j) == 1;
                right = j;
                if left == 0
                    left = j;
                end
            end 
            
        end
        
        if bottom ~= 0
            xLP_start = min(left,xLP_start);
            xLP_end = max(right,xLP_end);
        end
        
        if left ~= 0
            yLP_start = min(bottom,yLP_start);
            yLP_end = max(top,yLP_end);
        end
    end
    
    
    
    %FFT_(:,:) = FFT;
    
    loc = [xLP_start xLP_end yLP_start yLP_end];

end