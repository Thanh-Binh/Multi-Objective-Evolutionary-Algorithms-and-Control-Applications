function demolist(action,Param1)
% demolist(action,Param1)
% This function contains a list of the demonstrations
% for the Evolution Strategy Toolbox. 
%
% This function is not intended to be used directly
% by users.

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin < 2, error('Two inputs at least required?'); end


if strcmp(action(1:4),'init'),

   % Get a good font for this platform.
   [fname,fsize] = bestfont(computer);
   mainfud=get(Param1,'UserData');

   if length(mainfud{1}.graphic) > 11,
      DemoFig=mainfud{1}.graphic(12);
   else,
      DemoFig=[];
   end 
   if isempty(DemoFig),

      mainfud{1}.graphic(12)=choice5('Demonstration Examples',500,400,[.4 .8 .8],'on');

      ScalarDemoList=str2mat('Rastrigin (20)','Griewangk',...
        'Constr-Banana','Constr-SHCB','Constr-Mmodal','Constr-Mmodal1',...
        'Mi-TestCase 1','Mi-TestCase 2','Mi-TestCase 3','Mi-TestCase 4','Mi-TestCase 5',...
        'Mi-TestCase 6','Mi-TestCase 7','Mi-TestCase 8','Mi-TestCase 9','Mi-TestCase 10');

      MOIDemoList=str2mat('NLINEQ (30)','NLEQ (2)','NLEQ1 (30)','NLINEQ1 (30)','Banana','SHCB','Multimodal','Michal2');

      VecDemoList=str2mat('Biobjective','Multiobjective 1','Multiobjective 2','Oscyzka',...
        'MOBES 1','MOBES 2');

      NumberScalarDemo=size(ScalarDemoList,1);
      NumberMOIDemo=size(MOIDemoList,1);
      NumberVecDemo=size(VecDemoList,1);

      FrameW=.32;
      FrameH=.97;
      ButtonW=.28;
      ButtonH=.05;
      FrameHDist=(1-3*FrameW)/4;
      FrameVDist=(1-FrameH)/2;
      Button2Frame=(FrameW-ButtonW)/2;
      ButtonDist=.002;

      UpperPosButton=FrameH+FrameVDist-3*ButtonDist-ButtonH;
      for i=1:3,
         if i==1,
            Str='Scalar Opt.';
         elseif i==2,
            Str='Region Search';
         else,
            Str='MultiObjective Opt.';
         end
         FramePos=[FrameHDist + (i-1)*(FrameW+FrameHDist), FrameVDist, FrameW, FrameH];
         uicontrol('Style','frame','units','norm','pos',FramePos);
         TextPos=[FrameHDist + Button2Frame+(i-1)*(FrameW+FrameHDist), UpperPosButton,...
               ButtonW, ButtonH];
         uicontrol('Style','text','units','norm','pos',TextPos,'String',Str,...
            'FontName',fname,'FontSize',fsize,'Fore','b');
      end
 
      UpperPosButton=UpperPosButton-ButtonH;
      
      for i=1:NumberScalarDemo,
          strtmp=deblank(ScalarDemoList(i,:));
          Postmp=[FrameHDist+Button2Frame,UpperPosButton-(i-1)*(ButtonH+ButtonDist),ButtonW, ButtonH];
          Th(i)=uicontrol('Style','push','units','norm','pos',Postmp,'String',strtmp,'UserData',100+i,...
             'FontName',fname,'FontSize',fsize,'call',...
             ['demolist(''call'',',num2str(i+100),');']);
      end
      for i=1:NumberMOIDemo,
          strtmp=deblank(MOIDemoList(i,:));
          Postmp=[FrameHDist+Button2Frame+FrameW+FrameHDist,...
              UpperPosButton-(i-1)*(ButtonH+ButtonDist),ButtonW, ButtonH];
          Ho(i)=uicontrol('Style','push','units','norm','pos',Postmp,'String',strtmp,'UserData',200+i,...
             'FontName',fname,'FontSize',fsize,'call',...
             ['demolist(''call'',',num2str(i+200),');']);
      end
      for i=1:NumberVecDemo,
          strtmp=deblank(VecDemoList(i,:));
          Postmp=[FrameHDist+Button2Frame+2*(FrameW+FrameHDist),...
              UpperPosButton-(i-1)*(ButtonH+ButtonDist),ButtonW, ButtonH];
          Bi(i)=uicontrol('Style','push','units','norm','pos',Postmp,'String',strtmp,'UserData',300+i,...
             'FontName',fname,'FontSize',fsize,'call',...
             ['demolist(''call'',',num2str(i+300),');']);
      end 
      set(mainfud{1}.graphic(11),'UserData',mainfud);    
      set(gcf,'UserData',[mainfud{1}.graphic(11),Th,Ho,Bi]);
   else,
      figure(DemoFig);
   end

elseif strcmp(action,'call'),

     fud=get(gcf,'UserData');
     Buttons=fud(2:end);mainfud=get(fud(1),'UserData');
     for i=1:length(Buttons),
        if get(Buttons(i),'UserData')==Param1,
           set(Buttons,'fore','black');
           set(Buttons(i),'fore','r');
        end
     end
     clear([mainfud{1}.file.funtmp,'.m']);
     mainfud{2}.p          = [];
     mainfud{2}.xrange     = [];
     mainfud{2}.NewAxesLim = [];
     mainfud{2}.numpar     = 0;

     % For scalar Optimization
     if  Param1==101, % Rastrigin's Function 
        mainfud{2}.fun='ofun8';mainfud{2}.fcon='';
        mainfud{1}.parameter(15:17)=[1,0,1000];k=20;
        mainfud{2}.xrange=[-33*ones(1,k);33*ones(1,k)];
        mainfud{2}.x=32*ones(1,k);mainfud{2}.ConstExist=0; 

     elseif  Param1==102 % Griefangk 
        mainfud{2}.fun='ofun4';mainfud{2}.fcon='cont4';
        mainfud{1}.parameter(14:17)=[10,1,1,100];mainfud{2}.xrange=[];
        mainfud{2}.x=[-5000,5000];mainfud{2}.ConstExist=0;

     elseif  Param1==103,      % Banana with moving boundaries
        mainfud{2}.fun='rofun';mainfud{2}.fcon='rcont';
        mainfud{1}.parameter(15:17)=[0,1,40];mainfud{2}.NewAxesLim=[-3 3 -1.5 4.5];
        mainfud{2}.x=[-6,-1];mainfud{2}.ConstExist=1;

     elseif  Param1==104,  %Six Hump Camel Back with moving boundaries
        mainfud{2}.fun='rofun1';mainfud{2}.fcon='rcont1';
        mainfud{1}.parameter(15:17)=[0,1,40];mainfud{2}.NewAxesLim=[-2.5 2.5 -1.5 1.5];
        mainfud{2}.x=[-4,-4];mainfud{2}.ConstExist=1;

     elseif  Param1==105,  %mmodal with moving boundaries
        mainfud{2}.fun='rofun2';mainfud{2}.fcon='rcont2';
        mainfud{1}.parameter(15:17)=[0,1,40];mainfud{2}.NewAxesLim=[0 6 0 6];
        mainfud{2}.x=[-1,-1];mainfud{2}.ConstExist=1;

     elseif  Param1==106,  %mmodal1 with moving boundaries 
        mainfud{2}.fun='rofun21';mainfud{2}.fcon='rcont21';
        mainfud{1}.parameter(15:17)=[0,1,40];mainfud{2}.NewAxesLim=[0 6 12 18];
        mainfud{2}.x=[15,1];mainfud{2}.ConstExist=1;

     elseif  Param1==107, % Test Case 1 of Michalevicz
                          % global solution is [ones(1,9),3,3,3,1] and fmin=-15;
        mainfud{2}.fun='m96g1';mainfud{2}.fcon='';
        mainfud{1}.parameter(14:17)=[5,1,0,1000];
        mainfud{2}.xrange=[zeros(1,13);[ones(1,9),10,10,10,1]];
        mainfud{2}.x=ones(1,13);mainfud{2}.ConstExist=1;

     elseif  Param1==108, % Test Case 2 of Michalevicz
        mainfud{2}.fun='m96g2';mainfud{2}.fcon='';
        mainfud{1}.parameter(14:17)=[5,1,0,1000];P1=20;
        mainfud{2}.xrange=[zeros(1,P1);10*ones(1,P1)];
        mainfud{2}.x=zeros(1,P1);mainfud{2}.ConstExist=1;

     elseif  Param1==109, % Test Case 3 of Michalevicz
        mainfud{2}.fun='m96g3';mainfud{2}.fcon='m96g3c';
        mainfud{1}.parameter(14:17)=[5,1,1,1000];P1=2;
        mainfud{2}.xrange=[zeros(1,P1);ones(1,P1)];
        mainfud{2}.x=zeros(1,P1);mainfud{2}.ConstExist=1;

     elseif  Param1==110, % Test Case 4 of Michalevicz
        mainfud{2}.fun='m96g4';mainfud{2}.fcon='';
        mainfud{1}.parameter(14:17)=[5,1,0,1000];
        mainfud{2}.xrange=[78 33 27 27 27 ;102 45 45 45 45];
        mainfud{2}.x=30*ones(1,5);mainfud{2}.ConstExist=1;

     elseif  Param1==111, % Test Case 5 of Michalevicz
        mainfud{2}.fun='m96g5';mainfud{2}.fcon='';
        mainfud{1}.parameter(14:17)=[5,1,0,1000]; 
        mainfud{2}.xrange=[0 0 -.55 -.55 ;1200 1200 .55 .55];
        mainfud{2}.x=[679.9453 1026.067 .118876 -.3962336];mainfud{2}.ConstExist=[1 0];

     elseif  Param1==112, % Test Case 6 of Michalevicz
        mainfud{2}.fun='m96g6';mainfud{2}.fcon='m96g6c';
        mainfud{2}.NewAxesLim=[13.5 15.5 0 10];
        mainfud{1}.parameter(15:17)=[1,1,1000]; mainfud{2}.xrange=[13 0;100 100];
        mainfud{2}.x=[20.1 5.84];mainfud{2}.ConstExist=1;

     elseif  Param1==113, % Test Case 7 of Michalevicz
        mainfud{2}.fun='m96g7';mainfud{2}.fcon='';
        mainfud{1}.parameter(14:17)=[1,1,0,1000];
        mainfud{2}.xrange=10*[-ones(1,10);ones(1,10)];
        mainfud{2}.x=zeros(1,10);mainfud{2}.ConstExist=1;

     elseif  Param1==114, % Test Case 8 of Michalevicz
        mainfud{2}.fun='m96g8';mainfud{2}.fcon='m96g8c';
        mainfud{1}.parameter(14:17)=[.5,1,1,500];mainfud{2}.xrange=[0 0;10 10];
        mainfud{2}.x=zeros(1,2);mainfud{2}.ConstExist=1;

     elseif  Param1==115, %  Test Case 9 of Michalevicz
        mainfud{2}.fun='m96g9';mainfud{2}.fcon=' ';mainfud{2}.xrange=10*[-ones(1,7);ones(1,7)];
        mainfud{1}.parameter(15:17)=[1,0,1000];
        mainfud{2}.x=zeros(1,7);mainfud{2}.ConstExist=1;

     elseif  Param1==116, %  Test Case 10 of Michalevicz & Function 3 of Joines
        mainfud{2}.fun='m96g10';mainfud{2}.fcon=' ';mainfud{2}.xrange=[[100 1000 1000 10*ones(1,5)];[1e+4*ones(1,3),1e+3*ones(1,5)]];
        mainfud{1}.parameter(15:17)=[1,0,1000];
        mainfud{2}.x=ones(1,8);mainfud{2}.ConstExist=1;

     elseif  Param1==117, % Test Case 3 of Michalevicz-Schoenauer
        mainfud{2}.fun='michal4';mainfud{2}.fcon=' ';P1=5;
        mainfud{2}.xrange=[zeros(1,P1);ones(1,P1)];
        mainfud{1}.parameter(15:17)=[1,0,300];
        mainfud{2}.x=ones(1,P1);mainfud{2}.ConstExist=1;


     % For Feasible Region Search
     elseif  Param1==201, % MOI-test1
        mainfud{2}.fun='search1';mainfud{2}.fcon='';  %rho=1e-4% for P1=2
        mainfud{1}.parameter(15:17)=[1,0,5000];P1=30;P2=100;
        mainfud{2}.xrange=[zeros(1,P1);P2*ones(1,P1)];
        mainfud{2}.x=P2*ones(1,P1);mainfud{2}.ConstExist=1;
        mainfud{2}.numpar=2;
        mainfud{2}.p{1}=P1;mainfud{2}.p{2}=P2;
     elseif  Param1==202, % MOI-test2
        mainfud{2}.fun='search2';mainfud{2}.fcon='';
        mainfud{1}.parameter(15:17)=[1,0,400];P1=10;P2=100;
        mainfud{2}.x=.9*P2*ones(1,P1);mainfud{2}.ConstExist=1;
     elseif  Param1==203, % MOI-test21
        mainfud{2}.fun='search3';mainfud{2}.fcon='';
        mainfud{1}.parameter(15:17)=[1,0,400];P1=30;P2=100;
        mainfud{2}.x=.9*P2*ones(1,P1);mainfud{2}.ConstExist=1;
     elseif  Param1==204, % MOI-test3
        mainfud{2}.fun='search4';mainfud{2}.fcon='';   % rho=0 for 1e+6 tests
        mainfud{1}.parameter(15:17)=[1,0,1000];P1=30;P2=100;
        mainfud{2}.xrange=[zeros(1,P1);P2*ones(1,P1)];
        mainfud{2}.x=P2*ones(1,P1);mainfud{2}.ConstExist=1;mainfud{2}.numpar=2;
        mainfud{2}.p{1}=P1;mainfud{2}.p{2}=P2;
 
     elseif  Param1==205,
        mainfud{2}.fun='ofun';mainfud{2}.fcon='cont';
        mainfud{1}.parameter(15:17)=[0,1,40];
        mainfud{2}.x=[-2.6,-1];mainfud{2}.ConstExist=0;

     elseif  Param1==206, % SHCB
        mainfud{2}.fun='ofun1';mainfud{2}.fcon='cont1';
        mainfud{1}.parameter(15:17)=[0,1,40];
        mainfud{2}.x=[-2.5,1.5];mainfud{2}.ConstExist=0;

     elseif  Param1==207, % mmodal
        mainfud{2}.fun='ofun2';mainfud{2}.fcon='cont2';
        mainfud{1}.parameter(15:17)=[0,1,40];
        mainfud{2}.x=[1,1];mainfud{2}.ConstExist=0;

     elseif  Param1==208, % 
        mainfud{2}.fun='michal2';mainfud{2}.fcon='micont2';mainfud{2}.xrange=[0 0;3 4];
        mainfud{1}.parameter(15:17)=[1,1,300];
        mainfud{2}.x=zeros(1,2);mainfud{2}.ConstExist=1;


     % For MultiObjective Optimization
     elseif  Param1==301, % Bi-obj
        mainfud{2}.fun='ofun3';mainfud{2}.fcon='cont3';
        mainfud{1}.parameter(15:17)=[1,2,40];
        mainfud{2}.x=[-5,10];mainfud{2}.ConstExist=0;mainfud{2}.xrange=[-5 -5;10 10];

     elseif  Param1==302,  % 
        mainfud{2}.fun='ofun5';mainfud{2}.fcon='cont5';
        mainfud{1}.parameter(15:17)=[0,2,200];
        mainfud{2}.x=[1,1];mainfud{2}.ConstExist=1;

     elseif  Param1==303,  % 
        mainfud{2}.fun='ofun6';mainfud{2}.fcon='cont6';
        mainfud{2}.x=[10,10];mainfud{2}.ConstExist=1;
        mainfud{2}.numpar=1;mainfud{2}.p{1}=3;
        %mainfud{1}.parameter(15:17)=[1,2,100];  % for optim. without non-linear constraint
                                                 % set testcase=1 in m-files: ofun6.m and cont6.m 
        mainfud{1}.parameter(15:17)=[0,1,100];   % for optim. with non-linear constraint
        mainfud{2}.NewAxesLim=[1.6 4 -2 3];      % set testcase=2 in m-files: ofun6.m and cont6.m

     elseif  Param1==304, % Function of Osyczka
        mainfud{2}.fun='rofun6';mainfud{2}.fcon='';
        mainfud{1}.parameter(15:17)=[1,2,100];
        mainfud{2}.x=[20 20];mainfud{2}.ConstExist=1;

     elseif  Param1==305,  % Bi-obj. with feasible region as a rectangle
        mainfud{2}.fun='rofun3';mainfud{2}.fcon='rcont3';
        mainfud{1}.parameter(15:17)=[0,2,100];mainfud{2}.NewAxesLim=[0 200 0 200];
        mainfud{2}.x=[-10,30];mainfud{2}.ConstExist=1;

     elseif  Param1==306,  % Bi-obj. with non-convex feasible region
        mainfud{2}.fun='rofun10';
        %mainfud{2}.fcon='';
        %mainfud{1}.parameter(15:17)=[0,2,100];   % display in the objective function space
        %mainfud{2}.NewAxesLim=[0 200 0 200]; 

        mainfud{2}.fcon='rcont10';
        mainfud{1}.parameter(15:17)=[0,1,100];    % display in the parameter space
        mainfud{2}.NewAxesLim=[-1 8 -3 6];

        mainfud{2}.x=[-10,30];mainfud{2}.ConstExist=1;
     end,
     set(fud(1),'UserData',mainfud);
     set(gcf,'Visible','off');
end
