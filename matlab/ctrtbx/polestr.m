function polestr(fid,preg,hspace,funtxt)
% polestr(fid,preg,hspace,funtxt)
% This function is not intended to call directly from users.
% Used to generate the objective function for the pole region.


if nargin < 4, funtxt=''; end

if preg(1)==1,
   fprintf(fid,'%s\n',[hspace,'% the Stabilization region']);
   fprintf(fid,'%s\n',[hspace,'for ip=1:ncl,']);
   if preg(2)< 0,
      fprintf(fid,'%s\n',[hspace,'    f1(ip)=exp(real(o(ip))+',num2str(abs(preg(2))),');']);
   elseif preg(2)==0,
      fprintf(fid,'%s\n',[hspace,'    f1(ip)=exp(real(o(ip)));']);
   end
   fprintf(fid,'%s\n',[hspace,'end;']);

elseif preg(1)==2,

   fprintf(fid,'%s\n',[hspace,'% the Hyperbola region']);
   fprintf(fid,'%s\n',[hspace,'for ip=1:ncl,']);
   fprintf(fid,'%s\n',[hspace,'    f1(ip)=exp(real(o(ip))+',num2str(abs(preg(3))),'*sqrt(',num2str(preg(3)^2),...
           '+imag(o(ip))^2)/',num2str(preg(4)),');']);
   fprintf(fid,'%s\n',[hspace,'end;']);

elseif preg(1)==3,

   fprintf(fid,'%s\n',[hspace,'% the Disc region']);
   fprintf(fid,'%s\n',[hspace,'for ip=1:ncl,']);
   fprintf(fid,'%s\n',[hspace,'    f1(ip)=exp(sqrt((real(o(ip))+',num2str(abs(preg(2))),...
          ')^2+imag(o(ip))^2)-',num2str(preg(3)),');']);
   fprintf(fid,'%s\n',[hspace,'end;']);

elseif preg(1)==4,

   fprintf(fid,'%s\n',[hspace,'% the Disc -Hyperbola']);
   fprintf(fid,'%s\n',[hspace,'for ip=1:ncl,']);
   fprintf(fid,'%s\n',[hspace,'    f2=exp(sqrt(real(o(ip))^2+imag(o(ip))^2)-',num2str(preg(2)),');']); 
   fprintf(fid,'%s\n',[hspace,'    f3=exp(real(o(ip))+',num2str(abs(preg(3))),'*sqrt(',...
           num2str(preg(3)^2),'+imag(o(ip))^2)/',num2str(preg(4)),');']);
   fprintf(fid,'%s\n',[hspace,'    f1(ip)=max([f2,f3]);']);
   fprintf(fid,'%s\n',[hspace,'end;']);

elseif preg(1)==5,

   fprintf(fid,'%s\n',[hspace,'% the Minimal Damping degree']);
   fprintf(fid,'%s\n',[hspace,'for ip=1:ncl,']);
   fprintf(fid,'%s\n',[hspace,'    f1(ip)=exp(real(o(ip))+ abs(imag(o(ip)))*atan(',num2str(preg(2)),'));']);
   fprintf(fid,'%s\n',[hspace,'end;']);

end

if ~isempty(funtxt), fprintf(fid,'%s\n',[funtxt,'= max(f1);']);end
