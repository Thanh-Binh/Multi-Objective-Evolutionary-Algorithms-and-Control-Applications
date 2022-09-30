function fvec = ofun5(x)
% fvec = ofun5(x) 
% [resf,fvec]=bbadscb(x)
% Problem no. 4
% Dimensions -> n=2 optimized variables
%               m=3 objective functions              
% Standard starting point -> x=(1,1)  
% Minima -> f=0 at (1e+6,2e-6)        
% Rewrite this function at 26.10.1995
%
% Notice:
%     using the ES the minimum is achieved after 300 Generations

% To Thanh Binh IFAT Uni Magdeburg                           
 
fvec = [x(1)-1e+6; x(2)-(2e-6); x(1)*x(2)-2]  ;

fvec=[0;abs(fvec)];
%fvec=sum(fvec.^2);
