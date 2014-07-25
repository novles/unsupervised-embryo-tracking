function out = makeCell(cellImage, cellParent, xLoc, yLoc, zLoc, length, width, angle)


	switch nargin
		case 5
			length = parent.length = nthroot(3)*(parent.l(1)+parent.w(1))/2;
                % Since the ellipsoid shape is reasonably uniform, and that
                % the volume reduction due to splitting is a scalar approximately
                % equal to nthroot(2,3), as these are 3D objects. Unknown,
                % we may assume spherical.
            width = length;
            angle = 0;
    end


	f1	= 	'image';		v1	= cellImage;			% the full size, uncropped image being processed at 
														% the current timestep.
	f5	=	'time';			v5	= cellParent.endTime;					% The current timestep.
	f2	=	'parent';		v2	= cellParent;			% a link to the parent cell
	f3	=	'startTime';	v3	= cellParent.endTime;	% Time of split completion.
	f4	=	'endTime';		v4	= v3;					% this will store the time at which the cell splits
														% and the "child" cells are filled.
	f6	=	'x';			v6	= xLoc;					% centre coordinates of the cell being observed.
	f7	=	'y';			v7	= yLoc;					% These are all arrays containing all X/Y/Z
														% coordinates
	f8	=	'z';			v8	= zLoc;					% at a given timestep, indexed by 'time'.
	
	f9	=	'dx';			v9	= 0;					% current linear velocity vectors in pixels per 
	f10	=	'dy';			v10	= 0;					% timestep.
	f11	=	'dz';			v11	= 0;
	f12	= 	'l';			v12	= length;				% The linear length and width of the ellipsoid
	f13	=	'w';			v13 = width;				% representing this cell. These are also arrays.
	f14	=	'theta';		v14 = angle;				% The angle at which the major and minor axis
														% of this ellipsoid is offset.
	f15	=	'dl';			v15 = 0;					% The current change in height/width of the
	f16	=	'dw';			v16 = 0;					% ellipsoid
	f17	=	'dTheta';		v17 = 0;					% current rotation
	f18	=	'child1';		v18 = [];					% The two child cells resulting from this cell's split.
	f19	=	'child2';		v19 = [];					% These remain null util the cell does split.
	
	
	out = struct(	f1, v1, f2, v2, f3, v3, f4, v4, f5, v5, f6, v6, f7, v7, f8, v8, f9, v9, f10, v10, f11, v11, f12, v12, f13, v13, f14, v14, f15, v15, f16, v16, f17, v17, f18, v18, f19, v19);
    


% struct cellStruct // effective C struct.
% {
% 
% 	uint8_t image[j][i];
% 	uint8_t time;
% 	uint8_t startTime;
% 	uint8_t endTime;
% 	uint8_t x,y,z;
% 	uint8_t dx,dy,dz;
% 	float l,w,theta;
% 	float dl,dw,dTheta;
% 	struct cellStruct *parent,*child1, *child2;
% }
% 

end