% PLOTing of DO(Ppel)uble Integration results 
%
% This function plots some of the results during computation
% of the double integrator.
%
% Syntax:  plotdopi(OBJ_F, chrom, gen, P1, P2, P3)
%
% Input parameters:
%    OBJ_F     - Vector containing the (name of the) objective function
%    chrom     - Vector containing the individual for simulation
%    gen       - Scalar containing the number of the current generation
%    P1-P3     - additional parameters, see objdopi
%
% Output parameter:
%    x         - Matrix containing the states from answer of objdopi
%
% See also: objdopi, simdopiv, simdopi1

%  Author:    Hartmut Pohlheim
%  History:   09.06.95     file created


function x = plotdopi(OBJ_F, chrom, gen, P1, P2, P3);

% Build string of objective function
   genevalstr = [OBJ_F, '(x'];
   if ~any(OBJ_F < 48)
      for i = 1:nargin-3
         genevalstr = [genevalstr, ',P', int2str(i)];
      end
      genevalstr = [genevalstr, ')'];
   end

% Compute states of individual x
   x = chrom;
   [objval, t, x] = eval(genevalstr);

% look for figure, set Name
   figplotdopi = findobj('UserData', 'gatbxfigstateplot_plotdopi');
   if isempty(figplotdopi),
      figplotdopi = figure('UserData', 'gatbxfigstateplot_plotdopi', ...
                           'NumberTitle', 'Off');
   end
   set(figplotdopi,'Name', ...
       sprintf('Simulation results of %s in gen %g', OBJ_F(1:min(8, size(OBJ_F, 2))), gen));
   set(figplotdopi, 'defaultaxesfontname', 'times', 'defaultaxesfontsize', 8 )
   figure(figplotdopi);

% Get size of individual and states
   [Nind, Nvar] = size(chrom);
   [Nstep, Nstate] = size(x);

% plot of speed (state 1)
   subplot(2,2,1), plot(t, x(:,[1]), '-');
   title('Speed (state 1)');
   xlabel('time'), ylabel('speed');

% plot of position (state 2)
   subplot(2,2,2), plot(t, x(:,[2]), '-');
   title(['Position (state 2)']);
   xlabel('time'), ylabel('position');

% plot of speed and position
   subplot(2,2,3), plot(t, x(:,[1]), '-', t, x(:,[2]), '-.');
   title(['Speed (-) and Position (-.)']);
   xlabel('time'), ylabel('speed/position');

% plot of control
   subplot(2,2,4);
   plot(chrom);
   title('Control');
   xlabel('step'), ylabel('control');

   drawnow;


% End of function

