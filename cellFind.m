function loc = cellFind(in)

    imFFT = fftshift(fft2(in));
    
    imThr = im2bw(normalize((abs(imFFT))),1e-3);
    figure,imshow(imThr);
    
    
    
    %FFT_(:,:) = FFT;
    
    loc = [xLP_start xLP_end yLP_start yLP_end];

end