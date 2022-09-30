function test()

fig=figure;
ButtonH=.05;ButtonW=.04;
FrameHndl=uicontrol('style','frame','units','norm','pos',[.1,.48,.8,ButtonH+.04]);
for i=1:20,
  hndl(i)=uicontrol('style','push','units','norm','fore','black',...
   'pos',[.1+(i-1)*ButtonW,.5,ButtonW,ButtonH],'vis','off');
  set(hndl(i),'Call',['callofhndl(',num2str(i),');']);
end
set(fig,'Userdata',[FrameHndl,hndl]);   
