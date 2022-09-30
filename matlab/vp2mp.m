function [RowIndx,ColIndx]=vp2mp(k,m)
% [RowIndx,ColIndx]=vp2mp(k,m)
% In the practice the following converting a matrix with NROWS rows and NCOLS 
% columns into a vector can often be met, for example: 
%          A=[1 2 3;
%             4 5 6]
%          A1=A(:)=(1 4 2 5 3 6)'
% Question: Which element of A does correspond to the K-th element of A1?
%           That means: Find ROWINDX, COLINDX so that
%                       A(ROWINDX, COLINDX) is identical to A1(K)
% This function is intended to use for solving this problem.
% For the above example, the third element of A1 (k=3;NROWS=2) is identical to 
% A(RowIndx,ColIndx), where RowIndx=1; ColIndx=2;
% 
% Inputs:
%    K  - Index of a element in a vector (e.g. A1)
%    M  - Number of the rows of the original matrix
% 
% Outputs:
%    ROWINDX - Index of the row 
%    COLINDX - Index of the column


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh, University of Magdeburg Germany


RowIndx=rem(k,m);
ColIndx=floor(k/m);
if ~RowIndx,
   RowIndx=m; 
else,
   ColIndx=ColIndx+1;
end
