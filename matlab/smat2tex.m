function smat2tex(fid,str,space)
% Write a string matrix to the text file with the code fid
% This string matrix was generated from uicontrol with the style 'edit'
%
% I donot know why 
%    fprintf(fid,'%s',txt)
% does not run correctly.  

% All Rights Reserved, 26.09.1996
% To Thanh Binh IFAT Uni. of Magdeburg Germany


m=size(str,1);
for i=1:m,
   fprintf(fid,'%s\n',[space,str(i,:)]);
end


