function [bw,err] = bwcalc(db,omega,lfg_db)
%BWCALC [bw,err] = bwcalc(db,omega,lfg_db)
%       Determines the bandwidth of a system, either open- or 
%       closed-loop, by:
%       1. evaluating the freq response for a number of frequencies
%       2. finding the freq at which the magnitude is 3.0 db lower 
%          than the LFG
%Inputs: db - vector of magnitudes (decibels) 
%        omega - vector of corresponding frequencies
%        lfg_db - low-frequency gain (dB)
%Outputs: bw - bandwidth, same scale as omega
%         err - error flag
%                1 -> mag at lowest freq was < lfg -3.0 (db)
%                2 -> mag at all freq were > lfg -3.0

%%%%%%%%%%%%%%%%%%%%%% bwcalc.m %%%%%%%%%%%%%%%%%%%%%
%       Feedback Control Problems with MATLAB 
%           and the Control System Toolbox
%      D. K. Frederick and J. H. Chow, Nov. 94
%----------------------------------------------------
err = 0;
bw = [];	    
% evaluate freq response
% get index of the frequency just after the
% magnitude goes 3 db below the LFG
kmax=length(db);
flag=0;  % 1-> found a mag below lfg - 3.0
for k=1:kmax
  i=k;
  if db(k) - lfg_db < -3.0
    if k == 1
      err=1; return
    end
    flag=1; break
  end
end
% see if we got through all points without finding a crossing
if i == kmax
  if flag == 0
    err=2; return
  end
end

% we have a crossing if got here, so find bandwidth by interpolation
slope=(db(i)-db(i-1))/(omega(i)-omega(i-1));
delta=(lfg_db-3.0-db(i-1))/slope;
bw=omega(i-1)+delta;
return
%%%%%%%%%%%%%%%%%% end of bwcalc.m %%%%%%%%%%%%%%%%%%