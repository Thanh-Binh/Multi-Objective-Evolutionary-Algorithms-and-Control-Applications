% BINary string to INTeger string conversion
%
% This function decodes binary chromosomes into vectors of integers. The
% chromosomes are seen as the concatenation of binary strings of given
% length, and decoded into integer numbers in a specified interval using
% either standard binary or Gray decoding.
%
% Syntax:  Phen = bin2int(Chrom, FieldD)
%
% Input parameters:
%    Chrom     - Matrix containing the chromosomes of the current
%                population. Each line corresponds to one
%                individual's concatenated binary string
%                representation. Leftmost bits are MSb and
%                rightmost are LSb.
%    FieldD   -  Matrix describing the length and how to decode
%                each substring in the chromosome. It has the
%                following structure:
%                [len;      (num)
%                 lb;       (num)
%                 ub;       (num)
%                 code;     (0=binary     | 1=gray)
%                 scale;    (0=arithmetic | 1=logarithmic)
%                 lbin;     (0=excluded   | 1=included)
%                 ubin];    (0=excluded   | 1=included)
%
%                where
%                len   - row vector containing the length of
%                        each substring in Chrom. sum(len)
%                        should equal the individual length.
%                lb,
%                ub    - Lower and upper bounds for each variable. 
%                code  - binary row vector indicating how each
%                        substring is to be decoded.
%                scale - (not used, default to 0) binary row vector 
%                        indicating where to use arithmetic and/or
%                        logarithmic scaling.
%                lbin,
%                ubin  - (not used, default to 1) binary row vectors 
%                        indicating whether or not to include each bound 
%                        in the representation range
%
% Output parameter:
%    Phen     -  Integer matrix containing the population phenotypes.
%
% See also: crtbase, crtbp, crtrp, bin2real

% Author:     Hartmut Pohlheim
% History:    12.06.95     file created


function Phen = bin2int(Chrom, FieldD)

% Identify the population size (Nind) and the chromosome length (Lind)
   [Nind, Lind] = size(Chrom);

% Identify the number of decision variables (Nvar)
   [seven, Nvar] = size(FieldD);
   if seven ~= 7, error('FieldD must have 7 rows.'); end

% Get substring properties
   len = FieldD(1,:);
   lb = FieldD(2,:);
   ub = FieldD(3,:);
   code = ~(~FieldD(4,:));
   scale = zeros(size(len));     % ~(~FieldD(5,:));
   lin = ones(size(len));        % ~(~FieldD(6,:));
   uin = ones(size(len));        % ~(~FieldD(7,:));

% Check substring properties for consistency
   if sum(len) ~= Lind,
      error('Data in FieldD must agree with chromosome length');
   end

% Decode chromosomes
   Phen = zeros(Nind,Nvar);

   lf = cumsum(len);
   li = cumsum([1 len]);

   for i = 1:Nvar,
       idx = li(i):lf(i);
       if code(i) % Gray decoding
          Chrom(:,idx)=rem(cumsum(Chrom(:,idx)')',2);
       end
       Phen(:,i) = lb(i) + Chrom(:,idx) * (2 .^ [len(i)-1:-1:0])'
       Phen(:,i) = Phen(:,i) .* (Phen(:,i) <= ub(i)) + ub(i) .* (Phen(:,i) > ub(i))
   end


% End of function
