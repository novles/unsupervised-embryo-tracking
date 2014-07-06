function gb=gabor_patch(sigma,theta,lambda,psi,gamma)
% function gb=gabor_patch(sigma,theta,lambda,psi,gamma)
%
% I stole this from wikipedia.  The explanation is a little funky on there.
%
% sigma = Standard deviation of the gaussian envelope.  The gabor patch has
%         a support of three standard deviations on each side, so the image
%         should be about six times this number, less a bit due to
%         rotation.
% theta = Rotation in radians
% lambda =  wavelength of the sinusoidal component of the patch (the 
%           alternating bright and dark regions)
% psi = Phase offset of the sinusoidal component
% gamma = Spatial aspect ratio (ratio of x axis to y axis)
%
% For a regular gabor patch:
% gb = gabor_patch(25, 0, 25, 0, 1)
%
% 45 degree rotation:
% gb = gabor_patch(25, pi/4, 25, 0, 1)
 
sigma_x = sigma;
sigma_y = sigma/gamma;
 
% Bounding box
nstds = 3;
xmax = max(abs(nstds*sigma_x*cos(theta)),abs(nstds*sigma_y*sin(theta)));
xmax = ceil(max(1,xmax));
ymax = max(abs(nstds*sigma_x*sin(theta)),abs(nstds*sigma_y*cos(theta)));
ymax = ceil(max(1,ymax));
xmin = -xmax; ymin = -ymax;
[x,y] = meshgrid(xmin:xmax,ymin:ymax);
 
% Rotation 
x_theta=x*cos(theta)+y*sin(theta);
y_theta=-x*sin(theta)+y*cos(theta);
 
gb= exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi);