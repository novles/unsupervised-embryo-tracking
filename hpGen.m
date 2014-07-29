function out = hpGen(cutoff, dimX, dimY)

    switch nargin
        case 1
            dimX = cutoff*2 + 4;
            dimY = cutoff*2 + 4;
        case 2
            dimY = dimX;
    end
    
    out = 1-lpGen(cutoff, dimX, dimY);

end