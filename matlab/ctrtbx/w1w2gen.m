function w1w2gen(fid,W1,W2) 
% To construct weighting function W1, W2
%	W1(:,1)= flags for weighting 	0 : poles/zeros
%					1 : polynomials
%	W1(:,2)= number of integrators
%	W1(:,3)= numerator order
%	W1(:,4)= denominator order

comment='%c';cr=setstr(10);
n=length(W2(:,1));
m=length(W1(:,1));

s=[comment,' Construct weighting function W1'];
s=[s,cr];fprintf(fid,s,37);
np=0;
for ii=1:m
     if all(~W1(ii,2:4))
	np=np+1;s=['ax=0;bx=0;cx=0;dx=xp(',num2str(np),');'];
     else
	s='[ax,bx,cx,dx]=';
	if W1(ii,1)==0,% poles and zeros
		np=np+1;s=[s,'zp2ss(['];
		if W1(ii,3),for j=1:W1(ii,3),s=[s,'-xp(',num2str(np+j),') '];end,end
		s=[s,'],['];
		if W1(ii,2),for j=1:W1(ii,2),s=[s,'0 '];end,end
		if W1(ii,4),for j=1:W1(ii,4),s=[s,'-xp(',num2str(np+W1(ii,3)+j),') '];end,end
		s=[s,'],xp(',num2str(np),') );'];
		np=np+W1(ii,3)+W1(ii,4);
	else % transfer function
		s=[s,'tf2ss(['];
		for j=W1(ii,3)+1:-1:1,s=[s,'xp(',num2str(np+j),') '];end
		s=[s,'],['];np=np+W1(ii,3)+1;
		if W1(ii,4),for j=W1(ii,4):-1:1,s=[s,'xp(',num2str(np+j),') '];end,end
		s=[s,'1 '];np=np+W1(ii,4);
		if W1(ii,2),for j=1:W1(ii,2),s=[s,'0 '];end,end
		s=[s,']);'];
	end
     end
     s=[s,cr];fprintf(fid,s);
     if ii==1, 
	s='aw1=ax;bw1=bx;cw1=cx;dw1=dx;';
     else
	s='[aw1,bw1,cw1,dw1]=append(aw1,bw1,cw1,dw1,ax,bx,cx,dx);';
     end
     s=[s,cr];fprintf(fid,s);
end

% weighting function W2
s=['  ',cr];
fprintf(fid,s,37);

s=[comment,' Construct weighting function W2',cr];
fprintf(fid,s,37);
for ii=1:n
     if W2(ii,1)==0,% poles and zeros
        if all(~W2(ii,2:4))
		np=np+1;s=['ax=0;bx=0;cx=0;dx=xp(',num2str(np),');'];
        else
		s='[ax,bx,cx,dx]=';
		np=np+1;s=[s,'zp2ss(['];
		if W2(ii,3),for j=1:W2(ii,3),s=[s,'-xp(',num2str(np+j),') '];end,end
		s=[s,'],['];
		if W2(ii,4),for j=1:W2(ii,4),s=[s,'-xp(',num2str(np+W2(ii,3)+j),') '];end,end
		s=[s,'],xp(',num2str(np),') );'];
		np=np+W2(ii,3)+W2(ii,4);
	end
     elseif W2(ii,1)==1 % transfer function
		s=[s,'tf2ss(['];
		for j=W2(ii,3)+1:-1:1,s=[s,'xp(',num2str(np+j),') '];end
		s=[s,'],['];np=np+W2(ii,3)+1;
		if W2(ii,4),for j=W2(ii,4):-1:1,s=[s,'xp(',num2str(np+j),') '];end,end
		s=[s,'1])'];np=np+W2(ii,4);
     elseif W2(ii,1)==2,% unity
	s=['ax=[];bx=[];cx=[];dx=1;'];
     end
     s=[s,cr];fprintf(fid,s);
     if ii==1, 
	s='aw2=ax;bw2=bx;cw2=cx;dw2=dx;';
     else
	s='[aw2,bw2,cw2,dw2]=append(aw2,bw2,cw2,dw2,ax,bx,cx,dx);';
     end
     s=[s,cr];fprintf(fid,s);
end

 
