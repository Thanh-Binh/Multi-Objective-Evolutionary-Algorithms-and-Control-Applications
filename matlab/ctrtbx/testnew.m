function testnew(n,name)

fud=get(gcf,'Userdata');
fud=fud(1:21);
fud(22:21+n)=zeros(1,n);
set(fud(2:21),'fore','black','vis','off')
for i=1:n,
 
  set(fud(i+1),'string',[name,num2str(i)],'vis','on','UserData',0);

end
set(gcf,'Userdata',fud);
