function [ysys,usys,t] = ctr_step(sys,output,sslevel,t)
% [ysys,usys,t] = ctr_step(sys,output,sslevel,t)
% Step response of closed-loop continuous-time multivariable linear systems.
%		
% x = A *x + B *ref
% y = C *x + D *ref
% u = C1*x + D1*ref
%    x,y,u  - state, output, input variables of the plant 
%    ref    - reference signals
%    sys    = {A,B,C,D,C1,D1}  
%    output - index for the important outputs, the performance of which
%             must be considered by desinging
%    sslevel- the corresponding steady state values for the desired outputs
%    t      - time vector 
%
%    CTR_STEP returns the plant's output, input time response in the cell arrays 
%       YSYS and USYS respectively.
%    If the time vector is not specified, then the automatically determined
%    time vector is returned in T.

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 



if nargin ==0, 
   error('Too few inputs!');
elseif nargin ==1,
   output=[];sslevel=[];t=[];
elseif nargin ==2,
   sslevel=[];t=[];
elseif nargin ==3,
   t=[];
elseif nargin > 4, 
   error('Too many inputs!');
end

SysLength=length(sys);
switch SysLength
  case 4,
     a=sys{1};b=sys{2};c=sys{3};d=sys{4};c1=[];d1=[];
     error(abcdchk(a,b,c,d)); Sim2=0;

  case 6,
     a=sys{1};b=sys{2};c=sys{3};d=sys{4};
     error(abcdchk(a,b,c,d));
     c1=sys{5};d1=sys{6}; Sim2=1;
     error(abcdchk(a,b,c1,d1));
  otherwise,
     error('Incompatible variables');
end

nx=size(a,1);
ny=size(d,1);
if isempty(output), output=[1:ny];end
OutLength=length(output);
if isempty(sslevel), sslevel=ones(1,OutLength);end
if isempty(t), 
   %t=timvec(a,b,c);
   [dt,tset]=timscale(a,b,c,[],[]);
   t=[0:dt:tset];
else,
   dt = t(2)-t(1);
end

% Simulation
nt = length(t);

if Sim2, 
   nu=size(c1,1); 
   usys=CellInitNow(nu,nt,OutLength);
   % Every element of usys, i.e., usys{i} describes the response of the
   % i-th plant input respect to all OutLength reference signals
else,
   usys={};
end

ysys=CellInitNow(ny,nt,OutLength);

for i=1:OutLength,
   bi=b(:,output(i));
   [aa,bb] = c2d(a,bi,dt);
   x = ltitr(aa,bb,sslevel(i)*ones(nt,1),zeros(nx,1));
   ytmp=x*c.'+ sslevel(i)*ones(nt,1)*d(:,output(i)).';
   % ytmp - a response of all outputs respect to the i-th reference signal 

   ysys=SetCellNow(ysys,ytmp,ny,i);
   if Sim2,
      utmp=x*c1.'+ sslevel(i)*ones(nt,1)*d1(:,output(i)).';
      usys=SetCellNow(usys,utmp,nu,i);
   end
end


function out=CellInitNow(Length,nrows,ncols);
% Initialize a cell with the length LENGTH and each element
% of it would be a (NROWS,NCOLS)-matrix

for i=1:Length,
   out{i}=zeros(nrows,ncols);
end  

function x=SetCellNow(x,Mat,MatNumCols,CurrentInput);
% Set the CURRENTINPUT-th column of the i-th element of X
% to the value Mat(:,i)

for i=1:MatNumCols,
   x{i}(:,CurrentInput)=Mat(:,i);
end


