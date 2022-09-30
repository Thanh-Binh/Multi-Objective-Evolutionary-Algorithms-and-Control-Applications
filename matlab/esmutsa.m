function [xa,sigma,gf,MutationSuccess]=esmutsa(x,xa,sigma,gf,nwwindex,xrange,FunName,Par);
% [xa,sigma,gf,MutationSuccess]=esmutsa(x,xa,sigma,gf,nwwindex,xrange,FunName,Par);
%
% Self-adaptation Mutation


nvars        = Par(1);
mf           = Par(2);
NumMutation  = Par(3);
NumOffsMut   = Par(4);
Lambda       = Par(5);          % ES.parameter(10)
ConstSatisfy = Par(6);          % ESPop.ConstSatisfy
UF_best_g    = Par(7);
MutRate      = Par(8);          % ES.parameter(18)
alpha        = Par(9);
alpha1       = Par(10);
SigmaMin     = Par(11);

xout    = x(:); 

coeff=2;
Tau1=coeff/sqrt(2*sqrt(nvars));
Tau2=coeff/sqrt(2*nvars);

if ~isempty(xrange),
   XFieldRange=.5*(xrange(2,:)-xrange(1,:))';
end

MutationSuccess=0;

for  MutIter=1:NumMutation,

   nww    = nwwindex(MutIter);    % Index for the parent individual 
   x_anf  = xa(:,nww);            % its position
   sigmaj = sigma(:,nww);         % its dispersion (know-how)
   gfa    = gf(:,nww);            % its fitness

   nlb=0;
   gflb=zeros(mf+1,1);xlb=zeros(nvars,1);slb=zeros(nvars,1);

   for i=1:NumOffsMut,

      Bsigma= exp(Tau1*randn)*sigmaj .* exp(Tau2*randn(nvars,1));
      xout=x_anf + Bsigma .* randn(nvars,1);

      x(:)=xout;            
      gfi=feval(FunName,x); viable=0;
      if ConstSatisfy,

         if ~gfi(1),               % signal for viability is gfi(1)==0
            if mf,
               if any(gfa(2:mf+1)-gfi(2:mf+1) * Lambda >0), 
                  viable=1;
               end
            else,
               viable=1;
            end
         end 
 
      else,                   
         if ~isinf(gfi(1)),         % signal for viability is gfi(1)~=inf
            if ((gfa(1) > gfi(1)* Lambda)|((~gfa(1))&(gfi(1)<=UF_best_g))), 
                viable=1;
            end
         end
      end
      if viable,
         xlb=[xlb,xout];    gflb=[gflb,gfi];
         slb=[slb,sigmaj];  nlb=nlb+1;
      end

   end


   if nlb,
      xlb(:,1)=[]; slb(:,1)=[]; gflb(:,1)=[];
      if nlb/NumOffsMut >.2 ,
         slb   =slb/alpha1;    MutationSuccess=MutationSuccess+1;
         sigmaj=sigmaj/alpha1;
      elseif nlb/NumOffsMut <.2
         slb=slb*alpha;sigmaj=sigmaj*alpha;
      end
      % check for the upper boundaries of sigma
      if ~isempty(xrange),   % Strategy parameters shouldn't be bigger than the 
                             % size of the search space
         SigmaMax=XFieldRange(1:nvars,ones(1,nlb));
         SigmaBiggerIndex=slb>SigmaMax;
         slb=slb.*(~SigmaBiggerIndex)+SigmaMax.*SigmaBiggerIndex;      

         SigmaBiggerIndex=sigmaj>XFieldRange;
         sigmaj=sigmaj.*(~SigmaBiggerIndex)+XFieldRange.*SigmaBiggerIndex;
      end

      % check for the lower boundaries of sigma
      for i=1:nvars,
         SmallValIndx=find(slb(i,:)<SigmaMin);SmallValIndxLength=length(SmallValIndx); 
         if SmallValIndxLength, slb(i,SmallValIndx)=SigmaMin*ones(1,SmallValIndxLength);end
      end
      SmallValIndx=find(sigmaj<SigmaMin);SmallValIndxLength=length(SmallValIndx); 
      if SmallValIndxLength, sigmaj(SmallValIndx)=SigmaMin*ones(1,SmallValIndxLength);end      
      sigma(:,nww)=sigmaj;
      xa=[xa,xlb];gf=[gf,gflb];sigma=[sigma,slb];
   end

end

if (MutationSuccess >MutRate*NumMutation), 
   MutationSuccess=1;
else,
   MutationSuccess=0;
end



%
