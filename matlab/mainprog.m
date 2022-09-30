function ESPop=mainprog(OptTask,ES,ESPop);
% ESPop=mainprog(OptTask,ES,ESPop)
% Explainations for all input variables can be seen in EVOLSTR.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


Precisions= ES.parameter(6);
Distrib   = ES.parameter(13);
McwDisp   = ES.parameter(15);
GuiDisp   = ES.parameter(16);
MaxGen    = ES.parameter(17);
NumUFInd  = ES.parameter(19);
FunName   = ES.file.funtmp;
MutAlg    = ES.algorithm.mutation;
RepAlg    = ES.algorithm.reproduction;
SelAlg    = ES.algorithm.selection;

NewAxesLim= OptTask.NewAxesLim;
x0        = OptTask.x;
xrange    = OptTask.xrange;
ConstExist= OptTask.ConstExist;
mf        = ESPop.dim(3);
plothandle= ESPop.plothandle; 
X         = ESPop.x;
S         = ESPop.s;
Obj       = ESPop.obj;
Generation= ESPop.generation;

if GuiDisp, ghndl=ES.graphic;end


PropCheck=0;
if PropCheck,
   PropCheckFig=findobj('name','Properties of the Evolutionary Algorithm');
   if ~isempty(PropCheckFig),
      figure(PropCheckFig);
   else
      PropCheckFig=choice5('Properties of the Evolutionary Algorithm',500,300);
      xlabel('Generation');
      ylabel('Strategy parameters')   
   end
   sigmamax=max(S,[],2);
   iterhndl=Generation;
   set(gca,'XTick',[0:MaxGen]);
end

NumGenAfterSatisfy=3;     % Number of Generations after all constraints are satisfied.
GenCounter=0;
if ConstExist,            % Constraints exist 
   SoCalledConstSatisfy =0;       
else,                     % Constraints don't exist
   ESPop.ConstSatisfy=1;
end
PrecisionTest=1;
if ES.parameter(7),
   MainLoop=1;
else,
   MainLoop=(Generation<MaxGen)&(PrecisionTest>Precisions);
end

ConstSatisfy=ESPop.ConstSatisfy;
Par=[ES.parameter, ConstSatisfy 0 ES.algorithm.niche];

while  MainLoop,
   [X,S,Obj,Par(22)]=esmut(x0,xrange,X,S,Obj,Par,FunName,MutAlg);
   [X,S,Obj]=esreprod(x0,X,S,Obj,Par,FunName,RepAlg);
   [X,S,Obj]=esselect(X,S,Obj,Par,SelAlg);
   if mf==1,
      gftmp=Obj(2,:);
      PrecisionTest=abs((max(gftmp)-min(gftmp))/sum(abs(gftmp)));
   end
   Generation=Generation+1;

   if PropCheck,
      sigmamax=[sigmamax,max(S,[],2)];iterhndl=[iterhndl,Generation];
      figure(PropCheckFig);
      plot(iterhndl,sigmamax);
   end

   if ConstExist & (~ConstSatisfy),     
      % Constraints exist but still are not satisfied
      NUFInd=length(find(Obj(1,:)~=0));
      if NUFInd <= NumUFInd,           
         ConstSatisfy=1;
         if NUFInd,
            if ~SoCalledConstSatisfy,
               disp('Now, the feasible region seems to be found!');
               SoCalledConstSatisfy=1;
            end
         else,
            disp('Now, the feasible region is found! Bye bye!')
         end
      end
   end 

   ESPop.x            = X;
   ESPop.s            = S;   
   ESPop.obj          = Obj;
   ESPop.ConstSatisfy = ConstSatisfy;
   ESPop.generation   = Generation;
   
   % Display the current population
   if McwDisp, mcwdisp(Obj,Generation);end

   if GuiDisp, 
      guidisp2(GuiDisp,plothandle,X,Obj);
      if (~isempty(NewAxesLim)&(ConstSatisfy|(Generation==12))),
         set(ghndl(9),'XLim',NewAxesLim(1:2),'YLim',NewAxesLim(3:4));
      end
      if (GuiDisp==1)|(GuiDisp==2),
        if strcmp(get(ghndl(3),'enable'),'off'), PrecisionTest=0; end
      end
      set(ghndl(7),'string',int2str(Generation));
      set(ES.graphic(11),'UserData',{ES,OptTask,ESPop});

   else,
      if ~rem(Generation,5),  % save after 5 generations
         mainfud={ES,OptTask,ESPop};
         save([ES.file.mattmp,'.mat'], 'mainfud');
         if ~isnan(ES.medium),
            MediumData=get(ES.medium,'UserData');
            MediumDataL=length(MediumData);
            if MediumDataL==4,
               MediumData{2}=ES;MediumData{3}=OptTask;MediumData{4}=ESPop; 
            elseif MediumDataL ==3,
               MediumData=mainfud;
            end
            set(ES.medium,'UserData',MediumData);
         end
      end
   end
   
   % Check Terminal Criteria 
   %%%%1. for solution of a system of the inequalities (MOI)
   %%%%   by searching for the feasible region
       
   if ConstSatisfy & (mf <1) 
      if (GenCounter <= NumGenAfterSatisfy),
         GenCounter=GenCounter+1; 
      else,
         PrecisionTest=0;    % end the search because the solutions are found
      end
   end

   %%%%2. for  Step by Step Evolution
   if ES.parameter(7),
      MainLoop=0;
   else,
      MainLoop=(Generation<MaxGen)&(PrecisionTest>Precisions);
   end
end

