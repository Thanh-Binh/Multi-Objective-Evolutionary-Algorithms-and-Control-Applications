% Genetic Algorithm ToolBoX special INItialization
%
% Syntax:  FileName = gatbxini(ParaName, OBJ_F)
%
% Input parameter:
%    ParaName  - String containing the name of the parameter the file
%                name is needed for 
%    OBJ_F     - (optional) Name of objective function
%
% Output parameter:
%    FileName  - String containing the file name corresponding with
%                the input parameter
%
% See also: chekgopt, genalg1

% Author:     Hartmut Pohlheim
% History:    30.05.95     file created


function FileName = gatbxini(ParaName, OBJ_F);

% Check input parameters
   if (nargin < 1), ParaName = []; end
   if isempty(ParaName), ParaName = 'save_output'; end
   if (nargin < 2), OBJ_F = []; end

% Assign desired file names
   if strcmp(lower(ParaName), 'save_output'),
      FileName = 'gtxres02.txt';
   elseif  strcmp(lower(ParaName), 'init_function'),
      FileName = [];
   elseif  strcmp(lower(ParaName), 'state_plot'),
      if strcmp(lower(OBJ_F), 'objint3d'),
         eval('FileName = ''plotsat1'';');
      elseif strcmp(lower(OBJ_F), 'objgsabi'),
         eval('FileName = ''plotgem1'';');
      elseif strcmp(lower(OBJ_F), 'objdopi'),
         eval('FileName = ''plotdopi'';');
      else error('Undefined objective function name!');
      end
   else error('Undefined parameter name!');
   end


% End of function

