% function creates circular brick wall filter. the dimensions create an
% image 2*m by 2*n

function out = lpGen(cutoff, m, n)
    
    switch nargin
        case 1
            m = cutoff*2 + 4;
            n = cutoff*2 + 4;
        case 2
            n = m;
    end
    
    
    imPad = floor([m, n]/2)*2;
    add = max(mod(m,2)+1, mod(n,2)+1);
    disk = fspecial('disk',cutoff+add);
    disk = imresize(disk, 2*cutoff/(2*cutoff+add));
    
    filt = padarray(disk, ceil((imPad-size(disk))/2), 0, 'both');
    
    out = filt;

end