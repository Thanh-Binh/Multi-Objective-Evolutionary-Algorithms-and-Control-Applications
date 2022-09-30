function ESPop=evolstr(OptTask,ES);
% ESPop=evolstr(OptTask,ES)
%
% The routine is called from EVOLUT.M and is used to call the 
% main mechanism of the Evolution Strategy (MAINPROG.M) for optimization with:
% linear and/or non-linear constraints
%
% Inputs:
%   OptTask - Optimization task
%   OptTask:{ x           % variables to be optimized
%             xrange      % define the search region
%             fun         % function including algorithms to compute objectives
%             p           % auxiliary parameters
%             numpar      % number of the  auxiliary parameters
%             ConstExist  % 1 or 0 if constraints exist or not
%             fcont       % function to display contour
%             NewAxesLim  % New axes limit if the feasible region was found
%           } 
%
%   ES      - Parameter of the evolution strategy
%   ES:{ parameter                  % Parameters of the evolution strategy
%      { algorithm:{ mutation       % algorithm for mutation
%                    reproduction   % algorithm for reproduction
%                    selection      % algorithm for selection
%                  }
%        file     :{ funtmp         % temporary objective function
%                    mattmp         % temporary mat-file
%                    matopt         % mat-file for options
%                    matend         % end mat-file
%                   }
%        graphic                    % graphical handles (if they exist)
%      } 
%
% Outputs:
%   ESPop - The last population
%   ESPop:{ dim           % dimension of variables and objectives [nrows, ncols, number_of_objectives]
%           x             % variables
%           s             % strategy parameters
%           obj           % objective values
%           ConstSatisfy  % 1 or 0 if all constraints are satisfied or do not
%           plothandle    % includes plot handles (if exist)
%           generation    % Generation of the current population
%         }


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


x=OptTask.x(:);
nvars=length(x);

funcgen(ES.file.funtmp,OptTask.fun,OptTask.xrange,OptTask.numpar,OptTask.p);

% Set the first Population 
ESPop=setpopul(OptTask,ES);

if OptTask.ConstExist,
   if ~any(ESPop.obj(1,:)),
     disp('Lucky, the first population satisfies all the given restrictions!')
     ESPop.ConstSatisfy=1;
   else,
     ESPop.ConstSatisfy=0;
   end
else,
   ESPop.ConstSatisfy=1;
end


mf=ESPop.dim(3);
gui_disp=ES.parameter(16);

if ES.parameter(15), mcwdisp(ESPop.obj,0);end


if gui_disp,  % display in GUI
   if ~isempty(ES.graphic),
      aud=ES.graphic;
      set(aud(1:7),'visible','on');
      set(aud([1,2,4]),'enable','on');
      set(aud(3),'enable','off');
      set(aud(7),'string','0');
      axesq='auto';
      set(aud(9),'visible','on');
      if length(OptTask.fcon), 
         feval(OptTask.fcon);axesq=[];
         if (gui_disp==1),
            plot(x(1),x(2),'ro');text(x(1),x(2),'Start Point');
         elseif gui_disp==2,
            f=feval(ES.file.funtmp,x);
            if mf ==2,
               plot(f(2),f(3),'ro');text(f(2),f(3),'Start Point');
            elseif mf>2,
               plot3(f(2),f(3),f(4),'ro');text(f(2),f(3),f(4),'Start Point');
            end
         end
         hold on 
      end
   end

   ESPop.plothandle=guidisp1(gui_disp,ESPop.x,ESPop.obj,axesq);
   set(gcf,'UserData', {ES, OptTask, ESPop});

else

   ESPop.plothandle=[];
   ESPop=mainprog(OptTask,ES,ESPop);


   % Save all Variables  to go on
   if mf,
      if mf==1,
         [gftmp,ibth]=sort(ESPop.obj(2,:));
         ESPop.x=ESPop.x(:,ibth);ESPop.s=ESPop.s(:,ibth);ESPop.obj=ESPop.obj(:,ibth);
      end 
   end

   if OptTask.ConstExist,
      if ESPop.ConstSatisfy, 
         resf_txt='The final population satisfies all restrictions!';
      else
         resf_txt='The final population does not satisfy all restrictions!';
      end
   else,
      resf_txt='The final population satisfies all restrictions!';
   end
   if ESPop.generation < ES.parameter(17),
      message=str2mat(resf_txt,...
         'Optimization terminated successfully!',...
         'Type ''esdialog'' in the MATLAB Command Window',...
         'or click the ''Dialog''-Button in the main window',...
         'to make a dialogue with the results.',...
         '                      ',...
         'Do you want to save the obtained results?');
   else,
      message=str2mat(resf_txt,...
         'Maximum number of iterations has been exceeded! ',...
         'Type ''esdialog'' in the MATLAB Command Window',...
         'or click the ''Dialog''-Button in the main window',...
         'to make a dialogue with the results.',...
         '                      ',...
         'Do you want to save the obtained results?');
   end
   YesCall=['fud=get(gcf,''UserData'');close(gcf);',...
      'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
      'delete([fud.file.mattmp,''.mat'']);',...
      'essave([fud.file.matend,''.mat'']);'];
   NoCall=['fud=get(gcf,''UserData'');close(gcf);',...
      'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
      'delete([fud.file.mattmp,''.mat'']);delete([fud.file.matend,''.mat'']);'];       
   MsgFig=esmsg(message,'Ha ha ha','info',YesCall,NoCall,'Yes','No');
   set(MsgFig,'UserData',ES);

   mainfud={ES,OptTask,ESPop};
   set(ES.graphic(11),'UserData', mainfud);    
   save([ES.file.matend,'.mat'], 'mainfud');

end
