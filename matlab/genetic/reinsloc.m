% RE-INSertion of offspring in population replacing parents LOCal
%
% This function performs local insertion of offspring into the current 
% population, replacing parents with offspring and returning the
% resulting population. If sellocal was used for selection, reinsloc
% must be used for reinsertion. This is the only chance to
% keep the local neighbourhood unchanged.
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
% Syntax:  [Chrom, ObjVCh] = reinsloc(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel, RankCh, RankSel, SelIx)
%
% Input parameters:
%    Chrom     - Matrix containing the individuals (parents) of the current
%                population. Each row corresponds to one individual.
%    SelCh     - Matrix containing the offspring of the current
%                population. Each row corresponds to one individual.
%    SUBPOP    - (optional) Number of subpopulations
%                if omitted or NaN, 1 subpopulation is assumed
%    InsOpt    - (optional) Vector containing the insertion method parameters
%                InsOpt(1): SELKIND - number indicating kind of insertion
%                           0 - every offspring replace randomly
%                           1 - every offspring replace weakest
%                           2 - fitter than weakest replace weakest
%                           3 - fitter than weakest replace parents
%                           4 - fitter than weakest replace randomly
%                           5 - fitter than parent replace parent
%                           if omitted or NaN, 1 is assumed
%                InsOpt(2): SELSTRUCT - Structure of neighbourhood
%                           identical to neighbourhood in local selection
%                           0 - linear, full
%                           1 - linear, half;
%                           2 - torus, full star
%                           3 - torus, half star
%                           if omitted or NaN, 0 is assumed
%    ObjVCh    - (optional) Column vector containing the objective values
%                of the individuals (parents - Chrom) in the current population,
%                needed for fitness-based insertion
%                saves recalculation of objective values for population
%    ObjVSel   - (optional) Column vector containing the objective values
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
%    SelIx     - Matrix containing indices of selected parents in Chrom, output parameter
%                of select/sellocal
%
% Output parameters:
%    Chrom     - Matrix containing the individuals of the current
%                population after reinsertion.
%    ObjVCh    - if ObjVCh and ObjVSel are input parameter, than column vector containing
%                the objective values of the individuals of the current
%                generation after reinsertion.
%
% See also: reins, sellocal, select, ranking

% Author:     Hartmut Pohlheim
% History:    09.09.94     file created
%             11.09.94     vectorization of all loops
%             07.06.95     rank based reinsertion possible (used for 
%                          reinsertion with multiobjective problems) 
%             08.06.95     long description added


function [Chrom, ObjVCh] = reins(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel, RankCh, RankSel, SelIx);

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
   if isempty(InsOpt), SELSTRUCT = 0; SELKIND = 1;   
   else
      SELSTRUCT = NaN; SELKIND = NaN;
      if (length(InsOpt) > 2), error('Parameter InsOpt too long'); end
      if (length(InsOpt) >= 1), SELKIND = InsOpt(1); end
      if (length(InsOpt) >= 2), SELSTRUCT = InsOpt(2); end
      if isnan(SELKIND), SELKIND = 1; end
      if isnan(SELSTRUCT), SELSTRUCT = 0; end
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
      if ~isempty(ObjVSel),
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

   IsSelIx = 0;       
   if nargin > 8, 
      if isempty(SelIx), IsSelIx = 0;
      elseif isnan(SelIx), IsSelIx = 0;
      else
         [mO, nO] = size(SelIx);
         if nO ~= 1, error('SelIx must be a column vector'); end
         if NindO ~= mO, error('SelCh and SelIx disagree'); end
         IsSelIx = 1;
      end
   end
   if IsSelIx == 0, error('Input parameter missing: SelIx'); end
          
   if (SELSTRUCT < 0 | SELSTRUCT > 3), error('Parameter for neighbourhood structure must be 0 to 3'); end
   if (SELKIND < 0 | SELKIND > 5), error('Parameter for insertion method must be 0 to 5'); end
   if (SELKIND >= 2 & (IsObjVSel == 0 & IsRankSel == 0)),
      error('For selection of offspring ObjVSel/RankSel is needed');
   end 
   if (SELKIND >= 1 & (IsObjVCh == 0 & IsRankCh == 0)),
      error('For selection of parents ObjVCh/RankCh is needed');
   end

% define window/deme size
   if (SELSTRUCT == 0 | SELSTRUCT == 1), 
      Nwin = max(1, floor(NIND^.25));
   else
      Nwin = max(1, floor((NIND^.25)/2));
      Nsq = ceil(sqrt(NIND));
   end

% If no rank values are provided; produce them assuming single objective problems
   if SELKIND >= 1, if IsRankCh == 0, RankCh = -ObjVCh(:,1); IsRankCh = 1;  end, end
   if SELKIND >= 2, if IsRankSel == 0, RankSel = -ObjVSel(:,1); IsRankSel = 1; end, end

% perform insertion for each subpopulation
   for irun = 1:SUBPOP,
      % copy according size of subpopulations
      ChromSub = Chrom((irun-1)*NIND+1:irun*NIND,:);
      SelChSub = SelCh((irun-1)*NSEL+1:irun*NSEL,:);
      if IsObjVCh == 1, ObjVChSub = ObjVCh((irun-1)*NIND+1:irun*NIND,:); end
      if IsObjVSel == 1, ObjVSelSub = ObjVSel((irun-1)*NSEL+1:irun*NSEL,:); end
      if IsRankCh == 1, RankChSub = RankCh((irun-1)*NIND+1:irun*NIND); end
      if IsRankSel == 1, RankSelSub = RankSel((irun-1)*NSEL+1:irun*NSEL); end
      SelIxSub = SelIx((irun-1)*NSEL+1:irun*NSEL,:)-((irun-1)*NIND);
      SelIxOdd = SelIxSub(1:2:size(SelIxSub,1)-1);
      SelIxOdd';

      % construct matrix according structure
      % Select indices of parent and neighbourhood
      % vector with all necessary indices
      if SELSTRUCT == 0,         % linear, full 
         MatInd2 = rep(SelIxOdd,[1,2*Nwin+1])+rep([-Nwin:Nwin],[size(SelIxOdd,1),1]);
         MatInd2 = MatInd2 + (MatInd2 <= 0)*NIND - (MatInd2 > NIND)*NIND;
      elseif SELSTRUCT == 1,    % linear, half
         MatInd2 = rep(SelIxOdd,[1,Nwin+1])+rep([0:Nwin],[size(SelIxOdd,1),1]);
         MatInd2 = MatInd2 - (MatInd2 > NIND)*NIND;
      elseif SELSTRUCT == 2,    % torus, full star
         Index2 = [-Nsq*Nwin:Nsq:-Nsq, -Nwin:Nwin,Nsq:Nsq:Nsq*Nwin];
         MatInd2 = rep(SelIxOdd,[1,4*Nwin+1])+rep(Index2,[size(SelIxOdd,1),1]);
         MatInd2 = MatInd2 + (MatInd2 <= 0)*NIND - (MatInd2 > NIND)*NIND;
      else     % if SELSTRUCT == 3,    % torus, half star
         Index2 = [0:Nwin,Nsq:Nsq:Nsq*Nwin];
         MatInd2 = rep(SelIxOdd,[1,2*Nwin+1])+rep(Index2,[size(SelIxOdd,1),1]);
         MatInd2 = MatInd2 - (MatInd2 > NIND)*NIND;
      end

      % Select according structure
      if SELKIND == 0,       % every offspring replace randomly from all
         % Select randomly individuals (parents) in neighbourhood
         [Dummy, INSCh] = sort(rand(size(MatInd2))');
         INSCh = (INSCh([1,2],:)'-1)*size(MatInd2,1)+[1:size(MatInd2,1);1:size(MatInd2,1)]';
         INSCh = MatInd2(INSCh)';
         INSCh = INSCh(1:size(INSCh,1)*size(INSCh,2))';
         % Select all offspring
         INSSel = [1:2*size(SelIxOdd,1)]';
      elseif SELKIND == 1,   % every offspring replace weakest from all 
         % Select weakest individuals (parents) in neighbourhood
         Temp1 = rep(RankChSub,[1,size(MatInd2,2)]);
         [Dummy, INSCh] = sort(-Temp1(MatInd2)');
         INSCh = (INSCh([1,2],:)'-1)*size(MatInd2,1)+[1:size(MatInd2,1);1:size(MatInd2,1)]';
         INSCh = MatInd2(INSCh)';
         INSCh = INSCh(1:size(INSCh,1)*size(INSCh,2))';
         % Select all offspring
         INSSel = [1:2*size(SelIxOdd,1)]';
      elseif SELKIND == 2,   % fitter than weakest replace weakest from all
         % Select weakest individuals (parents) in neighbourhood
         Temp1 = rep(RankChSub,[1,size(MatInd2,2)]);
         [Dummy, INSCh] = sort(-Temp1(MatInd2)');
         INSCh = (INSCh([1,2],:)'-1)*size(MatInd2,1)+[1:size(MatInd2,1);1:size(MatInd2,1)]';
         INSCh = MatInd2(INSCh)';
         INSCh = INSCh(1:size(INSCh,1)*size(INSCh,2))';
         % Select offspring fitter than weakest individual in neighbourhood
         INSSel = [1:2*size(SelIxOdd,1)]';
         TempMaxCh = max(Temp1(MatInd2)');
         TempMaxCh = TempMaxCh(rep(1:size(TempMaxCh,2),[2,1]))';
         TempMax3 = (TempMaxCh > RankSelSub(INSSel)).*[1:size(INSSel,1)]';
         TempMax3(TempMax3 == 0) = [];
         % Select according from all parents and offspring
         INSCh = INSCh(TempMax3);
         INSSel = INSSel(TempMax3);
      elseif SELKIND == 3,   % fitter than weakest replace parents
         % Select offspring fitter than weakest individual in neighbourhood
         INSSel = [1:2*size(SelIxOdd,1)]';
         Temp1 = rep(RankChSub,[1,size(MatInd2,2)]);
         TempMaxCh = max(Temp1(MatInd2)');
         TempMaxCh = TempMaxCh(rep(1:size(TempMaxCh,2),[2,1]))';
         TempMax3 = (TempMaxCh > RankSelSub(INSSel)).*[1:size(INSSel,1)]';
         TempMax3(TempMax3 == 0) = [];
         % Select according from all parents and offspring
         INSCh = SelIxSub(TempMax3);
         INSSel = INSSel(TempMax3);
      elseif SELKIND == 4,   % fitter than weakest replace randomly from all
         % Select randomly individuals (parents) in neighbourhood
         [Dummy, INSCh] = sort(rand(size(MatInd2))');
         INSCh = (INSCh([1,2],:)'-1)*size(MatInd2,1)+[1:size(MatInd2,1);1:size(MatInd2,1)]';
         INSCh = MatInd2(INSCh)';
         INSCh = INSCh(1:size(INSCh,1)*size(INSCh,2))';
         % Select offspring fitter than weakest individual in neighbourhood
         INSSel = [1:2*size(SelIxOdd,1)]';
         Temp1 = rep(RankChSub,[1,size(MatInd2,2)]);
         TempMaxCh = max(Temp1(MatInd2)');
         TempMaxCh = TempMaxCh(rep(1:size(TempMaxCh,2),[2,1]))';
         TempMax3 = (TempMaxCh > RankSelSub(INSSel)).*[1:size(INSSel,1)]';
         TempMax3(TempMax3 == 0) = [];
         % Select according from all parents and offspring
         INSCh = INSCh(TempMax3);
         INSSel = INSSel(TempMax3);
      else        % if SELKIND == 5,   % fitter than parents replace parents
         % Select randomly individuals (parents) in neighbourhood
         [Dummy, INSCh] = sort(rand(size(MatInd2))');
         INSCh = (INSCh([1,2],:)'-1)*size(MatInd2,1)+[1:size(MatInd2,1);1:size(MatInd2,1)]';
         INSCh = MatInd2(INSCh)';
         INSCh = INSCh(1:size(INSCh,1)*size(INSCh,2))';
         % Select offspring fitter than weakest individual in neighbourhood
         INSSel = [1:2*size(SelIxOdd,1)]';
         TempMax3 = (RankChSub(SelIxSub(INSSel)) > RankSelSub(INSSel)).*[1:size(INSSel,1)]';
         TempMax3(TempMax3 == 0) = [];
         % Select according from all parents and offspring
         INSCh = SelIxSub(TempMax3);
         INSSel = INSSel(TempMax3);
      end

      % if odd offspring reinsert last offspring
      if rem(NSEL,2) == 1,
         if SELKIND == 0,       % every offspring replace randomly
            INSSel = [INSSel; size(SelChSub,1)];
            INSCh = [INSCh; SelIxSub(NSEL)];
         else                   % if SELKIND == 1,   % fitter than parent
            if RankSelSub(size(SelChSub,1)) <= RankChSub(SelIxSub(NSEL)),
               INSSel = [INSSel; size(SelChSub,1)];
               INSCh = [INSCh; SelIxSub(NSEL)];
            end
         end
      end

      % Insert offspring in subpopulation -> new subpopulation
      ChromSub(INSCh,:) = SelChSub(INSSel,:);
      if (IsObjVCh == 1 & IsObjVSel == 1), ObjVChSub(INSCh,:) = ObjVSelSub(INSSel,:); end

      % copy new Chrom and ObjVCh back
      Chrom((irun-1)*NIND+1:irun*NIND,:) = ChromSub;
      if IsObjVCh == 1, ObjVCh((irun-1)*NIND+1:irun*NIND,:) = ObjVChSub; end
   end


% End of function
