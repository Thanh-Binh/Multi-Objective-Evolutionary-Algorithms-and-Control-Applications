function Out=evolut1(varargin);
% For calling the Evolutionary Algorithms from other applications
%
% Usage: Out=evolut1(OptTask)
%        Out=evolut1(OptTask,SaveMedium)
%        Out=evolut1(NameofMatFile,'goon',NumberOfNextIterations)
%        Out=evolut1(HandleofMedium,'mgoon',NumberOfNextIterations)
% 
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
%   SaveMedium - the handle of a graphic object in which results of the optimization
%        (namely a cell array {ES OptTask ESPop}) should be saved.
%        For a medium:- the screen       (using get(0,'UserData') to get them),
%                     - special objects  (using get(obj_handle,'UserData')) 
%        If SaveMedium has a negative value, the old data in it are not allowed to
%        clear. In this case the new data have to be inserted into the old.
 

% Notice:
% if ~isnan(SaveMedium),
%    OldData=get(abs(SaveMedium),'UserData');
%    if isempty(OldData),
%       Data={ES,OptTask,ESPop}
%    else,
%       if SaveMedium < 0,
%         % The clearing old data is not allowed
%         Data={OldData,ES,OptTask,ESPop}
%       else,
%         % allowable both to clear and insert into them
%         % choose one og them
%       end
%    end
%    set(abs(SaveMedium),'UserData',Data);
% end
%
% See also: EVOLSTR.M, ESMUT.M, ESREPROD.M, ESSELECT.M


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 


if nargin < 1, error('One input argument at least required!');end
if nargin > 4, error('Too many input arguments!');end

if nargin==1,
   if isstruct(varargin{1}),
   % Case: evolut1(OptTask)
   
      SaveMedium=0;     % Immediate results are saved on the screen 0
      action='init';
   else,
      error('No compatible input argument!');return,
   end
elseif nargin==2,
   if isstruct(varargin{1}), 

      if isnumeric(varargin{2})
      % Case: evolut1(OptTask,SaveMedium)
         SaveMedium=varargin{2};  % Immediate results are saved in a special object
         action='init';set(abs(SaveMedium),'visible','off');
      elseif isstr(varargin{2}),
      % Case: evolut1(get(gcf,''UserData''),''evolx0'')
         action=varargin{2};
      else,
         error('No compatible input argument!');return,
      end
   else,
      error('No compatible input argument!');return,
   end
elseif nargin>2,
   if isstr(varargin{2}),
      action=varargin{2};
   else,
      error('The second argument must be a string!');return,
   end
end


% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;


switch action,

   case 'init',
      OptTask=varargin{1};
      %Set default Parameters of the Evolution Strategy
    
      ES=esoptions;
      ES.graphic=zeros(1,20);
      [NewFunName,Times] =fcreate(ES.file.funtmp,'m');
      funcgen(NewFunName,'',[],0,0);
      ES.file.funtmp  = NewFunName;
      if Times,
         ES.file.mattmp  = [ES.file.mattmp,num2str(Times)]; 
         ES.file.matopt  = [ES.file.matopt,num2str(Times)]; 
         ES.file.matend  = [ES.file.matend,num2str(Times)]; 
      end

      % Create a window to choose more options for optimization

      mainfig=choice5('Set Parameters of Evolution Strategy',500,350,[.4 .8 .8],'off','off');
      ButtonH=.0655;HSpace=.008;TextW=.445;NumW=.08;
      uicontrol('style','frame','Units','norm','pos',[.005 .01 TextW+NumW+.01 .98],...
        'Back',[.4 .8 .8]);

      uicontrol(Std,'style','text','pos',[.01 .92 TextW+NumW .05],...
        'Fore','b','Back',[.4 .8 .8],'String','Global Parameters');

      uicontrol(Std,'style','text','pos',[.015 .9-(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Population Size');
      nIv=uicontrol(Std,'Style','edit','Pos',[.45 .92-(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(1)),'Back','white');

      uicontrol(Std,'style','text','pos',[.01 .9-2*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Number of Niches');
      nEv=uicontrol(Std,'Style','edit','Pos',[.45 .92-2*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(2)),'Back','white');
   
      uicontrol(Std,'style','text','pos',[.01 .9-3*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Number of Reproductions');
      nFv=uicontrol(Std,'Style','edit','Pos',[.45 .92-3*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(3)),'Back','white');

      uicontrol(Std,'style','text','pos',[.01 .9-4*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Number of Mutations');
      nmiv=uicontrol(Std,'Style','edit','Pos',[.45 .92-4*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(4)),'Back','white');
  
      uicontrol(Std,'style','text','pos',[.01 .9-5*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Number of Offspring/Mutation');
      nom=uicontrol(Std,'Style','edit','Pos',[.45 .92-5*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(4)),'Back','white');

      uicontrol(Std,'style','text','pos',[.01 .9-6*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Reprod. Choosing factor');
      lAv=uicontrol(Std,'Style','edit','Pos',[.45 .92-6*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(8)),'Back','white');
 
      uicontrol(Std,'style','text','pos',[.01 .9-7*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Mutation Lethalfactor');
      lMv=uicontrol(Std,'Style','edit','Pos',[.45 .92-7*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(10)),'Back','white');

      uicontrol(Std,'style','text','pos',[.01 .9-8*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Number of unfeasible Niches');
      UFn=uicontrol(Std,'Style','edit','Pos',[.45 .92-8*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(19)),'Back','white');

      uicontrol(Std,'style','text','pos',[.01 .9-9*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Successful Mutation Rate');
      SMr=uicontrol(Std,'Style','edit','Pos',[.45 .92-9*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(18)),'Back','white');

      uicontrol(Std,'style','text','pos',[.01 .9-10*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Relaxing Rate of feasible Region');
      RRF=uicontrol(Std,'Style','edit','Pos',[.45 .92-10*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(20)),'Back','white');

      uicontrol(Std,'style','text','pos',[.01 .9-11*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Dispersion of the population');
      dispersion=uicontrol(Std,'Style','edit','Pos',[.45 .92-11*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(14)),'Back','white');

      uicontrol(Std,'style','text','pos',[.01 .9-12*(ButtonH+HSpace) TextW ButtonH],...
        'Fore','black','Back',[.4 .8 .8],...
        'HorizontalAlignment','left','String','Number of the generations');
      iter=uicontrol(Std,'Style','edit','Pos',[.45 .92-12*(ButtonH+HSpace) NumW ButtonH],...
        'String',num2str(ES.parameter(17)),'Back','white');

      ButtonH=.08;
      uicontrol('style','frame','Units','norm','Back',[.4 .8 .8],...
        'pos',[.55 .99-3.7*(ButtonH+HSpace)-.02 TextW-.01 3.7*(ButtonH+HSpace)+.02]);
      uicontrol(Std,'style','text','pos',[.56 .92 TextW-.04 .05],...
        'Fore','b','Back',[.4 .8 .8],'String','Algorithms');

      AlgList='Mutation Algorithm|Self Adaptation';
      MutAlg=uicontrol(Std,'style','popup','pos',[.56 .99-1.7*(ButtonH+HSpace) TextW-.03 ButtonH],...
        'Back',[.4 .8 .8],'String',AlgList);

      AlgList=['Reproduction Algorithm|Combination|Multi-Parents-Cross-Over|Arithmetic Cross-Over|',...
        'Extended-Line-Cross-Over|Heuristic'];
      RepAlg=uicontrol(Std,'style','popup','pos',[.56 .99-2.7*(ButtonH+HSpace) TextW-.03 ButtonH],...
        'Back',[.4 .8 .8],'String',AlgList);

      AlgList='Selection Algorithm|Using Fitness';
      SelAlg=uicontrol(Std,'style','popup','pos',[.56 .99-3.7*(ButtonH+HSpace) TextW-.03 ButtonH],...
        'Back',[.4 .8 .8],'String',AlgList);

      uicontrol('style','frame','Units','norm','pos',[.55 .16 TextW-.01 .47],...
        'Back',[.4 .8 .8]);
      uicontrol(Std,'style','text','pos',[.56 .57 TextW-.04 .05],...
        'Fore','b','Back',[.4 .8 .8],'String','Other Options');
      distr=uicontrol(Std,'style','popup','pos',[.56 .48 .2 ButtonH],...
        'Back',[.4 .8 .8],'string',['Distribution|Normal|Uniform']);
      uicontrol(Std,'style','push','pos',[.78 .48 .195 ButtonH],...
        'Back',[.4 .8 .8],'string','Change x0','Call',...
        'evolut1(get(gcf,''UserData''),''evolx0'');');

      uicontrol(Std,'style','text','pos',[.56 .46-1.2*ButtonH-.01 TextW-.04 ButtonH],...
        'Back',[.4 .8 .8],'String','Display Methods:');
      mcwdisp=uicontrol(Std,'style','check','pos',[.6 .46-2.2*ButtonH+.01 TextW-.11 ButtonH],...
        'Back',[.4 .8 .8],'String','in Matlab Prompt');
      guidisp=uicontrol(Std,'style','popup','pos',[.6 .46-3.2*ButtonH TextW-.11 ButtonH],...
        'Back',[.4 .8 .8],'String',['in GUI|in Parameter Space|in Objective Space']);

      uicontrol('style','frame','Units','norm','pos',[.55 .01 TextW-.01 .14],...
        'Back',[.4 .8 .8]);
      figud{1}=[nIv,nEv,nFv,nmiv,lAv,lMv,UFn,SMr,RRF,MutAlg,RepAlg,SelAlg,dispersion,...
        distr,nom mcwdisp guidisp iter SaveMedium];
      figud{2}=ES;
      figud{3}=varargin{1};
      figud{4}=mainfig;
      uicontrol(Std,'Style','push','String','OK',...
        'Pos',[.8 .03 .15 .1],'callback','evolut1([],''OKinit'',[]);');

      uicontrol(Std,'Style','push','String','Close',...
        'Pos',[.6 .03 .15 .1],'callback','close(gcf)');
      set(gcf,'UserData',figud,'tag','evolut1Mainfig','visible','on');


   case 'OKinit',
      figud=get(gcf,'UserData'); 
      ES=figud{2};figud1=figud{1};OptTask=figud{3};
      ES.parameter(1)=str2num(get(figud1(1),'string'));
      ES.parameter(2)=str2num(get(figud1(2),'string'));
      ES.parameter(3)=str2num(get(figud1(3),'string'));
      ES.parameter(4)=str2num(get(figud1(4),'string'));
      lambdaA=str2num(get(figud1(5),'string'));  
      if (lambdaA>1), lambdaA=1; end;
      if (lambdaA<0), lambdaA=0; end;

      lambdaM=str2num(get(figud1(6),'string'));  
      if (lambdaM>1), lambdaM=1; end;
      if (lambdaM<0), lambdaM=0; end;

      UFnumber=str2num(get(figud1(7),'string'));  
      if (UFnumber <= 0), UFnumber=0; end;
      SMr=str2num(get(figud1(8),'string'));  

      RRF=str2num(get(figud1(9),'string'));  
      dispersion=str2num(get(figud1(13),'string'));  
      nom=str2num(get(figud1(15),'string'));  
      iter=str2num(get(figud1(18),'string'));  
      ES.parameter([5 8,10,14,17,18,19,20])=[nom,lambdaA,lambdaM,dispersion,iter,SMr,UFnumber,RRF];
      val= get(figud1(10),'Value');
      if val==2,
         ES.algorithm.mutation='SelfAdapt';
      else,
         ES.algorithm.mutation='SelfAdapt';
      end,
      val= get(figud1(11),'Value');
      if val==2,
         ES.algorithm.reproduction='Combi';
      elseif val==3,
         ES.algorithm.reproduction='MultiParent';
      elseif val==4,
         ES.algorithm.reproduction='Arithmetic';
      elseif val==5,
         ES.algorithm.reproduction='ExtendedLine';
      elseif val==6,
         ES.algorithm.reproduction='Heuristic';
      else,
         ES.algorithm.reproduction='Combi';
      end,
      val= get(figud1(12),'Value');
      if val==2,
         ES.algorithm.selection='Fitness';
      else,
         ES.algorithm.selection='Fitness';
      end,
      val= get(figud1(14),'Value');
      if val==3,
         ES.parameter(13)=1;
      else,
         ES.parameter(13)=2;
      end,
      val= get(figud1(16),'Value');
      if val==1,
         ES.parameter(15)=1;
      else,
         ES.parameter(15)=0;
      end,
      val= get(figud1(17),'Value');
      if val==2,
         ES.parameter(16)=1;
      elseif val==3,
         ES.parameter(16)=2;
      else,
         ES.parameter(16)=0;       
      end,       
      ES.medium=abs(figud1(19));
      ClearAllow=(sign(figud1(19))>=0);
      if ~isnan(ES.medium),
         OldData=get(ES.medium,'UserData');
         if ~isempty(OldData), 
            set(gcf,'UserData',{OldData,ES, OptTask,[]});
            what2do(gcf,ES.medium,ClearAllow);
         else,
            set(ES.medium,'UserData',{ES, OptTask,[]});close(gcf);
            evolut1(OptTask,'do',ES);
         end;
      end;


   case 'evolx0',
      choice5('Set a Start Point',260,160,[.4 .8 .8],'off','off');
      uicontrol(Std,'style','text','pos',[.05 .83 .9 .12],'string','Input the variable x0:',...
        'back',[.4 .8 .8],'fore','red','HorizontalAlignment','left');
      x0=uicontrol(Std,'Style','edit','Pos',[.05 .68 .9 .15],'Back','white');
      uicontrol(Std,'style','text','pos',[.05 .5 .9 .12],'string','The region for x0 (if you know):',...
        'back',[.4 .8 .8],'fore','red','HorizontalAlignment','left');
      x1=uicontrol(Std,'Style','edit','Pos',[.05 .35 .9 .15],'Back','white');
      uicontrol(Std,'Style','push','String','OK',...
        'Pos',[.4 .05 .2 .15],'Call','evolut1([],''OKevolx0'',[]);');
      set(gcf,'UserData',{[x0,x1],varargin{1}},'visible','on');


   case 'OKevolx0',
      fud=get(gcf,'UserData');mainfud=fud{2};fud=fud{1};errortxt=[];
      x=get(fud(1),'string');
      if isempty(x),
         esmsg('A starting point required?','Error','error'); return,
      else,
         x=eval(x);
         if isempty(x),
            esmsg('A starting point required?','Error','error'); return,
         end,
      end,
      xrange=get(fud(2),'string');
      if ~isempty(xrange), xrange=eval(xrange); else, xrange=[];end;
      if ~isempty(xrange),
         if length(x(:))~=size(xrange,2),
            errortxt='Dimensions not compatible!';
         end,
         if any(xrange(1,:)>xrange(2,:)), 
            errortxt=str2mat(errortxt,'Ranges of x0 not compatible');
         end,
         if ~isempty(errortxt),
            esmsg(errortxt,'Error','error');
         else,
            mainfud{3}.x=x;mainfud{3}.xrange=xrange;  
            set(mainfud{4},'Userdata',mainfud);
            close(gcf),
         end,
      else,
         mainfud{3}.x=x;mainfud{3}.xrange=xrange;  
         set(mainfud{4},'Userdata',mainfud);
         close(gcf),
      end
         

   case 'do',
      funcgen(varargin{3}.file.funtmp,varargin{1}.fun,varargin{1}.xrange,varargin{1}.numpar,varargin{1}.p);
      % Set the first Population 
      ESPop=setpopul(varargin{1},varargin{3});
      evolut1(varargin{1},'mainprog',varargin{3},ESPop);


   case 'goon',
      if ~isstr(varargin{1}),
         error('The first argument is invalid!');return
      end
      if ~exist(varargin{1},'file'),
         esmsg(str2mat([' The file ''',varargin{1},''' can not be found.'],...
                    ' We have not enough data to go on',...
                    ' Good bye.'),'Error','error');
         return,
      end
      load(varargin{1});
      if ~exist('mainfud','var'),
         error('Imcompatible mat-file!');return
      end      
      ES=mainfud{1};OptTask=mainfud{2};ESPop=mainfud{3};
      [NewFunName,Times] =fcreate(ES.file.funtmp,'m');
      ES.file.funtmp  = NewFunName;
      if Times,
         ES.file.mattmp  = [ES.file.mattmp,num2str(Times)]; 
         ES.file.matopt  = [ES.file.matopt,num2str(Times)]; 
         ES.file.matend  = [ES.file.matend,num2str(Times)]; 
      end
      if nargin==3,
         if isnumeric(varargin{3}), 
           ES.parameter(17)=varargin{3}+ESPop.generation;
         else
           error('The third argument is invalid!');return
         end
      end
      funcgen(ES.file.funtmp,OptTask.fun,OptTask.xrange,OptTask.numpar);
      evolut1(OptTask,'mainprog',ES,ESPop);


   case 'mgoon',
      % continue from a medium
      % The variable of the medium must be a cell array like:
      %    {ES,OptTask,ESPop} or {OldData,ES,OptTask,ESPop}.
     
      
      if ~isnumeric(varargin{1}),
         error('Invalid medium (the first argument)!');return
      end
      MediumData=get(varargin{1},'UserData');
      MedError=0;
      if ~iscell(MediumData),
         MedError=1;
      else,
         MediumDataL=length(MediumData);
         if (MediumDataL==3),
            ES=MediumData{1};OptTask=MediumData{2};ESPop=MediumData{3};
         elseif (MediumDataL==4),
            ES=MediumData{2};OptTask=MediumData{3};ESPop=MediumData{4};         
         else,
            MedError=1;
         end
      end
      if MedError, error('Invalid data in this medium!');return,end
      if nargin==3,
         if isnumeric(varargin{3}), 
           ES.parameter(17)=varargin{3}+ESPop.generation;
         else
           error('The third argument is invalid!');return
         end
      end
      funcgen(ES.file.funtmp,OptTask.fun,OptTask.xrange,OptTask.numpar);      
      evolut1(OptTask,'mainprog',ES,ESPop);


   case 'mainprog',
      OptTask=varargin{1};ES=varargin{3};ESPop=varargin{4};
      x=OptTask.x(:);
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
      ES.graphic=zeros(1,12);
      mf=ESPop.dim(3);
      if ES.parameter(16)==1, 
         ES.parameter(16)=31;
      elseif ES.parameter(16)==2,
         ES.parameter(16)=32;
      end
      gui_disp=ES.parameter(16);

      if gui_disp,  % display in GUI
         OldFig=findobj('name','Display for the Evolution Strategy');
         if isempty(OldFig),
            ES.graphic(11)=choice5('Display for the Evolution Strategy',500,350,[.8 .8 .8]);
            ES.graphic(9)=axes('units','norm','pos',[.1 .1 .8 .8],'Drawmode','fast',...
              'clipping','on','Xlimmode','manual','Ylimmode','manual','tag','DESAxes');
            ES.graphic(7)=uicontrol(Std,'Style','text','pos',[.84 .85 .057 .044],...
              'String',num2str(ESPop.generation),'Fore','b','tag','DESIter');
         else,
            figure(OldFig);ES.graphic(11)=OldFig;
            ES.graphic(9)=gca;
            ES.graphic(7)=findobj('tag','DESIter');
            set(ES.graphic(7),'String',num2str(ESPop.generation));
         end

         if length(OptTask.fcon), 
            feval(OptTask.fcon);axesq=[];
            if (gui_disp==31),
               plot(x(1),x(2),'ro');text(x(1),x(2),'Start Point');
            elseif (gui_disp==32),
               f=feval(ES.file.funtmp,OptTask.x);
               if mf ==2,
                  plot(f(2),f(3),'ro');text(f(2),f(3),'Start Point');
               elseif mf>2,
                  plot3(f(2),f(3),f(4),'ro');text(f(2),f(3),f(4),'Start Point');
               end
            end
            hold on 
         end
         ESPop.plothandle=guidisp1(gui_disp,ESPop.x,ESPop.obj,axesq);
         set(gcf,'UserData',{ES,OptTask,ESPop},'CloseRequestFcn',[...
           'mainfud=get(gcf,''UserData'');delete([mainfud{1}.file.funtmp,''.m'']);',...
           'delete([mainfud{1}.file.mattmp,''.mat'']);delete([mainfud{1}.file.matopt,''.mat'']);',...
           'delete([mainfud{1}.file.matend,''.mat'']);delete(get(0,''CurrentFigure''));']);

      else
         ESPop.plothandle=[];
      end
      ESPop=mainprog(OptTask,ES,ESPop);

      % Save all Variables  to go on
      if mf==1,
         [gftmp,ibth]=sort(ESPop.obj(2,:));
         ESPop.x=ESPop.x(:,ibth);ESPop.s=ESPop.s(:,ibth);ESPop.obj=ESPop.obj(:,ibth);
      end

      if OptTask.ConstExist,
         if ESPop.ConstSatisfy, 
           resf_txt='The final population satisfies all restrictions!';
         else
           resf_txt='The final population does not satisfy all restrictions!';
         end
      else,
         resf_txt=' ';
      end
      if ESPop.generation < ES.parameter(17),
         message=str2mat(resf_txt,...
           'Optimization terminated successfully!',...
           'Using ''esdialog'' in the MATLAB Command Window',...
           'to make a dialogue with the results.',...
           '                      ',...
           'Do you want to save the obtained results?');
      else,
         message=str2mat(resf_txt,...
           'Maximum number of iterations has been exceeded! ',...
           'Using ''esdialog'' in the MATLAB Command Window',...
           'to make a dialogue with the results.',...
           '                      ',...
           'Do you want to save the obtained results?');
      end
      
      mainfud={ES, OptTask, ESPop};
      if ~isnan(ES.medium),
         MediumData=get(ES.medium,'UserData');
         MediumDataL=length(MediumData);
         if MediumDataL==4,
            MediumData{2}=ES;MediumData{3}=OptTask;MediumData{4}=ESPop;
         elseif MediumDataL ==3,
            MediumData=mainfud;
         end
         set(ES.medium,'UserData',MediumData);
         YesCall=['fud=get(gcf,''UserData'');close(gcf);',...
           'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
           'delete([fud.file.mattmp,''.mat'']);set(fud.medium,''visible'',''on'');',...
           'essave([fud.file.matend,''.mat'']);'];
         NoCall=['fud=get(gcf,''UserData'');close(gcf);',...
           'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
           'delete([fud.file.mattmp,''.mat'']);delete([fud.file.matend,''.mat'']);',...
           'set(fud.medium,''visible'',''on'');'];       

      else,
         YesCall=['fud=get(gcf,''UserData'');close(gcf);',...
           'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
           'delete([fud.file.mattmp,''.mat'']);',...
           'essave([fud.file.matend,''.mat'']);'];
         NoCall=['fud=get(gcf,''UserData'');close(gcf);',...
           'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
           'delete([fud.file.mattmp,''.mat'']);delete([fud.file.matend,''.mat'']);'];       
      end      
      MsgFig=esmsg(message,'Ha ha ha','info',YesCall,NoCall,'Yes','No');
      set(MsgFig,'UserData',ES);     
      Out=mainfud;
      save([ES.file.matend,'.mat'], 'mainfud');  

end
