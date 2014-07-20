
function cutout = cellCrop(input, xOffset, yOffset, r, box)


%r = 100 % Magic. The cells all seem to be ~this-ish????

%box = 1.75;

xCutout = (max([1 xOffset-r*box]):min([(xOffset + r*box - 1) xSize]));
yCutout = (max([1 yOffset-r*box]):min([(yOffset + r*box - 1) ySize]));

cutout = input(xCutout,yCutout);

