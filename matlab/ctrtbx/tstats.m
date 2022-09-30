function [Mo,tp,tr,ts,ess] = tstats(t,y,ref)
%TSTATS [Mo,tp,tr,ts,ess] = tstats(t,y,ref)
%       Takes a time vector and a corresponding 
%       step-response vector and returns time-domain 
%       performance measures.
%Inputs: t - time vector 
%        y - step response corresponding to t
%        ref - reference level at steady-state
%Outputs: Mo - percent overshoot
%         tp - time to peak
%         tr - rise time (10% - 90%)
%         ts - settling time (2%)
%         ess - percent steady-state Error
%
%If the reference level, 'ref', is not specified, 1.0 is assumed.

%%%%%%%%%%%%%%%%%%%%% tstats.m %%%%%%%%%%%%%%%%%%%%%%
%       Feedback Control Problems with MATLAB 
%           and the Control System Toolbox
%      D. K. Frederick and J. H. Chow, Nov. 94
%----------------------------------------------------

if nargin < 3
  ref = 1;
  disp('reference value set = 1.0')
end
%
[maxy,itp] = max(y);
tp = t(itp);
Mo = 100*(maxy - ref)/ref;
if Mo < 0
  Mo = [];
end
%
i10 = min(find(y>=0.1*ref));
i90 = min(find(y>=0.9*ref));
if i10 > 0 & i90 < length(y)
  delt = t(2)-t(1);
  t10 = t(i10) - delt*(y(i10)-0.10*ref)...
		/(y(i10)-y(i10-1));
  t90 = t(i90) - delt*(y(i90)-0.90*ref)...
		/(y(i90)-y(i90-1));
  tr  = t90 - t10;
else
  tr = [];
end
%
is = max(find(abs(y - ref*ones(size(y)))/ref>0.02));
if is < length(y)
  ts = t(is + 1);
else
  ts = [];
end
%
ess = abs(100*(y(length(y)) - ref)/ref);

%%%%%%%%%%%%%%%%%% end of tstats.m %%%%%%%%%%%%%%%%%%
