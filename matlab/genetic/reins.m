% RE-INSertion of offspring in population replacing parents
%
% This function performs insertion of offspring into the current 
% population, replacing parents with offspring and returning the
% resulting population.
% The offspring are contained in the matrix SelCh and the parents 
% in the matrix Chrom. Each row in Chrom and Selch corresponds
% to one individual.
% If the objective values of the population (ObjVCh) and the
% offspring (ObjVSel) are input parameter and ObjVCh is output
% parameter the objective values are copied, according to the
% insertion of offspring, saving the recomputation of the objective
% values for the whole population. The function can handle multiple
% objective values per individual. 
% For fitness-based reinsertion the fitness values/ranking of the
% population (RankCh) is needed. If omitted or empty single objective
% scaling using the first column of ObjVCh is assumed.
% If the number of offspring is greater than the number of offspring
% to reinsert the fitness values/ranking of the offspring (RankSel)
% is needed. If omitted or empty single objective scaling using the
% first column of ObjVSel is assumed.
%
% Syntax:  [Chrom, ObjVCh] = reins(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel, RankCh, RankSel)
%
% Input parameters:
%    Chrom     - Matrix containing the individuals (parents) of the current
%                population. Each row corresponds to one individual.
%    SelCh     - Matrix containing the offspring of the current
%                population. Each row corresponds to one individual.
%    SUBPOP    - (optional) Number of subpopulations
%                if omitted or NaN, 1 subpopulation is assumed
%    InsOpt    - (optional) Vector containing the insertion method parameters
%                InsOpt(1): Select - number indicating kind of insertion
%                           0 - uniform insertion
%                           1 - fitness-based insertion
%                           if omitted or NaN, 0 is assumed
%                InsOpt(2): INSR - Rate of offspring to be inserted per
%                           subpopulation (% of subpopulation)
%                           if omitted or NaN, 1.0 (100%) is assumed
%    ObjVCh    - (optional) Column vector or matrix containing the objective values
%                of the individuals (parents - Chrom) in the current population,
%                needed for fitness-based insertion
%                saves recalculation of objective values for population
%    ObjVSel   - (optional) Column vector or matrix containing the objective values
%                of the offspring (SelCh) in the current population, needed for
%                partial insertion of offspring,
%                saves recalculation of objective values for population
%    RankCh    - (optional) Column vector containing the fitness values (obtained
%                by ranking) of the individuals (parents - Chrom) in the current
%                population, best individual has highest value,
%                if omitted or empty, single objective scaling using ObjVCh is assumed
%    RankSel   - (optional) Column vector containing the fitness values (obtained
%                by ranking) of the offspring (SelCh) in the current
%                population, best offspring has highest value
%                if omitted or empty, single objective scaling using ObjVSel is assumed
%
% Output parameters:
%    Chrom     - Matrix containing the individuals of the current
%                population after reinsertion.
%    ObjVCh    - if ObjVCh and ObjVSel are input parameter, than column vector containing
%                the objective values of the individuals of the current
%                generation after reinsertion.
%
% See also: reinsloc, select, ranking

% Author:     Hartmut Pohlheim
% History:    10.03.94     file created
%             19.03.94     parameter checking improved
%             07.06.95     rank based reinsertion possible (used for 
%                          reinsertion with multiobjective problems)
%             08.06.95     long description added


function [Chrom, ObjVCh] = reins(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel, RankCh, RankSel, Dummy);

% Check parameter consistency
   if nargin < 2, error('Not enough input parameter'); end

   [NindP, NvarP] = size(Chrom);
   [NindO, NvarO] = size(SelCh);

   if nargin == 2, SUBPOP = 1; end
   if nargin > 2,
      if isempty(SUBPOP), SUBPOP = 1;
      elseif isnan(SUBPOP), SUBPOP = 1;
      elseif length(SUBPOP) ~= 1, error('SUBPOP must be a scalar'); end, end
   end

   if (NindP/SUBPOP) ~= fix(NindP/SUBPOP), error('Chrom and SUBPOP disagree'); end
   if (NindO/SUBPOP) ~= fix(NindO/SUBPOP), error('SelCh and SUBPOP disagree'); end
   NIND = NindP/SUBPOP;  % Compute number of individuals per subpopulation
   NSEL = NindO/SUBPOP;  % Compute number of offspring per subpopulation

   if nargin < 4, InsOpt = []; end   
   if isnan(InsOpt), InsOpt = []; end
   if isempty(InsOpt), INSR = 1.0; Select = 0;   
   else
      INSR = NaN; Select = NaN;
      if (length(InsOpt) > 2), error('Parameter InsOpt too long'); end
      if (length(InsOpt) >= 1), Select = InsOpt(1); end
      if (length(InsOpt) >= 2), INSR = InsOpt(2); end
      if isnan(Select), Select = 0; end
      if isnan(INSR), INSR = 1.0; end
   end
   
   IsObjVCh = 0; IsObjVSel = 0;
   if nargin > 4, 
      if ~isempty(ObjVCh), 
         [mO, nO] = size(ObjVCh);
         if NindP ~= mO, error('Chrom and ObjVCh disagree'); end
         IsObjVCh = 1;
      end
   end
   if nargin > 5, 
      if ~isempty(ObjVSel)
         [mO, nO] = size(ObjVSel);
         if NindO ~= mO, error('SelCh and ObjVSel disagree'); end
         IsObjVSel = 1;
      end
   end

   if (nargout == 2 & (IsObjVCh == 0 | IsObjVSel == 0)),
      error('Input parameter ObjVCh and/or ObjVSel for output of ObjVCh missing!');
   end

   IsRankCh = 0; IsRankSel = 0;
   if nargin > 6, 
      if ~isempty(RankCh), 
         [mO, nO] = size(RankCh);
         if nO ~= 1, error('RankCh must be a column vector'); end
         if NindP ~= mO, error('Chrom and RankCh disagree'); end
         IsRankCh = 1;
      end
   end
   if nargin > 7, 
      if ~isempty(RankSel), 
         [mO, nO] = size(RankSel);
         if nO ~= 1, error('RankSel must be a column vector'); end
         if NindO ~= mO, error('SelCh and RankSel disagree'); end
         IsRankSel = 1;
      end
   end
       
   if (INSR < 0 | INSR > 1), error('Parameter for insertion rate must be a scalar in [0, 1]'); end
   if (INSR < 1 & (IsObjVSel == 0 & IsRankSel == 0)),
      error('For selection of offspring ObjVSel/RankSel is needed');
   end 
   if (Select ~= 0 & Select ~= 1), error('Parameter for selection method must be 0 or 1'); end
   if (Select == 1 & (IsObjVCh == 0 & IsRankCh == 0)),
      error('ObjVCh/RankCh for fitness-based exchange needed');
   end

   if INSR == 0, return; end
   NIns = min(max(floor(INSR*NSEL+.5),1),NIND);   % Number of offspring to insert   

% If no rank values are provided; produce them assuming single objective problems
   if Select == 1, if IsRankCh == 0, RankCh = -ObjVCh(:,1); end, end
   if NIns < NSEL, if IsRankSel == 0, RankSel = -ObjVSel(:,1); end, end

% perform insertion for each subpopulation
   for irun = 1:SUBPOP,
      % Calculate positions in old subpopulation, where offsprings are inserted
         if Select == 1,    % fitness-based reinsertion
            [Dummy, ChIx] = sort(RankCh((irun-1)*NIND+1:irun*NIND));
         else               % uniform reinsertion
            [Dummy, ChIx] = sort(rand(NIND,1));
         end
         PopIx = ChIx((1:NIns)')+ (irun-1)*NIND;
      % Calculate position of Nins-% best offspring
         if (NIns < NSEL),  % Select best offspring
            [Dummy,OffIx] = sort(-RankSel((irun-1)*NSEL+1:irun*NSEL));
         else              
            OffIx = (1:NIns)';
         end
         SelIx = OffIx((1:NIns)')+(irun-1)*NSEL;
      % Insert offspring in subpopulation -> new subpopulation
         Chrom(PopIx,:) = SelCh(SelIx,:);
         if (IsObjVCh == 1 & IsObjVSel == 1), ObjVCh(PopIx,:) = ObjVSel(SelIx,:); end
   end


% End of function
