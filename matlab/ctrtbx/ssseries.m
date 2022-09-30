function [a,b,c,d] = ssseries(a1,b1,c1,d1,a2,b2,c2,d2)
%SSSERIES Series connection of two state-space systems.  
%
%   u --->[System1]--->[System2]----> y
%
%   [A,B,C,D] = SSSERIES(A1,B1,C1,D1,A2,B2,C2,D2) produces an aggregate
%   state-space system consisting of the series connection of systems
%   1 and 2 that connects all the outputs of system 1 connected to 
%   all the inputs of system 2, u2 = y1.  The resulting system has 
%   the inputs of system 1 and the outputs of system 2.
%
%   See also: SERIES,APPEND,PARALLEL,FEEDBACK and CLOOP.

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 


if nargin ~=8, error('Eight input arguments required!');end

% Check sizes
if (size(c1,1)~=size(b2,2))
    error('Series connection sizes don''t match.'); 
end

a=[a1,zeros(size(a1,1),size(a2,1));b2*c1 a2];
b=[b1;b2*d1];
c=[d2*c1 c2];
d=d2*d1;

