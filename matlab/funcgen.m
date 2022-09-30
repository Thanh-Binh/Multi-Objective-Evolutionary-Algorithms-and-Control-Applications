function funcgen(AUXFUN,FUN,xrange,par_number,P)
% funcgen(AUXFUN,FUN,xrange,par_number,P)
% This function is used to generate a temporary function which call the
% function for each optimization problem and return all neccessary
% output variables.
% It is not inteded to be directly called from users.


% The Evolution Strategy Toolbox  
% Version 3.0   
% All Rights Reseverd, Oct 1996
% To Thanh Binh, IFAT, University of Magdeburg, Germany



clear(AUXFUN);    % clear the currently compiled function AUXFUN from the 
                  % workspace

fid=fopen([AUXFUN,'.m'],'wt');
time=clock;

firstrow=[...
   ['function f=',AUXFUN,'(x) \n']...
   '%% Temporary objective function for the evolution strategy \n\n'...
   '%% Written on ', date,' at ',num2str(time(4)),':',num2str(time(5)),' by Evolution Strategy \n\n'];

fprintf(fid,firstrow);

if ~isempty(FUN),
   if ~any(FUN<48),secondrow=['f=',FUN,'(x'];end
   for i=1:par_number,
      secondrow = [secondrow,',P',num2str(i)];
      txt=mat2text(P{i},['P',num2str(i),'=']);
      [nrows,ncols]=size(txt);txt(:,ncols+1)=10*ones(nrows,1);
      fprintf(fid,'%s\n',txt');
   end
   secondrow = [secondrow, ');'];

else,
   % for initiation the optimization when the file 'ftemp.m' does not exist
   secondrow='f=inf;';
end   

if ~isempty(xrange),
    checktxt=['xx=x(:);\n'...
          'if ','all(xx <= ',mat2str(xrange(2,:)'),')&  all(xx >= ',mat2str(xrange(1,:)'),'),\n'...
          '    ',secondrow ,'\n'...
          'else,\n'...
          '    f=inf;\n'...
          'end \n'];
    fprintf(fid,checktxt);
else,
    fprintf(fid,'%s\n',secondrow);
end
fclose(fid);



