function uihelpmk(fig,filename,HelpTag)
%UIHELPMK Generate code to implement uicontrol help 
%  This function scans the figure FIG to find all uicontrols.  It then 
%  generates function such that if the function is assigned to FIG's
%  WINDOWBUTTONMOTIONFCN property, while the cursor is over a uicontrol will
%  display a help message in a uicontrol (its style property - 'text' and
%  its 'tag' property - HelpTag).  
%  The function is then written to FILENAME.
%
%  The default help message is:
%      'No help available for this UIcontrol'
%  and may be changed easily by the uicontrol designer.  The section relating 
%  to each uicontrol is marked with the uicontrol's
%  style and tag for easy reference.
%
%  If FILENAME is not specified, the default
%         filename of 'uihelper' is used.
%
%  SEE ALSO: EVOLUT.M, ESHELPER.M


%  Modification by To Thanh Binh
%  at 13.03.97


if nargin > 3, error('Too many input arguments!'); end
if nargin < 1,
   fig=gcf;filename='uihelper'; HelpTag= 'TagOfHelpUIControl';
elseif nargin ==1,
   filename='uihelper';HelpTag= 'TagOfHelpUIControl';
elseif nargin ==2
   HelpTag= 'TagOfHelpUIControl';
end
units = 'norm';

if(strcmp(filename(length(filename)-1:length(filename)),'.m'))
        filename = filename(1:length(filename)-2);
end
fd = fopen([filename '.m'],'w');
time=clock;


if(fd == -1)
        error(['Couldn''t open file: ' filename '!']);
end

if(~isobj(fig))
        error('No such figure!');
elseif(~strcmp(get(fig,'Type'),'figure'))
        error('Handle is not a figure!');
end

kids = findobj(fig,'Type','uicontrol');

if(isempty(kids))
        error('No uicontrols in this figure!');
else

        %%%%%%%%%%%%%%%%%
        % Initial Lines %
        %%%%%%%%%%%%%%%%%

        fprintf(fd,['function ' filename '()\n']);
        fprintf(fd,['%% Help function written on ', date,' at ',num2str(time(4)),':',...
                   num2str(time(5)),' by UIHELPMK \n\n']);

        fprintf(fd,'rootloc = getset(0,''PointerLocation'',''Units'',''Points'');\n');
        fprintf(fd,'figpos = getset(gcf,''Position'',''Units'',''Points'');\n');
        fprintf(fd,'loc = (rootloc-figpos(1:2))./figpos(3:4);\n');
        fprintf(fd,['HelpStatus=findobj(''tag'',''', HelpTag, ''');\n']);
        fprintf(fd,'hlpstr=''No help available for this window'';\n');
        fprintf(fd,['\tUITag=''',HelpTag,''';\n']);

        %%%%%%%%%%%%%%%%%%%
        % First uicontrol %
        %%%%%%%%%%%%%%%%%%%

        percents = '%';
        pos = getset(kids(1),'Position','Units','Normalized');
        tag = get(kids(1),'Tag');
        style = get(kids(1),'Style');

        %%%%%%%%%%%%%%%%%
        % Comment Block %
        %%%%%%%%%%%%%%%%%

        temp = ['% ' style ': ' tag ' %'];
        fprintf(fd,'\n');
        fprintf(fd,'%s\n',percents(ones(1,length(temp))));
        fprintf(fd,'%s\n',temp);
        fprintf(fd,'%s\n',percents(ones(1,length(temp))));
        fprintf(fd,'\n');

        %%%%%%%%%%%%%%%%%%%%%%%%
        % Initial IF statement %
        %%%%%%%%%%%%%%%%%%%%%%%%

        fprintf(fd,'if(uh_isin(loc,[%f %f %f %f]))\n',pos);
        fprintf(fd,'\thlpstr=''No help available for this UIcontrol'';\n');
        fprintf(fd,['\tUITag=''',tag,''';\n']);

end

if(length(kids) > 1)
        for(i=2:length(kids))
                pos = getset(kids(i),'Position','Units','Normalized');
                tag = get(kids(i),'Tag');
                style = get(kids(i),'Style');

                        %%%%%%%%%%%%%%%%%
                        % Comment Block %
                        %%%%%%%%%%%%%%%%%

                temp = ['% ' style ': ' tag ' %'];
                fprintf(fd,'\n');
                fprintf(fd,'%s\n',percents(ones(1,length(temp))));
                fprintf(fd,'%s\n',temp);
                fprintf(fd,'%s\n',percents(ones(1,length(temp))));
                fprintf(fd,'\n');

                        %%%%%%%%%%%%%%%%%%%%
                        % ELSEIF statement %
                        %%%%%%%%%%%%%%%%%%%%
                fprintf(fd,'elseif(uh_isin(loc,[%f %f %f %f]))\n',pos);
                fprintf(fd,'\thlpstr=''No help available for this UIcontrol'';\n');
                fprintf(fd,['\tUITag=''',tag,''';\n']);

        end
end
fprintf(fd,'end\n');
fprintf(fd,'if strcmp(get(findobj(''tag'',UITag),''vis''),''on''),\n');
fprintf(fd,'\tset(HelpStatus,''String'',hlpstr);\n');
fprintf(fd,'end\n');

fclose(fd);
