function [ak,bk,ck,dk] = bhinf_c(a,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,xinf,yinf,f,h,gfin,r12,r21)
%
% [ak,bk,ck,dk] = bhinf_c(a,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,xinf,yinf,f,h,gfin,r12,r21)
%
% Form the controller given the gamma value (gfin) and xinf, yinf
%
% See also HINF_C.M  from Mu-Tool

% To Thanh Binh IFAT Uni. Magdeburg Germany
% All Rights Reserved 31.8.95


np1 = ndata(1);
np2 = ndata(2);
nm1 = ndata(3);
nm2 = ndata(4);
np = max(size(a));
                                       % form the submatrices f11,f12,f2 and h11,h12,h2
                                       % With assumptions for solution of the H-infinity problems
                                       % we usually have  the following inequations:
                                       %          nm1 >= np2;
                                       %          np1 >= nm2;
                                       % therefore the following calculations are correctly.
f11=f(1:(nm1-np2),:);
f12=f((nm1-np2+1):nm1,:);
f2=f((nm1+1):(nm1+nm2),:);
h11=h(:,1:(np1-nm2));
h12=h(:,(np1-nm2+1):np1);
h2=h(:,(np1+1):(np1+np2));
                                       %  partition d11
d1111=d11(1:(np1-nm2),1:(nm1-np2));
d1112=d11(1:(np1-nm2),(nm1-np2+1):nm1);
d1121=d11((np1-nm2+1):np1,1:(nm1-np2));
d1122=d11((np1-nm2+1):np1,(nm1-np2+1):nm1);

                                       %  form controller k
                                       %  have to check for null ([]) values  of 
                                       %  d1111,d1112,d1121,d1122
[rd1111,cd1111]=size(d1111);
sd1112=max(size(d1112));
sd1121=max(size(d1121));
sd1122=max(size(d1122));

if rd1111==0 | sd1112==0
  d11hat=-d1122;
else
  gdum=inv(gfin*gfin*eye(np1-nm2)-d1111*d1111');
  d11hat=-d1121*d1111'*gdum*d1112-d1122;
end

if sd1112==0 
  d21hat=eye(np2);
elseif  rd1111==0
  d21hat=chol(eye(np2)-d1112'*d1112/gfin/gfin);
else
  gdum=inv(gfin*gfin*eye(np1-nm2)-d1111*d1111');
  dum=eye(np2)-d1112'*gdum*d1112;
  d21hat=chol(dum);
end
if  sd1121==0
  d12hat=eye(nm2);
elseif cd1111==0 
  d12hat = chol(eye(nm2)-d1121*d1121'/gfin/gfin)';
else
  gdum=inv(gfin*gfin*eye(nm1-np2)-d1111'*d1111);
  dum=eye(nm2)-d1121*gdum*d1121';
  d12hat=chol(dum)';
end

z = inv(eye(np)-yinf*xinf/(gfin*gfin));
clear gdum dum
b2hat=(b2+h12)*d12hat;
c2hat=-d21hat*(c2+f12)*z;
b1hat=-h2+(b2hat/d12hat)*d11hat;
c1hat=f2*z+(d11hat/d21hat)*c2hat;
ahat=a+h*cp+(b2hat/d12hat)*c1hat;
                                       % form the controller for the case where d22 is zero
                                       %  back-substitute scaling factors r12 and r21
b1hat=b1hat*r21;
c1hat=r12*c1hat;
bhat=[b1hat,b2hat];
chat=[c1hat;c2hat];
dhat=[r12*d11hat*r21,r12*d12hat;d21hat*r21,(0.*d11hat')];
                                       %  this part of the program allows for a d22 
                                       %  non-zero in the plant matrix
                                       %  it assumes that phi=0 
                                       %  check that the det(i+d11hat*d22) is non-zero
if cond(eye(nm2)+d11hat*d22) > 1/eps
   error('  det(I+d11hat*d22) is zero ')
end
d22new=[d22,(0.*eye(np2));(0.*eye(nm2)),(0.*d22')];
m=inv(eye(nm2+np2)+d22new*dhat);
mhat=inv(eye(nm2+np2)+dhat*d22new);
ahat=ahat-bhat*((eye(nm2+np2)-m)/dhat)*chat;
bhat=bhat*m;
chat=mhat*chat;
dhat=dhat*m;
ak=ahat;
bk=bhat(:,1:np2);
ck=chat(1:nm2,:);
dk=dhat(1:nm2,1:np2);


%k = pck(ahat,bhat(:,1:np2),chat(1:nm2,:),dhat(1:nm2,1:np2));
