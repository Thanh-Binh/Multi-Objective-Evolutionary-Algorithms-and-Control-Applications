function [xinf,yinf,f,h,fail] = bhinfgam(a,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,gam,imethd);
% [xinf,yinf,f,h,fail] = bhinfgam(a,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,gam,imethd);
%
% solve the hamiltonian for xinf and yinf, f and h for the bhinf program.
%
% See also BHINF.M 

% All Rights Reserved, 2.Aug.1995
% To Thanh Binh IFAT Uni. Magdeburg Germany



 fail = 0;
 np = max(size(a)); 
 np1 = ndata(1);
 np2 = ndata(2);
 nm1 = ndata(3);
 nm2 = ndata(4);
                                                   %  form r and rbar
 d1dot = [d11,d12];
 r = zeros(nm1+nm2,nm1+nm2);
 r(1:nm1,1:nm1) = -gam*gam*eye(nm1);
 r = r+d1dot'*d1dot;
 ddot1 = [d11;d21];
 rbar = zeros(np1+np2,np1+np2);
 rbar(1:np1,1:np1) = -gam*gam*eye(np1);
 rbar = rbar+ddot1*ddot1';
                                                   % form hamiltonian hamx for xinf
 dum = ([bp;-c1'*d1dot]/r)*[d1dot'*c1,bp'];
 hamx = [a,0*a;-c1'*c1,-a']-dum;
                                                   %  form hamiltonian hamy for yinf
 dum = ([cp';-b1*ddot1']/rbar)*[ddot1*b1',cp];
 hamy = [a',0*a;-b1*b1',-a]-dum;

 epr=1e-13;

 if imethd == 1
                                                   % Solve the Riccati equation using eigenvalue decomposition
                                                   %  	   - Balance Hamiltonian
   [x1,x2,failx] = ric_eig(hamx,epr);
   if (failx ~= 0), fail=1;return,end              % Decomposition failed
   [y1,y2,faily] = ric_eig(hamy,epr);

 elseif imethd == -1
                                                   % Solve the Riccati equation using eigenvalue decomposition
                                                   %       - No Balancing of Hamiltonian Matrix
   [x1,x2,failx] = ric_eig(hamx,epr,1);
   if (failx ~= 0), fail=1;return,end              %       Decomposition failed
   [y1,y2,faily] = ric_eig(hamy,epr,1);

 elseif imethd == 2
                                                   % solve the Riccati equation using real schur decomposition
                                                   %       - Balance Hamiltonian Matrix
   [x1,x2,failx] = ric_schr(hamx,epr);
   if (failx ~= 0), fail=1;return,end              %       Decomposition failed
   [y1,y2,faily] = ric_schr(hamy,epr);

 elseif imethd == -2 
                                                   % Solve the Riccati equation using real schur decomposition
                                                   %       - No Balancing of Hamiltonian Matrix   
   [x1,x2,failx] = ric_schr(hamx,epr,1);
   if (failx ~= 0), fail=1;return,end,             %       Decomposition failed
   [y1,y2,faily] = ric_schr(hamy,epr,1);
 else
   error('type of solution method is invalid')
   return

 end

 if (faily ~= 0), fail=1;return,end                %       all decompositions failed
 xinf = real(x2/x1);
 yinf = real(y2/y1);


                                                   %  form f, h, and their submatrices
 f = -r\(d1dot'*c1+bp'*xinf); 

 h = -(b1*ddot1'+yinf*cp')/rbar;
