function guidisp2(gui_disp,plothandle,xa,gfanf)
% guidisp2(gui_disp,plothandle,xa,gfanf)
%
% Used to refresh the data for the 'plothandle' in the GUI
%
% Inputs:
%     gui_disp = 1,      refresh in the parameter space
%                2 or 3, refresh in the objective function space


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 


mf=length(gfanf(:,1))-1;
nvars=length(xa(:,1));

if mf < 1,
   if nvars==2,
      set(plothandle,'xdata',xa(1,:),'ydata',xa(2,:)); 
   end

elseif (mf==1),
   if (nvars==1),
      set(plothandle,'xdata',xa(1,:),'ydata',gfanf(2,:));
   else,
      set(plothandle,'xdata',xa(1,:),'ydata',xa(2,:)); 
   end,

elseif mf>1,
   if (gui_disp==1)|(gui_disp==31),
      set(plothandle,'xdata',xa(1,:),'ydata',xa(2,:));
   elseif (gui_disp==2)|(gui_disp==32), 
      if mf==2,  
         set(plothandle,'xdata',gfanf(2,:),'ydata',gfanf(3,:));
      else,
         set(plothandle,'xdata',gfanf(2,:),'ydata',gfanf(3,:),'zdata',gfanf(4,:));
      end,
   end,
end,
drawnow;


