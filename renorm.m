function y = renorm(x, low, high)
% function y = renorm(x, low, high)
%
% Normalize x to occupy the span [low, high].  If span not provided, assume
% [0, 1].

  if nargin < 3
    low = 0;
    high = 1;
  end
  
  oldSpan = max(x(:)) - min(x(:));
  newSpan = high - low;
  
  % Normalize to [0, 1]
  y = (x-min(x(:))) / oldSpan;
  
  % Renormalize to desired span and add offset
  y = y * newSpan + low;
  
end