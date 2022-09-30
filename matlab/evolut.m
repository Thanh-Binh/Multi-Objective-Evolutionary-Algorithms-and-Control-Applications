function evolut(action,Par1)
% evolut(action)
% The main routine to open the GUI for the multi-objective
% evolution strategy with linear and non-linear constraints.
% Usage: evolut



% Notice:
%   UserData of the main figure (mainfud) is a cell array :
%       mainfud{1}=ES;mainfud{2}=OptTask; mainfud{3}=ESPop;
%       ES.graphic=[ghndl(1,11),fig_of_demolist]
%   See EVOLSTR.M for more details

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin < 2,
   Par1=[];
   if nargin < 1,
      action='Initialize';
   end 
end


% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;

switch action,

  case 'Initialize',
     units_old=get(0,'units');
     set(0,'units','Pixels'); 
     ss = get(0,'ScreenSize');
     set(0,'units',units_old); 
     w = 700; h = 550;
     rect = [0.5*(ss(3)-w),0.5*(ss(4)-h),w,h];
     ghndl(11)=figure('units','pixels','Pos',rect,'numbertitle','off', 'HandleVisibility','on',...
       'Menubar','none','Resize','off',...
       'WindowButtonMotionFcn','eshelper','visible','off','BackingStore','off',...
       'CloseRequestFcn',[...
       'mainfud=get(gcf,''UserData'');delete(get(0,''CurrentFigure''));delete([mainfud{1}.file.funtmp,''.m'']);',...
       'delete([mainfud{1}.file.mattmp,''.mat'']);delete([mainfud{1}.file.matopt,''.mat'']);',...
       'delete([mainfud{1}.file.matend,''.mat'']);clear mainfud;']);


     uicontrol('Style','frame','Units','norm','Pos',[0 0.93 .8 .07], ...
       'Back',[.25 .7 .7]);
     ButtonW=.79/7;
     ghndl(10)=uicontrol(Std,'style','push','String','Function','fore','red',...
       'tag','ESFunc','pos',[.005 .937 ButtonW .054],'Call',[...
       'mainfud=get(gcf,''UserData'');MatFile=mainfud{1}.file.matopt;clear fud mainfud;',...
       'save([MatFile,''.mat'']);evolut(''evolopts'');']);

     uicontrol(Std,'style','push','String','Dialog','fore','b',...
       'tag','ESDialog','pos',[.005+ButtonW .937 ButtonW .054],'Call','esdialog(''init'',gcf);');

     uicontrol(Std,'style','push','String','Go on','fore','b',...
       'tag','ESGoon','pos',[.005+2*ButtonW .937 ButtonW .054],'Call','evolut(''goon'');');

     uicontrol(Std,'style','popupmenu','String','Print|gca|all','fore','b',...
       'tag','ESPrint','pos',[.005+3*ButtonW .937 ButtonW .054],'Call',[...
         'this=findobj(''tag'',''ESPrint'');val= get(this,''Value'');',...
         'if val==2,',...
         '   print -noui -dps;',...
         'elseif val==3,',...
         '   print -dps;',...
         'end;',...
         'set(this,''String'',''Print'')']);

     uicontrol(Std,'style','push','String','Close','fore','b',...
       'tag','ESClose','pos',[.005+4*ButtonW .937 ButtonW .054],'Call',[...
       'mainfud=get(gcf,''UserData'');',...
       'delete([mainfud{1}.file.funtmp,''.m'']);delete([mainfud{1}.file.matopt,''.mat'']);',...
       'delete([mainfud{1}.file.mattmp,''.mat'']);delete([mainfud{1}.file.matend,''.mat'']);',...
       'close(gcf)']);

     uicontrol(Std,'style','push','String','Help','fore','b',...
       'tag','ESHelp','pos',[.005+5*ButtonW .937 ButtonW .054],'Call','evolut(''evolintro'');');

     uicontrol(Std,'style','push','String','Info...','fore','b',...
       'tag','ESInfos','pos',[.005+6*ButtonW .937 ButtonW .054],'Call','evolut(''evolinfo'');');

     uicontrol('Style','frame','Units','norm','Pos',[.8 0.051 .199 .949], ...
       'Back',[.25 .7 .7]);


     uicontrol(Std,'style','push','String','ES Options','fore','b',...
       'tag','ESOptions','pos',[.825 .82 .15 .08],'Call','evolut(''evolsetp'');');

     uicontrol(Std,'style','push','String','ES Demos',...
       'tag','ESdemos','pos',[.825 .7 .15 .08],'fore','b',...
       'Call','demolist(''init'',gcf);');   

     uicontrol(Std,'style','push','String','Run MatFile','fore','b',...
       'tag','ESRunMatFile','pos',[.825 .58 .15 .08],'Call','evolut(''another'');');

     uicontrol(Std,'style','push','String','MatDialog','fore','b',...
       'tag','ESMatDialog','pos',[.825 .46 .15 .08],'Call','evolut(''dialog'');');
      
     uicontrol(Std,'style','push','String','Run','fore','red',...
       'tag','ESRun','pos',[.85 .145 .1 .1],'Interruptible','on','Call',[...
       'mainfud=get(gcf,''UserData'');',...
       'mainfud{3}=evolstr(mainfud{2},mainfud{1});']);

     uicontrol('Style','frame','Units','norm','Pos',[.001 0.001 .998 .05], ...
       'Back',[0.25 0.7 0.7]);

     uicontrol(Std,'Style','text','Pos',[.005 0.0049 .98 .035], ...
       'Back',[0.25 0.7 0.7],'String','Wellcome to the Evolution Strategy',...
       'tag','ESHelpStatus','fore','b');

     ghndl(1)=uicontrol(Std,'style','push','pos',[.11 .07 .09 .05],'string','Step',...
       'tag','ESstepButton','Call',[...
       'mainfud=get(gcf,''UserData'');',...
       'mainfud{1}.parameter(7) = 1;',...
       'mainfud{3}=mainprog(mainfud{2},mainfud{1},mainfud{3});',...
       'mainfud{1}.parameter(7) = 0;',...
       'set(gcf,''UserData'',mainfud);']);

     ghndl(2)=uicontrol(Std,'style','push','pos',[.22 .07 .09 .05],'string','Go',...
       'tag','ESgoButton','interruptible','on','Call',[...
       'mainfud=get(gcf,''UserData'');',... 
       'set(mainfud{1}.graphic([1,2,4]),''Enable'',''off'');',...
       'set(mainfud{1}.graphic(3),''Enable'',''on'');',...
       'mainfud{3}=mainprog(mainfud{2},mainfud{1},mainfud{3});',...
       'set(gcf,''UserData'',mainfud);',...
       'set(mainfud{1}.graphic([1,2,4]),''Enable'',''on'');',...
       'set(mainfud{1}.graphic(3),''Enable'',''off'');']);

     ghndl(3)=uicontrol(Std,'style','push','pos',[.33 .07 .09 .05],'string','Stop',...
       'Enable','off','tag','ESstopButton','call',[...
       'mainfud=get(gcf,''UserData'');set(mainfud{1}.graphic(3),''Enable'',''off'');']);

     ghndl(4)=uicontrol(Std,'style','push','pos',[.44 .07 .09 .05],'string','Done',...
       'tag','ESdoneButton','Call','evolut(''evoldone'');');
     ghndl(5)=uicontrol('Style','frame','units','norm','pos',[.55 .073 .13 .044]);

     ghndl(6)=uicontrol(Std,'Style','text','pos',[.565 .077 .06 .034],'string','Gen.:');
     ghndl(7) = uicontrol(Std,'Style','text','pos',[.62 .077 .05 .034],...
       'string','0','Fore','red','tag','ESIterhndl');   
 

     ghndl(9)=axes('units','norm','pos',[.1 .2 .65 .65],'clipping','on',...
       'Xlimmode','manual','Ylimmode','manual','HandleVisibility','on','tag','ESMainAxes');
     set(ghndl([1:7, 9]),'visible','off');

     %Set default Parameters of the Evolution Strategy
     ES=esoptions;
     [NewFunName,Times] =fcreate(ES.file.funtmp,'m');
     funcgen(NewFunName,'',[],0,0);
     ES.file.funtmp  = NewFunName;
     ES.graphic      = ghndl;
     if Times,
        ES.file.mattmp  = [ES.file.mattmp,num2str(Times)]; 
        ES.file.matopt  = [ES.file.matopt,num2str(Times)]; 
        ES.file.matend  = [ES.file.matend,num2str(Times)]; 
        FigName=['The Evolution Strategy (',num2str(Times),')'];
     else,
        FigName='The Evolution Strategy';
     end

     set(gcf,'UserData',{ES},'Backingstore','off','name',FigName,'visible','on');

 
  case 'evolintro',
 
    helpStr{1}=...
    ['Many engineering design problems are generally multiobjective, '
     'in that several design aims (multiple measures of performance) '
     'need to be simultaneously achieved. If we describe quantita-   '
     'tively all these objectives as a set of N design objective     '
     'functions f_i(x), i=1,..,N, where x denotes the n-dimensional  '
     'vector of design parameters, the design problem could be       '
     'formulated as a multiobjective optimization problem:           '
     '                                                               '
     '           min (f_1(x), f_2(x),..., f_N(x))                    '
     '                                                               '
     'The objective variable x should be in a feasible region S      '
     'of the n-dimensional space, which is often determined by the   '
     'auxiliary design constraints. The auxiliary constraints can    '
     'have any natur, for example, they can be expressed in terms    '
     'of function inequalities or equalities etc.. In most cases,    '
     'the objective functions are in conflict, so that it is not     '
     'possible to reduce any of the objective functions without      '
     'increasing at least one of the other objective functions. This '
     'is known as the concept of pareto optimality. The multi-       '
     'objective optimization problems tend to be characterized by a  '
     'very large set of admissible solutions (trade--offs), known as '
     'the set of pareto--optimal solutions.                          '];
 
    helpStr{2}=...   
    ['By handling a number of individuals in the current population  '
     'the evolution strategies have been recognized to be possibly   '
     'well-suited to the multiobjective optimization (to approximate '
     'the pareto--optimal set by a current population).              '
     'It is based on the main genetic mechanisms: Mutation, Repro-   '
     'duction and Selection, and on ranking according to the actual  '
     'concept of pareto optimality. This evolution strategy          '
     'guarantees an equal probability of reproduction and selection  '
     'to all the noninferior individuals in the current population.  '
     'By this means the pareto--optimal set is approximated by the   '
     'population in the current generation better than in the last   '
     'generations.                                                   '
     'Each individual includes:the objective variable x=(x_1,...,x_n)'
     'the strategy parameter vector s=(s_1,s_2,...,s_n) and the      '
     'vector f_{aux}=[dis,f(x)], that means:                         '
     '                  Ind = (x, s, f_{aux}),                       '
     'Here, the strategy parameter vector s has the same dimension   '
     'as the objective vector x and describes the personal           '
     'experiences of each individual by reproducing its offsprings.  '
     'The variable dis defines the distance between the individual   '
     'and the feasible region.                                       '];

    helpStr{3}=... 
    ['From a randomly chosen parent individual Ind of the current    '
     'population, the mutation is performed on Ind by adding a       '
     'normally distributed random vector N(0, s) with expectation    '
     'zero and standard deviation s to the objective variable x.     ' 
     'It is clear, all offsprings of the mutated individual are in   '
     'the hyperellipsoid with the half--axes (s_1,s_2,...,s_n). To   '
     'decide whether offsprings are viable, all offsprings must be   '
     'compared with their parent individual using the different      '
     'selection schemes.                                             '
     'The efficiency of a mutation is characterized by the number of '
     'its viable offsprings. The self--adaptation of the strategy    '
     'parameters can be performed by rotating hyperellipsoid along   '
     'each coordinate axes, until the biggest number of viable       '
     'offsprings is achieved. By this way, the mutation allows to    '
     'evolve its own strategy parameters during the search so that   '
     'its offsprings can be in the down--climbing direction.         '];        

    helpStr{4}=...
    ['The standard mechanism of the reproduction is the well--known  '
     'two--points--crossover. It is performed on strategy parameters '
     'as well as on the objective variables. In this case, two       '
     'crossover points are chosen at random and sorted into the      '
     'ascending order. Then, the coordinate elements between         '
     'successive crossover points are exchanged between two parents  '
     'to produce two new offsprings. The section between the first   '
     'coordinate element and the first crossover point is not        '
     'exchanged between individuals.                                 '
     'Choosing the better parent individuals is performed by using   '
     'the concept of the pareto--optimality.                         '
     '                                                               '
     'The selection is performed by using the pareto--optimality in  '
     'the objective function space. The algorithm concludes the      '
     'assigning rank 1 to the non--dominated individuals and rank 2  '
     'to the other of the current population.                        '
     '                                                               '
     '                                                               '
     'Have fun!                                                      '
     '                                                               '
     'To Thanh Binh                                                  '] ;        


    TitlePages{1}='Wellcome to the Evolution Strategy';
    TitlePages{2}='Individual Representation';
    TitlePages{3}='Mutation';
    TitlePages{4}='Reproduction and Selection ';
    eshlpfun('About the Evolution Strategy',TitlePages,helpStr);
     

  case 'evoldone',

     mainfud=get(gcf,'UserData');
     aud=mainfud{1}.graphic;
     set(aud(1:4),'Enable','off');
     if mainfud{3}.dim(3)==1,
        [gftmp,ibth]=sort(mainfud{3}.obj(2,:));
        mainfud{3}.x=mainfud{3}.x(:,ibth);mainfud{3}.s=mainfud{3}.s(:,ibth);
        mainfud{3}.obj=mainfud{3}.obj(:,ibth);
     end

     if mainfud{2}.ConstExist,
        if mainfud{3}.ConstSatisfy, 
           resf_txt=' The final population satisfies all restrictions!';
        else
           resf_txt=' The final population does not satisfy all restrictions!';
        end
     else,
        resf_txt='  ';
     end

     if mainfud{3}.generation < mainfud{1}.parameter(17),
        message=str2mat(resf_txt,...
           'Optimization terminated successfully!',...
           'Using ''esdialog'' in the MATLAB Command Window',...
           'or click the ''Dialog''-Button in the main window',...
           'to make a dialogue with the results.',...
           '                      ',...
           'Do you want to save the obtained results?');
     else,
        message=str2mat(resf_txt,...
           'Maximum number of iterations has been exceeded! ',...
           'Using ''esdialog'' in the MATLAB Command Window',...
           'or click the ''Dialog''-Button in the main window',...
           'to make a dialogue with the results.',...
           '                      ',...
           'Do you want to save the obtained results?');
     end
     YesCall=['fud=get(gcf,''UserData'');close(gcf);',...
       'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
       'delete([fud.file.mattmp,''.mat'']);',...
       'essave([fud.file.matend,''.mat'');'];
     NoCall=['fud=get(gcf,''UserData'');close(gcf);',...
       'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
       'delete([fud.file.mattmp,''.mat'']);delete([fud.file.matend,''.mat'']);'];       
     MsgFig=esmsg(message,'Ha ha ha','info',YesCall,NoCall,'Yes','No');
     set(MsgFig,'UserData',mainfud{1});

     save([mainfud{1}.file.matend,'.mat'], 'mainfud');


  case 'evolinfo',
     str_info=str2mat('  Evolution Strategy Toolbox',...
       '  Version 3.0',...
       '  Author: Dr. To Thanh Binh       ',...
       '  Institute of Automation (IFAT)  ',...
       '  University of Magdeburg-Germany ',...
       '  All Rights Reserved. 1993-1996  ');
     esmsg(str_info,'Information','es');


  case 'evolx0',
     choice5('Set a Start Point',260,160,[.4 .8 .8],'off');
     uicontrol(Std,'style','text','pos',[.05 .83 .9 .12],'string','Input the variable x0:',...
       'back',[.4 .8 .8],'fore','red','HorizontalAlignment','left');
     x0=uicontrol(Std,'Style','edit','Pos',[.05 .68 .9 .15],'Back','white');
     uicontrol(Std,'style','text','pos',[.05 .5 .9 .12],'string','The region for x0 (if you know):',...
       'back',[.4 .8 .8],'fore','red','HorizontalAlignment','left');
     x1=uicontrol(Std,'Style','edit','Pos',[.05 .35 .9 .15],'Back','white');
     set(gcf,'UserData',[x0,x1,Par1]);
     uicontrol(Std,'Style','push','String','OK',...
       'Pos',[.4 .05 .2 .15],'Call','evolut(''OKevolx0'');');


  case 'OKevolx0',
     fud=get(gcf,'UserData');mainfud=get(fud(3),'UserData');
     load([mainfud{1}.file.matopt,'.mat']);
     errortxt=[];x=get(fud(1),'string');
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
           mainfud{2}.x=x;mainfud{2}.xrange=xrange;  
           set(fud(3),'Userdata',mainfud);
           close(gcf),
        end,
     else,
        mainfud{2}.x=x;mainfud{2}.xrange=[];  
        set(fud(3),'Userdata',mainfud);
        close(gcf),
     end
     
     
  case 'evoliter',
     choice5('Set a Number of Iterations',220,100,[.4 .8 .8],'off');
     uicontrol(Std,'style','text','pos',[.2 .77 .6 .15],'string','Input the number:',...
       'back',[.4 .8 .8],'fore','red','HorizontalAlignment','left');
     x0b=uicontrol(Std,'Style','edit','Pos',[.2 .45 .6 .3],...
       'String','20','Back','white');
     set(gcf,'UserData',[x0b,Par1]);
     uicontrol(Std,'Style','push','String','OK','Pos',[.4 .1 .2 .25],'Call',[... 
       'fud=get(gcf,''UserData'');mainfud=get(fud(2),''UserData'');',...
       'mainfud{1}.parameter(17)=str2num(get(fud(1),''string''));',...
       'set(fud(2),''UserData'',mainfud);',...
       'clear fud mainfud;close(gcf)']);


  case 'evolopts',
     mainfig=gcf;
     fig=choice5('Optimization Problem Options',600,250,[.4 .8 .8],'off');
     uicontrol('Style','frame','Units','norm','Pos',[.01 .85 .252 .11],'Back',[.5 .5 .5]);
     uicontrol(Std,'Style','push','Pos',[.013 .86 .12 .09],...
       'String','Function:','Back','red','Call','fgenui;');
     FUNb=uicontrol(Std,'Style','edit','Pos',[.136 .86 .12 .09],...
       'String','','Back','white');
     uicontrol('Style','frame','Units','norm','Pos',[.272 .85 .252 .11],...
       'Back',[.5 .5 .5]);
     uicontrol(Std,'Style','text','Pos',[.275 .86 .12 .09],...
       'String','Contour:','Back','y');
     fcontb=uicontrol(Std,'Style','edit','Pos',[.398 .86 .12 .09],...
       'String','','Back','white');

     uicontrol('Style','frame','Units','norm','Pos',[.01 .04 .784 .78],'Back','b');  
     uicontrol(Std,'Style','text','Pos',[.016 .72 .772 .08],...
       'String','Auxiliary Parameters','Back','y');
     uicontrol(Std,'Style','text','Pos',[.016 .61 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter1');
     par(1)=uicontrol(Std,'Style','edit','Pos',[.16 .61 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.016 .48 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter2'); 
     par(2)=uicontrol(Std,'Style','edit','Pos',[.16 .48 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.016 .35 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter3');
     par(3)=uicontrol(Std,'Style','edit','Pos',[.16 .35 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.016 .22 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter4');
     par(4)=uicontrol(Std,'Style','edit','Pos',[.16 .22 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.016 .09 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter5');
     par(5)=uicontrol(Std,'Style','edit','Pos',[.16 .09 .1 .085],...
       'String','','Back','white');

     uicontrol(Std,'Style','text','Pos',[.28 .61 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter6');
     par(6)=uicontrol(Std,'Style','edit','Pos',[.424 .61 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.28 .48 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter7');
     par(7)=uicontrol(Std,'Style','edit','Pos',[.424 .48 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.28 .35 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter8');
     par(8)=uicontrol(Std,'Style','edit','Pos',[.424 .35 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.28 .22 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter9');
     par(9)=uicontrol(Std,'Style','edit','Pos',[.424 .22 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.28 .09 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter10');
     par(10)=uicontrol(Std,'Style','edit','Pos',[.424 .09 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.544 .61 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter11');
     par(11)=uicontrol(Std,'Style','edit','Pos',[.688 .61 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.544 .48 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter12');
     par(12)=uicontrol(Std,'Style','edit','Pos',[.688 .48 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.544 .35 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter13');
     par(13)=uicontrol(Std,'Style','edit','Pos',[.688 .35 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.544 .22 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter14');
     par(14)=uicontrol(Std,'Style','edit','Pos',[.688 .22 .1 .085],...
       'String','','Back','white');
     uicontrol(Std,'Style','text','Pos',[.544 .09 .14 .08],'HorizontalAlignment','left',...
       'String','Parameter15');
     par(15)=uicontrol(Std,'Style','edit','Pos',[.688 .09 .1 .085],...
       'String','','Back','white');

     uirest=uicontrol(Std,'Style','checkbox','String','Restriction','Back','y',...
       'Pos',[.82 .49 .15 .12]);
     uicontrol(Std,'Style','push','String','Iteration','Back','y',...
       'Pos',[.82 .34 .15 .12],'Call',...
       'fud=get(gcf,''UserData'');evolut(''evoliter'',fud(20));');
     uix0=uicontrol(Std,'Style','push','String','Start Point','Back','red','value',0,...
       'Pos',[.82 .19 .15 .12],'Call',...
       'fud=get(gcf,''UserData'');set(fud(19),''Value'',1);evolut(''evolx0'',fud(20));');
     uicontrol(Std,'Style','push','String','Display','Back','y',...
       'Pos',[.82 .04 .15 .12],'Call','fud=get(gcf,''UserData'');evolut(''display'',fud(20));');

     set(fig,'UserData',[FUNb,fcontb,par,uirest,uix0,mainfig]);
     uicontrol(Std,'Style','push','String','OK',...
       'Pos',[.82 .86 .15 .1],'Call','evolut(''OKevolopts'')');

     uicontrol(Std,'Style','push','String','Close',...
       'Pos',[.82 .66 .15 .1],'Call','close(gcf)');


  case 'OKevolopts',
     fud=get(gcf,'UserData');mainfud=get(fud(20),'UserData'); 
     load([mainfud{1}.file.matopt,'.mat']);
     n_par=0; 
     mainfud{2}.fun=get(fud(1),'string');mainfud{2}.fcon=get(fud(2),'String');
     P1=get(fud(3),'string');
     if ~isempty(P1), P1=eval(P1);n_par=1;end;mainfud{2}.p{1}=P1;
     P2=get(fud(4),'string');
     if ~isempty(P2), P2=eval(P2);n_par=2;end;mainfud{2}.p{2}=P2;
     P3=get(fud(5),'string');
     if ~isempty(P3), P3=eval(P3);n_par=3;end;mainfud{2}.p{3}=P3;
     P4=get(fud(6),'string');
     if ~isempty(P4), P4=eval(P4);n_par=4;end;mainfud{2}.p{4}=P4;
     P5=get(fud(7),'string');
     if ~isempty(P5), P5=eval(P5);n_par=5;end;mainfud{2}.p{5}=P5;
     P6=get(fud(8),'string');
     if ~isempty(P6), P6=eval(P6);n_par=6;end;mainfud{2}.p{6}=P6;
     P7=get(fud(9),'string');
     if ~isempty(P7), P7=eval(P7);n_par=7;end;mainfud{2}.p{7}=P7;
     P8=get(fud(10),'string');
     if ~isempty(P8), P8=eval(P8);n_par=8;end;mainfud{2}.p{8}=P8;
     P9=get(fud(11),'string');
     if ~isempty(P9), P9=eval(P9);n_par=9;end;mainfud{2}.p{9}=P9;
     P10=get(fud(12),'string');
     if ~isempty(P10), P10=eval(P10);n_par=10;end;mainfud{2}.p{10}=P10;
     P11=get(fud(13),'string');
     if ~isempty(P11), P11=eval(P11);n_par=11;end;mainfud{2}.p{11}=P11;
     P12=get(fud(14),'string');
     if ~isempty(P12), P12=eval(P12);n_par=12;end;mainfud{2}.p{12}=P12;
     P13=get(fud(15),'string');
     if ~isempty(P13), P13=eval(P13);n_par=13;end;mainfud{2}.p{13}=P13;
     P14=get(fud(16),'string');
     if ~isempty(P14), P14=eval(P14);n_par=14;end;mainfud{2}.p{14}=P14;
     P15=get(fud(17),'string');
     if ~isempty(P15), P15=eval(P15);n_par=15;end;mainfud{2}.p{15}=P15;
     mainfud{2}.numpar=n_par; 
     if get(fud(18),'Value'),
        mainfud{2}.ConstExist=1;
     else,
        mainfud{2}.ConstExist=0;
     end;
     if ~get(fud(19),'Value'),
        mainfud{2}.NewAxesLim=[];
     end,
     set(fud(20),'UserData',mainfud); 
     close(gcf)

 
  case 'display',  
     % Default: Display in the Matlab Command Window and not in the GUI
     choice5('Display Options',300,180,[.4 .8 .8],'off');

     uicontrol(Std,'Style','frame','Pos',[.05 .45 .7 .5]);  
     uicontrol(Std,'Style','text','String',' In Graphic User Interface ',...
       'Pos',[.075 .83 .65 .1],'Fore','red');  

     ck_dy=uicontrol(Std,'Style','checkbox','String','in parameter space ',...
       'Pos',[.075 .68 .65 .12],'HorizontalAlignment','left','Call', [...
       'pl=get(gcf,''UserData'');',...
       'if get(pl(1),''Value'') == 1,set(pl(2),''Value'',0);else,set(pl(1),''Value'',1);end;',...
       'pl(6)=1;set(gcf,''UserData'',pl);clear pl;']);  

     ck_dn=uicontrol(Std,'Style','checkbox','String','in objective function space',...
       'Pos',[.075 .5 .65 .12],'HorizontalAlignment','left','Call', [...
       'pl=get(gcf,''UserData'');',...
       'if get(pl(2),''Value'') == 1,',...
          'set(pl(1),''Value'',0);',   ...
       'else,',...
          'set(pl(2),''Value'',1);',...
       'end;',...
       'pl(6)=2;set(gcf,''UserData'',pl);clear  pl;']);

     uicontrol(Std,'Style','frame','Pos',[.05 .05 .7 .35]); 
     uicontrol(Std,'Style','text','String',' In Matlab Command Window ',...
       'Pos',[.075 .28 .65 .1],'Fore','red');  
     ck_d1y=uicontrol(Std,'Style','checkbox','String','Yes ','Pos',[.15 .1 .2 .12],'Call', [...
       'pl=get(gcf,''UserData'');',...
       'if get(pl(3),''Value'') == 1,set(pl(4),''Value'',0);else,set(pl(3),''Value'',1);end;',...
       'pl(5)=1;set(gcf,''UserData'',pl);clear pl;']);  

     ck_d1n=uicontrol(Std,'Style','checkbox','String','No','Pos',[.45 .1 .2 .12],'Call', [...
       'pl=get(gcf,''UserData'');',...
       'if get(pl(4),''Value'') == 1,',...
         'set(pl(3),''Value'',0);',   ...
       'else,',...
         'set(pl(4),''Value'',1);',...
       'end;',...
       'pl(5)=0;set(gcf,''UserData'',pl);clear  pl;']);

     set(gcf,'UserData',[ck_dy ck_dn ck_d1y ck_d1n 1 0,Par1]); %[1 for command window and 0 for GUI]

     uicontrol(Std,'Style','push','String','OK','Pos',[.8 .8 .16 .15],'Call',[...
       'pl=get(gcf,''UserData'');mainfud=get(pl(7),''UserData'');',...
       'mainfud{1}.parameter(15:16)=pl(5:6);',...
       'set(pl(7),''UserData'',mainfud);',...
       'clear fg pl mainfud;close(gcf)']);

     uicontrol(Std,'Style','push','String','Close',...
       'Pos',[.8 .58 .16 .15],'Call','close(gcf)');


  case 'evolsetp',
     fg=gcf;
     choice5('Set Parameter of Evolution Strategy',500,350,[.4 .8 .8]);
     mainfud=get(fg,'UserData');ES=mainfud{1};
     ButtonH=.0655;HSpace=.008;TextW=.445;NumW=.08;
     uicontrol('style','frame','Units','norm','pos',[.005 .01 TextW+NumW+.01 .98],...
       'Back',[.4 .8 .8]);

     uicontrol(Std,'style','text','pos',[.01 .92 TextW+NumW .05],...
       'Fore','b','Back',[.4 .8 .8],'String','Global Parameters');

     uicontrol(Std,'style','text','pos',[.015 .9-(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Population Size');
     nIv=uicontrol(Std,'Style','edit','Pos',[.45 .91-(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(1)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-2*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Number of Niches');
     nEv=uicontrol(Std,'Style','edit','Pos',[.45 .91-2*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(2)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-3*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Number of Reproductions');
     nFv=uicontrol(Std,'Style','edit','Pos',[.45 .91-3*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(3)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-4*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Number of Mutations');
     nmiv=uicontrol(Std,'Style','edit','Pos',[.45 .91-4*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(4)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-5*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Number of Offspring/Mutation');
     nom=uicontrol(Std,'Style','edit','Pos',[.45 .91-5*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(4)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-6*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Reprod. Choosing factor');
     lAv=uicontrol(Std,'Style','edit','Pos',[.45 .91-6*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(8)),'Back','white');
 
     uicontrol(Std,'style','text','pos',[.01 .9-7*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Mutation Lethalfactor');
     lMv=uicontrol(Std,'Style','edit','Pos',[.45 .91-7*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(10)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-8*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Number of unfeasible Niches');
     UFn=uicontrol(Std,'Style','edit','Pos',[.45 .91-8*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(19)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-9*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Successful Mutation Rate');
     SMr=uicontrol(Std,'Style','edit','Pos',[.45 .91-9*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(18)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-10*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Relaxing Rate of feasible Region');
     RRF=uicontrol(Std,'Style','edit','Pos',[.45 .91-10*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(20)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-11*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Dispersion of the population');
     dispersion=uicontrol(Std,'Style','edit','Pos',[.45 .91-11*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(14)),'Back','white');

     uicontrol(Std,'style','text','pos',[.01 .9-12*(ButtonH+HSpace) TextW ButtonH],...
       'Fore','black','Back',[.4 .8 .8],...
       'HorizontalAlignment','left','String','Number of the generations');
     iter=uicontrol(Std,'Style','edit','Pos',[.45 .91-12*(ButtonH+HSpace) NumW ButtonH],...
       'String',num2str(ES.parameter(17)),'Back','white');

     ButtonH=.08;
     uicontrol('style','frame','Units','norm','Back',[.4 .8 .8],...
       'pos',[.55 .99-5.7*(ButtonH+HSpace)-.02 TextW-.01 5.7*(ButtonH+HSpace)+.02]);
     uicontrol(Std,'style','text','pos',[.56 .92 TextW-.04 .05],...
       'Fore','b','Back',[.4 .8 .8],'String','Algorithms');

     AlgList='Set Population|Standard|Integer|Manual';
     SetPopAlg=uicontrol(Std,'style','popup','pos',[.56 .99-1.7*(ButtonH+HSpace) TextW-.03 ButtonH],...
       'Back',[.4 .8 .8],'String',AlgList);

     AlgList='Mutation Algorithm|Self Adaptation|Integer';
     MutAlg=uicontrol(Std,'style','popup','pos',[.56 .99-2.7*(ButtonH+HSpace) TextW-.03 ButtonH],...
       'Back',[.4 .8 .8],'String',AlgList);

     AlgList=['Reproduction Algorithm|Combination|Multi-Parents-Cross-Over|Arithmetic Cross-Over|',...
           'Extended-Line-Cross-Over|Heuristic|IntegerCrossOver'];
     RepAlg=uicontrol(Std,'style','popup','pos',[.56 .99-3.7*(ButtonH+HSpace) TextW-.03 ButtonH],...
       'Back',[.4 .8 .8],'String',AlgList);

     AlgList='Selection Algorithm|Using Fitness';
     SelAlg=uicontrol(Std,'style','popup','pos',[.56 .99-4.7*(ButtonH+HSpace) TextW-.03 ButtonH],...
       'Back',[.4 .8 .8],'String',AlgList);

     NicheAlg=uicontrol(Std,'style','check','pos',[.56 .99-5.7*(ButtonH+HSpace) TextW-.03 ButtonH],...
       'Back',[.4 .8 .8],'String','Niche Method');

     distr=uicontrol(Std,'style','popup','pos',[.56 .38 TextW-.03 ButtonH],...
       'Back',[.4 .8 .8],'string',['Distribution Option|Normal|Uniform']);

     uicontrol('style','frame','Units','norm','pos',[.55 .01 TextW-.01 .35],...
       'Back',[.4 .8 .8]);
     fud=[nIv,nEv,nFv,nmiv,lAv,lMv,UFn,SMr,RRF,MutAlg,RepAlg,SelAlg,fg,...
       dispersion,distr,nom,iter,SetPopAlg,NicheAlg];
     set(gcf,'UserData',fud);
     uicontrol(Std,'Style','push','String','OK',...
       'Pos',[.7 .05 .17 .1],'callback','evolut(''OKevolsetp'');');

     uicontrol(Std,'Style','push','String','Close',...
       'Pos',[.7 .2 .17 .1],'callback','close(gcf)');
     set(SetPopAlg,'val',ES.algorithm.legend(1));
     set(MutAlg,'val',ES.algorithm.legend(2));
     set(RepAlg,'val',ES.algorithm.legend(3));
     set(SelAlg,'val',ES.algorithm.legend(4));
     set(NicheAlg,'val',ES.algorithm.niche);


  case 'OKevolsetp',
     bth=get(gcf,'UserData'); 
     mainfud=get(bth(13),'UserData');
     mainfud{1}.parameter(1)=str2num(get(bth(1),'string'));
     mainfud{1}.parameter(2)=str2num(get(bth(2),'string'));
     mainfud{1}.parameter(3)=str2num(get(bth(3),'string'));
     mainfud{1}.parameter(4)=str2num(get(bth(4),'string'));
     lambdaA=str2num(get(bth(5),'string'));  
     if (lambdaA>1), lambdaA=1; end;
     if (lambdaA<0), lambdaA=0; end;

     lambdaM=str2num(get(bth(6),'string'));  
     if (lambdaM>1), lambdaM=1; end;
     if (lambdaM<0), lambdaM=0; end;

     UFnumber=str2num(get(bth(7),'string'));  
     if (UFnumber <= 0), UFnumber=0; end;
     SMr=str2num(get(bth(8),'string'));  
     RRF=str2num(get(bth(9),'string'));  
     disp=str2num(get(bth(14),'string'));  
     nom=str2num(get(bth(16),'string'));  
     iter=str2num(get(bth(17),'string'));index=[5,8,10,14,17,18,19,20];  

     mainfud{1}.parameter(index)=[nom,lambdaA,lambdaM,disp,iter,SMr,UFnumber,RRF];
     val= get(bth(10),'Value');
     if val==2,
        mainfud{1}.algorithm.mutation='SelfAdapt';
     elseif val==3,
        mainfud{1}.algorithm.mutation='Integer';
     else,
        mainfud{1}.algorithm.mutation='SelfAdapt';
     end,
     mainfud{1}.algorithm.legend(2)=val;
     val= get(bth(11),'Value');
     if val==2,
        mainfud{1}.algorithm.reproduction='Combi';
     elseif val==3,
        mainfud{1}.algorithm.reproduction='MultiParent';
     elseif val==4,
        mainfud{1}.algorithm.reproduction='Arithmetic';
     elseif val==5,
        mainfud{1}.algorithm.reproduction='ExtendedLine';
     elseif val==6,
        mainfud{1}.algorithm.reproduction='Heuristic';
     elseif val==7,
        mainfud{1}.algorithm.reproduction='IntegerCrossOver';
     else,
        mainfud{1}.algorithm.reproduction='Combi';
     end,
     mainfud{1}.algorithm.legend(3)=val;

     val= get(bth(12),'Value');
     if val==2,
        mainfud{1}.algorithm.selection='Fitness';
     else,
        mainfud{1}.algorithm.selection='Fitness';
     end,
     mainfud{1}.algorithm.legend(4)=val;

     val= get(bth(18),'Value');
     if val==2,
        mainfud{1}.algorithm.setpop='Standard';
     elseif val==3,
        mainfud{1}.algorithm.setpop='Integer';
     elseif val==4,
        mainfud{1}.algorithm.setpop='Manual';
     else,
        mainfud{1}.algorithm.setpop='Standard';
     end,
     mainfud{1}.algorithm.legend(1)=val;

     val= get(bth(19),'Value');
     if val==1,
        mainfud{1}.algorithm.niche=1;
     else,
        mainfud{1}.algorithm.niche=0;
     end

     val= get(bth(15),'Value');
     if val==3,
        mainfud{1}.parameter(13)=1;
     else,
        mainfud{1}.parameter(13)=2;
     end,
     set(bth(13),'UserData',mainfud);
     close(gcf); 


  case 'goon',
     fg=gcf;
     choice5('Set a Number of Iterations',220,100,[.4 .8 .8],'off');
     uicontrol(Std,'style','text','pos',[.2 .77 .6 .15],'string','Input the number:',...
       'back',[.4 .8 .8],'fore','red','HorizontalAlignment','left');
     x0b=uicontrol(Std,'Style','edit','Pos',[.2 .45 .6 .3],...
       'String','20','Back','white');
     set(gcf,'UserData',[x0b,fg]);
     uicontrol(Std,'Style','push','String','OK','Pos',[.4 .1 .2 .25],'Call',[... 
       'fud=get(gcf,''UserData'');mainfud=get(fud(2),''UserData'');',...
       'mainfud{1}.parameter(17)=mainfud{3}.generation+str2num(get(fud(1),''string''));',...
       'close(gcf);',...
       'set(mainfud{1}.graphic([1,2,4]),''Enable'',''off'');',...
       'set(mainfud{1}.graphic(3),''Enable'',''on'');',...
       'mainfud{3}=mainprog(mainfud{2},mainfud{1},mainfud{3});',...
       'set(mainfud{1}.graphic([1,2,4]),''Enable'',''on'');',...
       'set(mainfud{1}.graphic(3),''Enable'',''off'');',...
       'set(fud(2),''UserData'',mainfud);clear fud;']);


  case 'another',
     fg=gcf; mainfud=get(fg,'UserData');
     choice5('Options for the next optimization',300,180,[.4 .8 .8],'off');
     uicontrol(Std,'style','text','pos',[.03 .87 .5 .1],'HorizontalAlignment','left',...
       'Fore','black','String','Number of Iterations');
     maxiter=uicontrol(Std,'Style','edit','Pos',[.55 .87 .42 .1],...
       'String',num2str(mainfud{1}.parameter(17)),'Back','white');

     uicontrol(Std,'style','text','pos',[.03 .75 .5 .11],'HorizontalAlignment','left',...
       'Fore','black','String','Name of mat-file');
     matfile=uicontrol(Std,'Style','edit','Pos',[.55 .75 .42 .11],...
       'String',[mainfud{1}.file.matend,'.mat'],'Back','white');

     uicontrol('style','frame','Units','norm','pos',[.03 .2 .94 .52]);

     uicontrol(Std,'style','text','pos',[.033 .62 .6 .09],'HorizontalAlignment','left',...
       'Fore','red','String','Do you want to plot?');
 

     ck_dn=uicontrol(Std,'Style','checkbox','String','Not plot ',...
       'Pos',[.07 .53 .88 .1],'HorizontalAlignment','left','Call', [...
       'pl=get(gcf,''UserData'');',...
       'if get(pl(1),''Value'') == 1,',...
          'set(pl(2),''Value'',0);set(pl(3),''Value'',0);',...
       'else,',...
          'set(pl(1),''Value'',1);end;',...
       'pl(4)=0;set(gcf,''UserData'',pl);clear pl;']);  

     ck_dy1=uicontrol(Std,'Style','checkbox','String','Plot in the parameter space',...
       'Pos',[.07 .43 .88 .1],'HorizontalAlignment','left','Call', [...
       'pl=get(gcf,''UserData'');',...
       'if get(pl(2),''Value'') == 1,',...
          'set(pl(1),''Value'',0);set(pl(3),''Value'',0);',...
       'else,',...
          'set(pl(2),''Value'',1);end;',...
       'pl(4)=1;set(gcf,''UserData'',pl);clear pl;']);  

     ck_dy2=uicontrol(Std,'Style','checkbox','String','Plot in the objective function space',...
       'Pos',[.07 .33 .88 .1],'HorizontalAlignment','left','Call', [...
       'pl=get(gcf,''UserData'');',...
       'if get(pl(3),''Value'') == 1,',...
          'set(pl(1),''Value'',0);set(pl(2),''Value'',0);',...
       'else,',...
          'set(pl(3),''Value'',1);end;',...
       'pl(4)=2;set(gcf,''UserData'',pl);clear pl;']);

     uicontrol(Std,'style','text','pos',[.07 .21 .3 .1],'HorizontalAlignment','left',...
       'Fore','black','String','New axes');
     axesq=uicontrol(Std,'Style','edit','Pos',[.4 .21 .55 .1],...
       'String','auto','Back','white');


     set(gcf,'UserData',[ck_dn ck_dy1 ck_dy2 0 maxiter matfile axesq fg]); 

     uicontrol(Std,'Style','push','String','OK','Pos',[.3 .03 .15 .1],'Call',[...
       'pl=get(gcf,''UserData'');plotq=pl(4);',...
       'maxiter=str2num(get(pl(5),''string''));matfile=get(pl(6),''String'');',...  
       'axesq=get(pl(7),''String'');close(gcf),',...
       'evolut(''doanother'',{pl(8),maxiter,matfile,plotq,axesq});',...
       'clear pl matfile plotq axesq maxiter;']);

     uicontrol(Std,'Style','push','String','Close',...
       'Pos',[.55 .03 .15 .1],'Call','close(gcf)');



  case 'doanother1',
     % for security the display should be performed in new figure, because
     % the old graphic handles can be not identical to the new ones.

     if ~isstr(Par1{3}),
        error('Imcompatible inputs?');return
     end
     if ~exist(Par1{3},'file'),
        esmsg(str2mat([' No file named ',Par1{3}],...
                    ' We have not enough data to go on',...
                    ' Good bye.'),'Error','error');
        return,
     end

     load(Par1{3});
     [NewFunName,Times] =fcreate(mainfud{1}.file.funtmp,'m');
     mainfud{1}.file.funtmp  = NewFunName;
     if Times,
        mainfud{1}.file.mattmp  = [mainfud{1}.file.mattmp,num2str(Times)]; 
        mainfud{1}.file.matopt  = [mainfud{1}.file.matopt,num2str(Times)]; 
        mainfud{1}.file.matend  = [mainfud{1}.file.matend,num2str(Times)]; 
     end

     funcgen(mainfud{1}.file.funtmp,mainfud{2}.fun,mainfud{2}.xrange,mainfud{2}.numpar,mainfud{2}.p);
     
     mainfud{1}.parameter(17)=mainfud{3}.generation+Par1{2};

     if Par1{4},  
        mainfud{1}.parameter(16)=Par1{4}+30;
     else,
        mainfud{1}.parameter(16)=0;
     end
     x=mainfud{2}.x(:);
     gui_disp=mainfud{1}.parameter(16);
     mf=mainfud{3}.dim(3);

     if gui_disp,
        mainfud{1}.graphic(11)=choice5('Display for the Evolution Strategy',500,350,[.8 .8 .8]);
        axes('units','norm','pos',[.1 .1 .8 .8],'clipping','on',...
          'Xlimmode','manual','Ylimmode','manual');

        mainfud{1}.graphic(7)=uicontrol(Std,'Style','text','pos',[.84 .85 .057 .044],...
          'String',num2str(mainfud{3}.generation),'Fore','b');

        if length(mainfud{2}.fcon), 
           feval(mainfud{2}.fcon);axesq=[];
           if (gui_disp==31),
              plot(x(1),x(2),'ro');text(x(1),x(2),'Start Point');
           elseif (gui_disp==32),
              f=feval(mainfud{1}.file.funtmp,mainfud{2}.x,mainfud{2}.p);
              if mf ==2,
                 plot(f(2),f(3),'ro');text(f(2),f(3),'Start Point');
              elseif mf>2,
                 plot3(f(2),f(3),f(4),'ro');text(f(2),f(3),f(4),'Start Point');
              end
           end
           hold on 
        end
        mainfud{3}.plothandle=guidisp1(gui_disp,mainfud{3}.x,mainfud{3}.obj,Par1{5});
        set(gcf,'UserData',mainfud,'CloseRequestFcn',[...
         'mainfud=get(gcf,''UserData'');delete([mainfud{1}.file.funtmp,''.m'']);',...
         'delete([mainfud{1}.file.mattmp,''.mat'']);delete([mainfud{1}.file.matopt,''.mat'']);',...
         'delete([mainfud{1}.file.matend,''.mat'']);delete(get(0,''CurrentFigure''));']);

     else
        mainfud{3}.plothandle=[];
     end

     mainfud{3}=mainprog(mainfud{2},mainfud{1},mainfud{3});

     if mf==1,
        [gftmp,ibth]=sort(mainfud{3}.obj(2,:));
        mainfud{3}.x=mainfud{3}.x(:,ibth);mainfud{3}.s=mainfud{3}.s(:,ibth);
        mainfud{3}.obj=mainfud{3}.obj(:,ibth);
     end

     if mainfud{2}.ConstExist,
        if mainfud{3}.ConstSatisfy, 
           resf_txt='The final population satisfies all restrictions!';
        else
           resf_txt='The final population does not satisfy all restrictions!';
        end
     else,
        resf_txt=' ';
     end
     if mainfud{3}.generation < mainfud{1}.parameter(17),
        message=str2mat(resf_txt,...
           'Optimization terminated successfully!',...
           'Using ''esdialog'' in the MATLAB Command Window',...
           'or click the ''Dialog''-Button in the main window',...
           'to make a dialogue with the results.',...
           '                      ',...
           'Do you want to save the obtained results?');
     else,
        message=str2mat(resf_txt,...
           'Maximum number of iterations has been exceeded! ',...
           'Using ''esdialog'' in the MATLAB Command Window',...
           'or click the ''Dialog''-Button in the main window',...
           'to make a dialogue with the results.',...
           '                      ',...
           'Do you want to save the obtained results?');
     end
     YesCall=['fud=get(gcf,''UserData'');close(gcf);',...
       'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
       'delete([fud.file.mattmp,''.mat'']);',...
       'essave([fud.file.matend,''.mat'');'];
     NoCall=['fud=get(gcf,''UserData'');close(gcf);',...
       'delete([fud.file.funtmp,''.m'']);delete([fud.file.matopt,''.mat'']);',...
       'delete([fud.file.mattmp,''.mat'']);delete([fud.file.matend,''.mat'']);'];       
     MsgFig=esmsg(message,'Ha ha ha','info',YesCall,NoCall,'Yes','No');
     set(MsgFig,'UserData',mainfud{1});

     save([mainfud{1}.file.matend,'.mat'], 'mainfud');
     

  case 'doanother',
     % Display also in the main figure of the Evolution Strategy

     if ~isstr(Par1{3}),
        error('Imcompatible inputs?');return
     end
     if ~exist(Par1{3},'file'),
        esmsg(str2mat([' No file named ',Par1{3}],...
                    ' We have not enough data to go on',...
                    ' Good bye.'),'Error','error');
        return,
     end

     load(Par1{3});
     [NewFunName,Times] =fcreate(mainfud{1}.file.funtmp,'m');
     mainfud{1}.file.funtmp  = NewFunName;
     if Times,
        mainfud{1}.file.mattmp  = [mainfud{1}.file.mattmp,num2str(Times)]; 
        mainfud{1}.file.matopt  = [mainfud{1}.file.matopt,num2str(Times)]; 
        mainfud{1}.file.matend  = [mainfud{1}.file.matend,num2str(Times)]; 
     end

     funcgen(mainfud{1}.file.funtmp,mainfud{2}.fun,mainfud{2}.xrange,mainfud{2}.numpar,mainfud{2}.p);
     
     mainfud{1}.parameter(17)=mainfud{3}.generation+Par1{2};
     mainfud{1}.parameter(16)=Par1{4};
     gui_disp=Par1{4};

     x=mainfud{2}.x(:);
     mf=mainfud{3}.dim(3);

     if gui_disp,
        CurrentMainFud=get(gcf,'UserData');
        mainfud{1}.graphic=CurrentMainFud{1}.graphic;
        set(mainfud{1}.graphic(1:7),'visible','on');
        set(mainfud{1}.graphic([1,2,4]),'enable','on');
        set(mainfud{1}.graphic(3),'enable','off');
        set(mainfud{1}.graphic(7),'string',num2str(mainfud{3}.generation));
        axesq='auto';
        set(mainfud{1}.graphic(9),'visible','on');
        if length(mainfud{2}.fcon), 
           feval(mainfud{2}.fcon);axesq=[];
           if (gui_disp==1),
              plot(x(1),x(2),'ro');text(x(1),x(2),'Start Point');
           elseif (gui_disp==2),
              f=feval(mainfud{1}.file.funtmp,mainfud{2}.x,mainfud{2}.p);
              if mf ==2,
                 plot(f(2),f(3),'ro');text(f(2),f(3),'Start Point');
              elseif mf>2,
                 plot3(f(2),f(3),f(4),'ro');text(f(2),f(3),f(4),'Start Point');
              end
           end
           hold on 
        end
        mainfud{3}.plothandle=guidisp1(gui_disp,mainfud{3}.x,mainfud{3}.obj,Par1{5});
        set(gcf,'UserData',mainfud);

     else
        mainfud{3}.plothandle=[];
     end

     mainfud{3}=mainprog(mainfud{2},mainfud{1},mainfud{3});
     

  case 'dialog',
     choice5('Choose a mat-file',220,100,[.4 .8 .8],'off');
     uicontrol(Std,'style','text','pos',[.1 .77 .8 .15],'string','Input a name:',...
       'back',[.4 .8 .8],'fore','red','HorizontalAlignment','left');
     name=uicontrol(Std,'Style','edit','Pos',[.1 .45 .8 .3],...
       'String','','Back','white');
     set(gcf,'UserData',name);
     uicontrol(Std,'Style','push','String','OK','Pos',[.6 .06 .2 .25],'Call',[... 
       'name=get(get(gcf,''UserData''),''string'');close(gcf);',...
       'esdialog(''init'',name);']);

     uicontrol(Std,'Style','push','String','Close','Pos',[.2 .06 .2 .25],'Call','close(gcf);');


end % switch


