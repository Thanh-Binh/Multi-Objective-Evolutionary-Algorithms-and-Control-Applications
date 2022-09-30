% Demo of GA toolbox, Multi Population Genetic Algorithm
%
% This script implements the Multi Population Genetic Algorithm.
% Real valued or binary representation for the individuals is used.
% The script is called by the graphical interface of the 
% GA Toolbox (dgagraf).
%
% Syntax:  dgampga
%
% See also: dgagraf, dganew, dgamesh

% Author:     Hartmut Pohlheim
% History:    09.04.94     file created

if (gen == 0),

% Get boundaries of objective function
   FieldDR = feval(OBJ_F,[],1);
   NVAR = size(FieldDR,2);        % Get number of variables from objective function

% Get value of minimum, defined in objective function
   GlobalMin = feval(OBJ_F,[],3);

% Get title of objective function, defined in objective function
   FigTitle = [feval(OBJ_F,[],2) '   (' int2str(SUBPOP) ') '];
   if exist('figresplot'), figure(figresplot); else figure; end
   figresplot =gcf;
   set(figresplot, 'NumberTitle', 'Off', 'Name', FigTitle,...
                   'Position', [550 270 590 600]);
   clf;

% Clear Best  and storing matrix
   % Initialise Matrix for storing best results
      Best = NaN * ones(MAXGEN,3);
      Best(:,3) = zeros(size(Best,1),1);
   % Matrix for storing best individuals
      IndAll = [];
      ObjVAll = [];

% Build FieldDesciption for binary coding
   if CODEREAL,
      PRECI = 20;    % Precisicion of binary representation
      FieldDD = [rep([PRECI],[1, NVAR]);...
                 FieldDR;...
                 rep([1; 0; 1 ;1], [1, NVAR])];
   end

% Create binary/real population
   if CODEREAL, Chrom = crtbp(SUBPOP*NIND, NVAR*PRECI);
   else Chrom = crtrp(SUBPOP*NIND,FieldDR);
   end

% reset count variables
   gen = 1;
   termopt = 0;

% Calculate objective function for population
   if CODEREAL, ObjV = feval(OBJ_F,bin2real(Chrom, FieldDD));
   else ObjV = feval(OBJ_F,Chrom);
   end
   % count number of objective function evaluations
   Best(gen,3) = Best(gen,3) + NIND * SUBPOP;


else

% Iterate subpopulation till termination or MAXGEN
   while ((gen <= MAXGEN) & (termopt == 0)),

   % Save the best and average objective values and the best individual
      [Best(gen,1),ix] = min(ObjV);
      Best(gen,2) = mean(ObjV);
      IndAll = [IndAll; Chrom(ix,:)];
      ObjVAll = [ObjVAll; ObjV'];

   % Fitness assignement to whole population
      FitnV = ranking(ObjV,[SP RANKMETH],SUBPOP);

   % Select individuals from population
      [SelCh, SelIx] = select(SEL_F, Chrom, FitnV, GGAP, SUBPOP);
      SelIx;
   % Recombine selected individuals
      SelCh=recombin(XOV_F, SelCh, XOVR, SUBPOP);

   % Mutate offspring
      if CODEREAL, SelCh=mutate(MUT_F, SelCh, [], [MUTR], SUBPOP);
      else SelCh=mutate(MUT_F, SelCh, FieldDR, [MUTR MUTSHRINK], SUBPOP);
      end

   % Calculate objective function for offsprings
      if CODEREAL, ObjVOff = feval(OBJ_F,bin2real(SelCh, FieldDD));
      else ObjVOff = feval(OBJ_F,SelCh);
      end
      Best(gen,3) = Best(gen,3) + size(SelCh,1);

   % Insert offspring in population replacing parents
      if strcmp(SEL_F,'sellocal'),
         [Chrom, ObjV] = reinsloc(Chrom, SelCh, SUBPOP, [5 2], ObjV, ObjVOff, SelIx);
      else
         [Chrom, ObjV] = reins(Chrom, SelCh, SUBPOP, [1 INSR], ObjV, ObjVOff);
      end
      
   % Plot some results, rename title of figure for graphic output
      if ((rem(gen,PLOTTIME) == 1) | (rem(gen,MAXGEN) == 0) | (termopt == 1)),
         figure(figresplot);
         set(gcf,'Name',[FigTitle ' in ' int2str(gen)]);
         if CODEREAL,
            ShowChrom = bin2real(Chrom, FieldDD);
            ShowIndAll = bin2real(IndAll, FieldDD);
         else
            ShowChrom = Chrom; ShowIndAll = IndAll;
         end
         resplot(ShowChrom(1:2:size(ShowChrom,1),:),...
                 ShowIndAll(max(1,gen-3*PLOTTIME+1):size(ShowIndAll,1),:),...
                 [ObjV; GlobalMin], Best(max(1,gen-2*PLOTTIME+1):gen,[1]), gen);
      end

   % Check, if best objective value near GlobalMin -> termination criterion
   % compute differenz between GlobalMin and best objective value
      % ActualMin = abs(min(ObjV) - GlobalMin);
   % if ActualMin smaller than TERMEXACT --> termination
      % if ((ActualMin < (TERMEXACT * abs(GlobalMin))) | (ActualMin < TERMEXACT))
         % termopt = 1;
      % end   

   % Migrate individuals between subpopulations
      if ((termopt ~= 1) & (rem(gen,MIGGEN) == 0))
         [Chrom, ObjV] = migrate(Chrom, SUBPOP, [MIGR, MIGFIT, MIGTOPO], ObjV);
      end

      gen=gen+1;

   end

end

% Results
   % add number of objective function evaluations
      % Results = cumsum(Best(1:gen-1,3));
   % number of function evaluation, mean and best results
      % Results = [Results Best(1:gen-1,2) Best(1:gen-1,1)];
   
% Plot Results and show best individuals => optimum
   % figure('Name',['Results of ' FigTitle]);
   % subplot(2,1,1), plot(Results(:,1),Results(:,2),'-',Results(:,1),Results(:,3),':');
   % subplot(2,1,2), plot(IndAll(gen-5:gen-1,:)');
 

   % Select individuals from population
      % SelCh = select(SEL_F, Chrom, FitnV, GGAP, SUBPOP);
      
   % Recombine selected individuals
      % SelCh=recombin(XOV_F, SelCh, XOVR, SUBPOP);

   % Mutate offspring
      % if CODEREAL, SelCh=mutate(MUT_F, SelCh, [], [MUTR], SUBPOP);
      % else SelCh=mutate(MUT_F, SelCh, FieldDR, [MUTR MUTSHRINK], SUBPOP);
      % end
      

   % Calculate objective function for offsprings
      % if CODEREAL, ObjVOff = feval(OBJ_F,bin2real(SelCh, FieldDD));
      % else ObjVOff = feval(OBJ_F,SelCh);
      % end
      % Best(gen,3) = Best(gen,3) + size(SelCh,1);

   % Insert offspring in population replacing parents
      % [Chrom, ObjV] = reins(Chrom, SelCh, SUBPOP, [1 INSR], ObjV, ObjVOff);

      
% End of script

