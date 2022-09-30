function  msg=abcdechk(a,b,c,d,e)
%ABCECHK Checks dimensional consistency of A,B,C,D,E matrices.
%	MSG = ABCEDCHK(A,B,C,D,E) checks the consistency of the dimensions 
%	of A,B,C,D,E.  Returns the empty matrix if they are, or 
%	an error message string if they are not.
%
%	Valid systems with empty matrices are allowed.  
%       To Use for the Controller Design.

% 	To Thanh Binh IFAT Uni. Magdeburg Germany 7-21-95
%       All Rights reserved.
msg = [];
[ma,na] = size(a);
if (ma ~= na)
	msg = [msg;'The A matrix must be square.                              '];
end
if (nargin > 1)
   [mb,nb] = size(b);
   if (ma ~= mb)&nb
      msg = [msg;'The A and B matrices must have the same number of rows.   '];
   end
   if (nargin > 2)
      [mc,nc] = size(c);
      if (nc ~= ma)&mc
 	msg = [msg;'The A and C matrices must have the same number of columns.'];
      end
      if (nargin > 3)
        [md,nd] = size(d);
        if (md ~= mc),
 	  msg = [msg;'The D and C matrices must have the same number of rows.   '];
        end
        if (nd ~= nb),
 	  msg = [msg;'The D and B matrices must have the same number of columns.'];
        end
      end
      if (nargin>4)
         [me,ne]=size(e);
         if ((ma+mb+mc) == 0), return, end
         if (ma ~=me)&ne
            msg = [msg;'The A and E matrices must have the same number of rows.   '];
         end
      end
   end
end
