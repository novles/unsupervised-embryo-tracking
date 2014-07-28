% function applies a circular brick wall filter to an input image in the
% frequency domain. Filter cutoff is limited to the smallest dimension of
% the image.


function out = imLP( in, cutoff ) 
    
    
    imSize = [size(in,1) size(in,2)];

    if cutoff >= min(imSize)
        cutoff = ceil(min(imSize)/2)-1;
    end
    
    filt = zeros(imSize(1),imSize(2));
    
    filt((imSize(1)-cutoff*2)/2+1:(imSize(1)+cutoff*2)/2,(imSize(1)-cutoff*2)/2+1:(imSize(1)+cutoff*2)/2) = imresize(fspecial('disk',cutoff),(cutoff*2)/(cutoff*2+1));
    filt = im2bw(normalize(filt),.1);
    
    inFFT = (fftshift(filt).*fft2(in));

    out = abs(ifft2(inFFT));

end

