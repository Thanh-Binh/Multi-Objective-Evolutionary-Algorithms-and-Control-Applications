function bool = uh_isin(point,box)
% bool = uh_isin(point,box)
% To check whether a POINT is (in)outside of a BOX

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany

if((point(1) > box(1)) & (point(1) < box(1)+box(3)) & ...
   (point(2) > box(2)) & (point(2) < box(2)+box(4)))
	bool = 1;
else
	bool = 0;
end

