function poleopt(action,Par1,Par2,Par3)
% poleopt(action,Par1,Par2,Par3)
% This function is not intended to call directly from users.
% Used to choose a pole region.
% Parameters of the Pole Region are saved in the Button 'OK' that corresponds
% to the performance indices:'Pole Region Type';


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin <1,
    action='init';Par1=inf;Par2=inf;
elseif nargin <2, 
   Par1=inf;Par2=inf;Par3=inf;
end

% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;


switch action,
   case 'init',

     choice5('Pole Region Option',350,200,[0 1 1],'off');

     text1=uicontrol(Std,'Style','text','Pos',[.1 .62 .6 .12],'Back',[0 1 1], ...  
         'Fore','b','String',' ','HorizontalAlignment','left','Visible','off');  
     par1=uicontrol(Std,'Style','edit','Pos',[.75 .62 .15 .12], ...  
        'Back','white','String','','Visible','off');  

     text2=uicontrol(Std,'Style','text','Pos',[.1 .42 .6 .12],'Back',[0 1 1], ...  
        'Fore','b','String',' ','HorizontalAlignment','left','Visible','off');   
     par2=uicontrol(Std,'Style','edit','Pos',[.75 .43 .15 .12], ...  
        'Back','white','String','','Visible','off');  

     text3=uicontrol(Std,'Style','text','Pos',[.1 .24 .6 .12],'Back',[0 1 1],...   
        'Fore','b','String',' ','HorizontalAlignment','left','Visible','off');  
     par3=uicontrol(Std,'Style','edit','Pos',[.75 .24 .15 .12],...   
        'Back','white','String','','Visible','off');  

     PolList=['Pole Region Type|Left Half Plane|',...
         'Hyperbola |Disc|Disc-Hyperbola|',...
         'Minimum Damping'];
     Callback=[...
         'pl=get(gcf,''Userdata'');val=get(pl(1),''Value'');',...
         'if val==2,',...     
             'set(pl(3),''String'',''Value of x0'');',... 
             'set(pl([3 6]),''Visible'',''on'');set(pl([2 4 5 7]),''Visible'',''off'');',...
         'elseif val==3,',...     
             'set(pl(3),''String'',''Parameter c of the Hyperbola'');',...
             'set(pl(4),''String'',''Parameter d of the Hyperbola'');',... 
             'set(pl([3 4 6 7]),''Visible'',''on'');set(pl([2 5]),''Visible'',''off'');',...
         'elseif val==4,',...     
             'set(pl(3),''String'',''Position of the Centre x0'');',...  
             'set(pl(4),''String'',''Radius of the Disc R'');',...
             'set(pl([3 4 6 7]),''Visible'',''on'');set(pl([2 5]),''Visible'',''off'');',...
         'elseif val==5,',...  
             'set(pl(2),''String'',''Radius of the Disc R'');',...
             'set(pl(3),''String'',''Parameter c of the Hyperbola'');',...
             'set(pl(4),''String'',''Parameter d of the Hyperbola'');',... 
             'set(pl(2:7),''Visible'',''on'');',... 
         'elseif val==6,',...     
             'set(pl(3),''String'',''Damping Angle'');',...
             'set(pl([3 6]),''Visible'',''on'');set(pl([2 4 5 7]),''Visible'',''off'');',...
         'end,'];   
     PRPopup=uicontrol(Std,'Style','popup','Pos',[.2 .83 .6 .12],...
         'String',PolList,'call',Callback);  
     uicontrol(Std,'Style','push','Pos',[.3 .05 .15 .12],'String','Close','call',[...
         'lc_call1(14,1);close(gcf);']);     
     uicontrol(Std,'Style','push','Pos',[.55 .05 .15 .12],'String','OK','call',[...
         'fud=get(findobj(''tag'',''DesignMainFig''),''Userdata'');',...
         'pl=get(gcf,''Userdata'');str=get(pl(1),''String'');',...
         'val=get(pl(1),''Value'');set(fud{1}(14),''String'',str(val,:));',...
         'pg14=get(fud{1}(14),''UserData'');',...
         'if val==2,',...     
             'poleopt(''olhp'',pg14(3),pl,val);',...
         'elseif val==3,',...     
             'poleopt(''hyp'',pg14(3),pl,val);',...
         'elseif val==4,',...     
             'poleopt(''disc'',pg14(3),pl,val);',...
         'elseif val==5,',...  
             'poleopt(''dhyp'',pg14(3),pl,val);',...
         'elseif val==6,',...     
             'poleopt(''min'',pg14(3),pl,val);',...
         'end']);

     set(gcf,'UserData',[PRPopup,text1,text2,text3,par1,par2,par3]);
  
  case 'olhp',

     errortext=[' This Parameter must be negative! ';...
                ' Choose this again, please.       '];  
     dopt=[Par3-1,0,0,0];
     dopt(2)=str2num(get(Par2(6),'string'));
     if dopt(2) > 0,
          esmsg(errortext,'Error','error');
     else, 
         set(Par1,'UserData',dopt); close(gcf);
     end 

  case 'min',

     errortext=[' This Parameter must be positive! ';...
                ' Choose this again, please.       '];  
     dopt=[Par3-1,0,0,0];

     dopt(2)=str2num(get(Par2(6),'string'));
     if dopt(2)< 0,
          esmsg(errortext,'Error','error');
     else, 
         set(Par1,'UserData',dopt);close(gcf);
     end 

  case 'hyp',

     dopt=[Par3-1,-100,0,0];  
     dopt(3)=str2num(get(Par2(6),'string'));dopt(4)=str2num(get(Par2(7),'string')); 

     errortxt=[' Parameter c must be negative! ';' Parameter d must be positive! '];  
     errortxt=[errortxt;' Choose these again, please.   ';' Choose this again, please.    '];  
     if (dopt(3)>=0)&(dopt(4)<=0), 
         esmsg(errortxt(1:3,:),'Error','error');
     elseif (dopt(3)>=0)&(dopt(4)>0), 
         esmsg(errortxt(1:3:4,:),'Error','error');  
     elseif (dopt(3)<0)&(dopt(4)<=0), 
         esmsg(errortxt(2:2:4,:),'Error','error');
     else, 
         set(Par1,'UserData',dopt);close(gcf);
     end 

  case 'dhyp',

     dopt=[Par3-1,0,0,0];  
     dopt(2)=str2num(get(Par2(5),'string'));dopt(3)=str2num(get(Par2(6),'string')); 
     dopt(4)=str2num(get(Par2(7),'string'));
     errortxt=[' Parameter c must be negative!  ';' Parameter d must be positive!  '];  
     errortxt=[errortxt;' Choose these again, please.    ';' Choose this again, please.     '];   
     errortxt1=[' A Region does not exist.       ';' Choose Parameter again, please.'];  
     if (dopt(3)>=0)&(dopt(4)<=0),
        esmsg(errortxt(1:3,:),'Error','error');
     elseif (dopt(3)>=0)&(dopt(4)>0),
        esmsg(errortxt(1:3:4,:),'Error','error');
     elseif (dopt(3)<0)&(dopt(4)<=0),
        esmsg(errortxt(2:2:4,:),'Error','error');
     elseif abs(dopt(3))>=dopt(2),
        esmsg(errortxt1,'Error','error');  
     else, 
         set(Par1,'UserData',dopt);close(gcf);
     end 

  case 'disc',

     errortxt=[' Parameter x0 must be negative! ';...
               ' Parameter R must be positive!  ';  ...
               ' Choose these again, please.    ';...
               ' Choose this again, please.     '];  
     errortxt1=[' Disc is out of the open complex left half plane ';...
                ' Choose x0 and R again, please.                  '];  
  
     dopt=[Par3-1 0 0 0];
     dopt(2)=str2num(get(Par2(6),'string'));dopt(3)=str2num(get(Par2(7),'string')); 
     if (dopt(2)>=0)&(dopt(3)<=0),
         esmsg(errortxt(1:3,:),'Error','error');
     elseif (dopt(2)>=0)&(dopt(3)>0),
         esmsg(errortxt(1:3:4,:),'Error','error');
     elseif (dopt(2)<0)&(dopt(3)<=0),
         esmsg(errortxt(2:2:4,:),'Error','error');
     elseif (dopt(2)<=0)&(dopt(3)>0)&(dopt(3)>abs(dopt(2))),
         esmsg(errortxt1,'Error','error');
     else,
         set(Par1,'UserData',dopt);close(gcf);
     end  

end     
