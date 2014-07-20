function out = squarePad(in, dim, replBool)
    switch nargin
        case 1
            dim = max(size(in));
            replBool = false;
        case 2
            replBool = false;
    end
    
    
    
    
    xIn = size(in,2);
    yIn = size(in,1);
    inPad = floor([abs(yIn-dim) abs(xIn-dim)]/2);
    
    if replBool == false
        out = padarray(in, [inPad(1) inPad(2)], 'replicate');
    else
        out = padarray(in, [inPad(1) inPad(2)]);
    end
end