
function callofhndl(i)

fud=get(gcf,'Userdata');
hndl=fud(1+i);
if ~get(hndl,'Userdata'),
   fud(21+i)=i;set(hndl,'Userdata',1,'fore','b');
else
   fud(21+i)=0;set(hndl,'Userdata',0,'fore','black');
end
set(gcf,'Userdata',fud);
