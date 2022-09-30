function fgenui(action)
% fgenui(action)
% Open a window to generate an objective function for each optimization task
%

% All Rights Reserved, 26.09.1996
% To Thanh Binh IFAT Uni. of Magdeburg Germany


% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;

if nargin < 1, action='init';end

if strcmp(action(1:4),'init'),

   choice5('Creating an objective function',600,400,[.4 .8 .8],'on');

   uicontrol('Style','frame','units','norm','pos',[.01 .65 .85 .33]);
   uicontrol(Std,'Style','text','pos',[.02 .92 .5 .05],...
      'String','Objective function','HorizontalAlignment','left','Fore','b');
   Hndl(1)=uicontrol(Std,'Style','edit','pos',[.02 .66 .83 .25],...
      'HorizontalAlignment','left','Back','white','Max',2,'String','obj(1)=');


   uicontrol('Style','frame','units','norm','pos',[.01 .01 .85 .62]);

   uicontrol(Std,'Style','text','pos',[.02 .57 .5 .05],'Fore','b',...
      'String','Constraints (for defining a feasible region)','HorizontalAlignment','left');
   Hndl(2)=uicontrol(Std,'Style','edit','pos',[.02 .2 .83 .36],...
      'HorizontalAlignment','left','Back','white','Max',2,'String','cons(1)=');

   uicontrol(Std,'Style','text','pos',[.02 .13 .8 .05],'Fore','b',...
      'String','Boundaries of the variables (for defining a search region)','HorizontalAlignment','left');

   uicontrol('Style','frame','units','norm','pos',[.02 .02 .84 .1]);
 
   uicontrol(Std,'Style','text','pos',[.025 .025 .08 .09],...
      'String','Lower','Fore','b');
   Hndl(3)=uicontrol(Std,'Style','edit','pos',[.105 .03 .315 .08],...
      'Back','white','String','[ ]');
 
   uicontrol(Std,'Style','text','pos',[.435 .025 .08 .09],...
      'String','Upper','Fore','b');
   Hndl(4)=uicontrol(Std,'Style','edit','pos',[.535 .03 .315 .08],...
      'Back','white','String','[ ]');

   uicontrol(Std,'Style','text','pos',[.87 .76 .12 .07],'String','FunName:',...
      'Back',[.4 .8 .8],'HorizontalAlignment','left','Fore','b');
   Hndl(5)=uicontrol(Std,'Style','edit','pos',[.87 .71 .12 .08],...
      'Back','white');
   uicontrol(Std,'Style','text','pos',[.87 .59 .12 .07],'String','Precision:',...
      'Back',[.4 .8 .8],'HorizontalAlignment','left','Fore','b');
   Hndl(6)=uicontrol(Std,'Style','edit','pos',[.87 .54 .12 .08],...
      'Back','white','String','1e-7');

   set(gcf,'Userdata',Hndl);

   uicontrol(Std,'Style','push','pos',[.87 .35 .12 .1],'String','Cancel',...
      'call','close(gcf)');

   uicontrol(Std,'Style','push','pos',[.87 .2 .12 .1],'String','OK',...
      'call','fgenui(''done'');');

elseif strcmp(action,'done'),

   hndl=get(gcf,'Userdata');time=clock;
   FunName=get(hndl(5),'String');
   ErrorHere=0;errortxt='';
   if isempty(FunName),
      errortxt=str2mat(' The Name of m-file is empty!!!!.',...
         ' Please give a string name in the edit box ''FunName:''');
      esmsg(errortxt,'Error','error');
   else, 
      fid=fopen([FunName,'.m'],'wt');
      fprintf(fid,'%s\n',['function f=',FunName,'(x)']);
      fprintf(fid,'%s\n\n\n',['% Objective function written on ', date,' at ',...
             num2str(time(4)),':',num2str(time(5)),' by The Evolution Strategy Toolbox']);

      txt=get(hndl(2),'String');
      if ~isempty(txt),
         epsilon=get(hndl(6),'String');
         fprintf(fid,'%s\n\n',['epsilon=',str2num(epsilon),'; beta=2;']);
      end
      Lower=get(hndl(3),'String');LowerIndx=0;
      Upper=get(hndl(4),'String');UpperIndx=0;
      if isempty(str2num(Lower)), Lower='-inf*ones(size(x))'; LowerIndx=1;end
      if isempty(str2num(Upper)), Upper='inf*ones(size(x))'; UpperIndx=1; end
      if any(str2num(Lower) > str2num(Upper)),
         errortxt=str2mat(errortxt,'Lower Values must be less than Upper ones!');
         ErrorHere=1;
      end
      if ~(LowerIndx & UpperIndx),
         fprintf(fid,'%s\n\n',['if all(x<=',Upper,') & all(x>=', Lower,'),']);
         space=32*ones(1,4);
      else,
         space='';
      end
      if ~isempty(txt),
         fprintf(fid,'%s\n',[space,'% Compute the Constraints']);
         smat2tex(fid,txt,space);
         fprintf(fid,'%s\n','');
         fprintf(fid,'%s\n\n\n',[space,'cons=sum((abs(cons).*(cons > epsilon)).^beta);']);
      else,
         fprintf(fid,'%s\n\n',[space,'cons=0;   % No constraints here']);
      end
      txt=get(hndl(1),'String');
      if ~isempty(txt),
         fprintf(fid,'%s\n',[space,'% Compute the objective function']);
         smat2tex(fid,txt,space);
         fprintf(fid,'%s\n\n','');
         fprintf(fid,'%s\n\n',[space,'f=[cons;obj''];']);
      else,
         fprintf(fid,'%s\n\n',[space,'f=cons;  % No objective function here']);
      end    
      if ~(LowerIndx & UpperIndx),    
         fprintf(fid,'%s','end');
      end
      fclose(fid);
      if ~ErrorHere, 
         close(gcf); 
      else,
         esmsg(errortxt,'Error','error');
      end
   end 
end
