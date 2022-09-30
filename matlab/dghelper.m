function dghelper()
% dghelper()
% This function is not intended to be called directly by users
%
% used to display the texts about how to use the uicontrol buttons in
% the main window of the Dialog to the obtained Pareto-optimal Set
% when the current cursor is above the uicontrol buttons in the figure.

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


rootloc = getset(0,'PointerLocation','Units','Points');
figpos = getset(gcf,'Position','Units','Points');
loc = (rootloc-figpos(1:2))./figpos(3:4);
hlpstr='Welcome to the dialog with the pareto-optimal set';

ESHelpStatus=findobj(gcf,'tag','diagscrl-HelpText');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit: diagscrl-ElimText %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(uh_isin(loc,[0.811798 0.494307 0.162921 0.034156]))

   hlpstr='Eliminate all not-important individuals using inequalities';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Elimin %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.456357 0.162921 0.034156]))

   hlpstr='Execute the elimination';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Comeback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.422201 0.162921 0.034156]))

   hlpstr='Come back to the original display of pareto-optimal set';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit: diagscrl-OptionText %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.919355 0.162921 0.034156]))

   hlpstr='Here are some classical methods to choose the best individual';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Number %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.811798 0.881404 0.162921 0.034156]))
   hlpstr='Choose a number of the solution on the screen';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Minimax1 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.847249 0.162921 0.034156]))

   hlpstr='The first minimax-method: min_x max_i {c_i * gf_i(x)}';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Minimax2 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.813093 0.162921 0.034156]))

   hlpstr='The second method: min_x max_i {gf_i(x) - selfish_min_i}';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Weighting %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.778937 0.162921 0.034156]))

   hlpstr='The weighting method:  min_x \Sigma c_i * f_i(x)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Lpnorm %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.744782 0.162921 0.034156]))

   hlpstr='The Lp-norm method: min_x [ \Sigma c_i * f_i^{ p}(x)]^{(1/p)}';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Goal %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.710626 0.162921 0.034156]))

   hlpstr='The goal programming: min_x [ \Sigma c_i*[f_i(x)-Selfishmin_i]^{ p} ]^{(1/p)}';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Epxilon %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.676471 0.162921 0.034156]))

   hlpstr='The epxilon-constrained method: min_x f_i(x) with f_j \leq c_j \forall j \neq i';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Germeier %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.811798 0.642315 0.162921 0.034156]))

   hlpstr='The Germeier method';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Help %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.709270 0.951613 0.070225 0.037951]))

   hlpstr='Click here for more informations about the dialog';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Close %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.617978 0.951613 0.070225 0.037951]))

   hlpstr='Click here to exit the dialog window';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Reload %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(uh_isin(loc,[0.526685 0.951613 0.070225 0.037951]))
   hlpstr='Refresh the screen by loading the new data';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pushbutton: diagscrl-Graphic %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(uh_isin(loc,[0.007022 0.951613 0.168539 0.037951]))

   hlpstr='Display the pareto-optimal subset in the two-dimensional space';

end

set(ESHelpStatus,'String',hlpstr);
