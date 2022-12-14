function what2do(current,medium,ClearAllow)
% what2do(current,medium,ClearAllow)
% This function is not intended to be called directly from users.
% Open a dialog box if old data in a medium should
% be cleared before calling optimization routine or new data
% have to be inserted into old data.
% When ClearAllow=0, only INSERT-mode is available.

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 

         
ClearCall=[...
   'cfud=get(gcf,''UserData'');',...
   'fud=get(cfud(1),''UserData'');',...
   'set(cfud(2),''UserData'',{fud{2},fud{3},fud{4}});',...
   'close(cfud(1));close(gcf);',...
   'evolut1(fud{3},''do'',fud{2});'];

InsertCall=[...
   'cfud=get(gcf,''UserData'');',...
   'fud=get(cfud(1),''UserData'');close(cfud(1));close(gcf);',...
   'set(cfud(2),''UserData'',fud);',...
   'evolut1(fud{3},''do'',fud{2});'];


if ClearAllow,
   message=str2mat('Data already exist in the medium.',...
     'Do you want to clear or insert into them?',...
     'Note: By inserting old and new data are saved in',...
     '      the first and second element of a cell array,',...
     '      respectively.'); 

   fig=esmsg(message,'What''s to do?','warn',ClearCall,InsertCall,'Clear','Insert'); 
else,
   message=str2mat('Data already exist in the medium.',' ',...
     'New data have to be inserted into the old ones.'); 

   fig=esmsg(message,'New infos','info',InsertCall,'','OK',''); 
end

set(fig,'UserData',[current,medium]);
