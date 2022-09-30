function Kv = vgain(num,den)
%VGAIN  Kv = vgain(num,den) 
%       Computes the velocity error constant Kv given the 
%       transfer function of a system.
%Inputs: num - numerator polynomial of transfer function
%        den - denominator polynomial of transfer function
%Output: Kv - velocity error constant
%
%       See also DCGAIN

%%%%%%%%%%%%%%%%%%%%%% vgain.m %%%%%%%%%%%%%%%%%%%%%%
%       Feedback Control Problems with MATLAB 
%           and the Control System Toolbox
%      D. K. Frederick and J. H. Chow, Nov. 94
%----------------------------------------------------
len_den = length(den);
len_num = length(num);
if den(len_den) ~= 0
  disp('System is type-0, Kv = 0')
  Kv = 0;
 else
  disp('System type is greater than or equal to 1')
  Kv = num(len_num)/den(len_den-1);
end
return
%%%%%%%%%%%%%%%%%%% end of vgain.m %%%%%%%%%%%%%%%%%%