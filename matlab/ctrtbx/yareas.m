function [y,dt,x,t] = yareas(a,b,c,d,iu)
% [y,dt,x,t]=yareas(a,b,c,d,iu)
% YAREAS returns the state and output time responses to a step
% applied to the Input IU.
% It is used to create of the optimized function.

% To Thanh Binh IFAT Uni. Magdeburg Germany 17.06.95

b=b(:,iu);d=d(:,iu);

[n,m]=size(b);

%t=timvec(a,b,c,zeros(n,1));

%dt = t(2)-t(1);
%nn = length(t);


% my test in 19.06.95
o=eig(a);
t=3/min(abs(real(o))); % max(t5%)
freq_max=max(imag(o));
if freq_max,
   dt=pi/(8*freq_max); % 16 points per a period
                       % tol=.01  
   nn=ceil(t/dt); 
else
   dt=t/500;nn=500;    % tol=.003
end
t=0:dt:t;
[aa,bb] = c2d(a,b,dt);
x = ltitr(aa,bb,ones(nn,1),zeros(n,m));
y=x*c.'+ ones(nn,1)*d.';
