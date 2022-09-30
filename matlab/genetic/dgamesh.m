% Demo GA toolbox Mesh Plot of objective functions
%
% This function takes the name of an objective function and produces
% a mesh plot using the first 2 dimensions. This gives a first impression
% of the objective function and is particular useful in demos.
%
% Syntax:  dgamesh(OBJ_F)
%
% Input:
%    OBJ_F     - string with function name of objective function
%                if omitted, 'objfun1' is assumed
%
% Output:
%   no output
%
% See also: dgagraf

% Author:  Hartmut Pohlheim
% History: 15.03.95   file created 


function dgamesh(OBJ_F)

% Set default parameters
   if nargin < 1, OBJ_F = 'objfun1'; end

% Get bounds of objective function
   Bounds = feval(OBJ_F, [], 1);
   MinArea = Bounds(1, :);
   MaxArea = Bounds(2, :);

% Compute mesh values
   x = linspace(MinArea(1), MaxArea(1), 20);
   y = linspace(MinArea(2), MaxArea(2), 50);

   ValMesh = [];
   for iy = 1:max(size(y)),
      Chroms = [rep(y(iy), [max(size(x)), 1]), x'];
      ChVals = (feval(OBJ_F, Chroms))';
      ValMesh(iy, :) = ChVals;
   end

% look for figure, set Name
   figmesh = findobj('UserData', 'demogatoolbox_figmeshplot');
   if isempty(figmesh),
      figmesh = figure('UserData', 'demogatoolbox_figmeshplot');
   end
   figure(figmesh);
   set(figmesh, 'Name', [' Mesh Plot of ' feval(OBJ_F, [], 2)],...
                'NumberTitle', 'Off', ...
                'Position', [10 500 400 400],...
                'resize', 'on');
            
% Gernerate mesh plot
   mesh(x, y, ValMesh);

% End of function
