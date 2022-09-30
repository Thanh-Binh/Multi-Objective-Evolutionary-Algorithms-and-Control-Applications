function  ES=esoptions()
% ES=esoptions()
% Evolution Strategy OPTIONS

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


%Set default Parameters of the Evolution Strategy

ES.parameter(1)=100;    % Number of Individuals (Population Size)
ES.parameter(2)=5;      % Number of feasible Niches
ES.parameter(3)=10;     % Number of Reproductions per Generation
ES.parameter(4)=10;     % Number of Mutations/Generation
ES.parameter(5)=10;     % Number of offspring/Mutation
ES.parameter(6)=1e-5;   % Precision   
ES.parameter(7)=0;      % No evolution in step   
ES.parameter(8)=.6;     % Choosing factor for Reproduction
ES.parameter(9)=.8;     % Reproductions -Lethalfactor
ES.parameter(10)=.7;    % Mutation-Letalfactor
ES.parameter(11)=2;     % Exponent for Niches
ES.parameter(12)=.5;    % Required Gen-Diversity (obsolete)
ES.parameter(13)=2;     % 2 - Normaly Distribution
                        % 1 - uniform
ES.parameter(14)=5;     % dispersion
ES.parameter(15)=1;     % 1 - display in Matlab command window
                        % 0 - no display
ES.parameter(16)=0;     % 0 - no display in GUI
                        % 1 - display in the parameter space
                        % 2 - display in the objective space
                        % 31 - display only the current generation on the upper 
                        %     right in the parameter space (only used for evolut1)
                        % 32 - display only the current generation on the upper 
                        %     right in the objective space (only used for evolut1) 
ES.parameter(17)=50;    % Maximum number of generations
ES.parameter(18)=.02;   % Successful Mutation Rat, i.e.,
                        % Mutation is so called successfully if 2 percent
                        % mutations are successful
ES.parameter(19)=5;     % Number of unfeasible Niches   
ES.parameter(20)=1e-1;  % Relaxing rate for feasible region   

% Set algorithms for the evolution strategy
ES.algorithm.mutation='SelfAdapt';
ES.algorithm.reproduction='Combi';
ES.algorithm.selection='Fitness';
ES.algorithm.setpop='Standard';
ES.algorithm.legend=ones(1,4); 
                            % index for evolutionary algorithms chosen by user
ES.algorithm.niche=1;       % 1 (0) if niche methods is used (or not)

% Set the file name for saving the temporary variables
ES.file.funtmp  ='esftmp';  % name of file containing algorithms for computing
                            % objectives and constraints
ES.file.mattmp  ='esmtmp';  % temporary mat-file
ES.file.matend  ='esmend';  % end mat-file
ES.file.matopt  ='esmopt';  % mat-file for temporary options

% Set graphical variables
ES.graphic={};              % Default: no main figure of ES
                            % ES.graphic =ghnd; 
                            %    (graphical handles for the main figure of ES)

% Medium to save immediate results when the evolution strategy
% is called from other programs. Deafult: No medium
ES.medium=NaN;
