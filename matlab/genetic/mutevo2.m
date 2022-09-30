% MUTation by EVOlutionary strategies 2, derandomized anisotropic adaptive
%
% This function performs derandomized anisotropic adaptive mutation
% (Ostermeier, TU Berlin). However, a different format for Chrom is
% needed. Thus, the function is NOT compatible with the normal version
% of the GA Toolbox.
%
% Syntax:  Chrom = mutevo2(OldChrom, Nopi)
%
%
% See also: mutevo1, mutevo3, mutate, mutbga, mut

% Author: Carlos Fonseca
% History:  ??.??.94   file created


function Chrom = mutevo2(OldChrom, Nopi);

% Get size of population
   [Nind, Lind] = size(OldChrom);

% Assume that there are NVar variables, NVar individual step-sizes,
% NVar direction components, one global isotropic step size and one
% global anisotropic step-size.
   NVar = (Lind-2)/3;

   if NVar ~= floor(NVar),
   	error('Individual length must be an odd number');
   end
   Noff = Nind*Nopi;

% Replicate parents Nopi times
   Var = rep(OldChrom(:,1:NVar),[Nopi 1]);
   Iss = rep(OldChrom(:,NVar+1:2*NVar),[Nopi 1]);
   Dir = rep(OldChrom(:,2*NVar+1:3*NVar),[Nopi 1]);
   Iso = rep(OldChrom(:,Lind-1),[Nopi 1]);
   Ani = rep(OldChrom(:,Lind),[Nopi 1]);

% Mutate Vars
   Xi = 1+.1*randn(Noff,1);
   Z = randn(Noff,NVar);
   Phi = randn(Noff,1);
   Pert = Iss .* ( ...
   	  rep(Xi .* Iso, [1 NVar]) .* Z + ...
   	  rep(Phi .* Ani, [1 NVar]) .* Dir);
   Var = Var+Pert;

% Update Averages (total forgetting)
   Zbar = rep(Xi, [1 NVar]) .* Z;

   Tbar = Pert ./ Iss ./ sqrt( rep((Xi.*Iso).^2,[1 NVar]) + ...
				(rep(Ani,[1 NVar]).*Dir).^2  );

% Update parameters 
   Dir = Dir + (rep(Phi-1,[1 NVar]).*Dir + rep(Xi.*Iso./Ani,[1 NVar]) .* Z ...
   							 )*sqrt(.25/NVar);
   Dir = Dir ./ rep(sqrt(sum(Dir'.^2)'./NVar),[1 NVar]);

   Iso = Iso .* exp( ...
   		rep(sqrt(sum(Z'.^2)'./NVar) - 1 + 1/5/NVar,[1 1]) ...
   			).^sqrt(1/NVar);

   Ani = Ani .* (abs(Phi) + .35).^sqrt(.25/NVar);


   Iss = Iss .* (abs(Tbar) + .35).^(1/NVar);


% Build new chromosomes
   Chrom = [Var Iss Dir Iso Ani];


% End of function
