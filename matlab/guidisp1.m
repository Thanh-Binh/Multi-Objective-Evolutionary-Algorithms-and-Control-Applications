function plothandle=guidisp1(gui_disp,xa,gfanf,axesq)
% plothandle=guidisp1(gui_disp,xa,gfanf,axesq)
%
% Used to diplay current results in the GUI
%
% Inputs:
%     gui_disp = 0 , not plot
%                1 , plot in the parameter space
%                2 , plot in the objective function space
%                3 , plot in the objective function space
%                    (only used with EVOLSTR1.M)
%
%     axesq - axis to plot, when it is necessary. 
%             axes=[]; no axis
%
% Outputs:
%     plothandle - handle to plot


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


mf=length(gfanf(:,1))-1;
nvars=length(xa(:,1));

if nargin < 4,
    axesq=[];
end


% set the plothandle 
if mf < 1,         % Solve a system of inequalities
   if nvars==2,
      plothandle=plot(xa(1,:),xa(2,:),'r*');
      title('Solution of a system of inequalities in parameter space');
      xlabel('x_1');ylabel('x_2');
   elseif nvars>2,
      plothandle=plot(xa(1,:),xa(2,:),xa(3,:),'r*');
      title('Solution of a system of inequalities in parameter space');
      xlabel('x_1');ylabel('x_2');zlabel('x_3');
   end

elseif (mf==1),
   if (nvars==1),  % a function of a variable f(x), plot y=f(x)

      plothandle=plot(xa(1,:),gfanf(2,:),'r*');
      title('Minimization of the function y=f(x)');
      xlabel('x');ylabel('y');


   elseif nvars==2,           % a function of several variables

      plothandle=plot(xa(1,:),xa(2,:),'r*');
      title('Minimization of y=f(x_1,x_2) in parameter space');
      xlabel('x_1'); ylabel('x_2'); 
 
   elseif nvars ==3,          % a function of several variables

      plothandle=plot(xa(1,:),xa(2,:),xa(3,:),'r*');
      title('Minimization of y=f(x_1,x_2,x_3) in parameter space');
      xlabel('x_1');ylabel('x_2');zlabel('x_3');

   elseif nvars > 3,          % a function of several variables

      plothandle=plot(xa(1,:),xa(2,:),xa(3,:),'r*');
      title(['Minimization of y=f(x_1,..,x_',num2str(nvars),'3) in parameter space']);
      xlabel('x_1');ylabel('x_2');zlabel('x_3');
   end


elseif mf >1,
   if (gui_disp==1)|(gui_disp==31),
      if nvars ==1,
         error('I can not display in the one-dimensional space?')
      elseif nvars==2,
         plothandle=plot(xa(1,:),xa(2,:),'r*');
         title('Multiobjective Optimization in parameter space');
         xlabel('x_1'); ylabel('x_2');
      elseif nvars>2,
         plothandle=plot(xa(1,:),xa(2,:),xa(3,:),'r*');
         title('Multiobjective Optimization in parameter space');
         xlabel('x_1'); ylabel('x_2');zlabel('x_3');

      end          
   elseif (gui_disp==2)|(gui_disp==32),

      if mf==2,
         plothandle=plot(gfanf(2,:),gfanf(3,:),'r*');
         title('Multiobjective Optimization in objective function space');
         xlabel('f_1'); ylabel('f_2');

      else
         plothandle=plot3(gfanf(2,:),gfanf(3,:),gfanf(4,:),'r*');
         title('Multiobjective Optimization in objective function space');
         xlabel('f_1');ylabel('f_2');zlabel('f_3');
      end
   end
end
%set(plothandle,'erasemode','xor');
grid off

% set the first axis for plotting
if ~isempty(axesq), axis(axesq);end



