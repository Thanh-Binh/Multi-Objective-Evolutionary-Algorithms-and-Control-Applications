function eshelper()
% eshelper()
% This function is not intended to be called directly by users
%
% used to display the texts about how to use the uicontrol buttons in
% the main window of the Evolution Strategy, when the current cursor
% is above the uicontrol buttons in the figure.

% All Rights Reserved
% To Thanh Binh IFAT Uni Magdeburg Germany 4.12.1996


rootloc = getset(0,'PointerLocation','Units','Points');
figpos = getset(gcf,'Position','Units','Points');
loc = (rootloc-figpos(1:2))./figpos(3:4);
hlpstr='Wellcome to the Evolution Strategy';

ESHelpStatus=findobj('tag','ESHelpStatus');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESdoneButton %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(uh_isin(loc,[0.440000 0.070000 0.090000 0.050000]))
    hlpstr='Click to finish the optimization task';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESstopButton %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.330000 0.070000 0.090000 0.050000]))
    hlpstr='Click to stop the optimization process';

%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESgoButton %
%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.220000 0.070000 0.090000 0.050000]))
    hlpstr='Click to continue the optimization process';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESstepButton %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.110000 0.070000 0.090000 0.050000]))
    hlpstr='Click to run the optimization process in step';

%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESRun %
%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.850000 0.145000 0.100000 0.100000]))
    hlpstr='Click to start the evolution strategy';

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESMatDialog %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.825000 0.460000 0.150000 0.080000]))
    hlpstr='Click to dialogue with results saved in a mat-file';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESRunMatFile %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.825000 0.580000 0.150000 0.080000]))
    hlpstr='Click to continue ES for an optimization task saved in a mat-file';

%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESdemos %
%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.825000 0.700000 0.150000 0.080000]))
    hlpstr='Click to choose an ES''s demonstration';

%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESOptions %
%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.825000 0.820000 0.150000 0.080000]))
    hlpstr='Click to set up important ES''s parameters';

%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESInfos %
%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.682143 0.937000 0.112857 0.054000]))
    hlpstr='Click to get informations about the toolbox';

%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESHelp %
%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.569286 0.937000 0.112857 0.054000]))
    hlpstr='Click to get an overview about the evolution strategy';

%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESClose %
%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.456429 0.937000 0.112857 0.054000]))
    hlpstr='Click to close the main window of the evolution strategy';

%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESPrint %
%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.343571 0.937000 0.112857 0.054000]))
    hlpstr='Click to print to print the figure';

%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESGoon %
%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.230714 0.937000 0.112857 0.054000]))
    hlpstr='Click to continue the optimization process in some generations';

%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESDialog %
%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.117857 0.937000 0.112857 0.054000]))
    hlpstr='Click to dialogue with current results';

%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: ESFunc %
%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.005000 0.937000 0.112857 0.054000]))
    hlpstr='Click to set an optimization task';

end
set(ESHelpStatus,'String',hlpstr);
