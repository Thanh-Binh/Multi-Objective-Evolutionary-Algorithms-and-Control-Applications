function [xa,sigma,gf,MutationSuccess]=esmutbin(x,xa,sigma,gf,nwwindex,xrange,FunName,Par);
% [xa,sigma,gf,MutationSuccess]=esmutbin(x,xa,sigma,gf,nwwindex,xrange,FunName,Par);
%
% binary Mutation


nvars        = Par(1);
NumMutation  = Par(3);
NumOffsMut   = Par(4);

MutationSuccess=1;

for  MutIter=1:NumMutation*NumOffsMut,
      x=randperm(nvars);
      gfi=feval(FunName,x); 
      xa=[xa,x];gf=[gf,gfi];sigma=[sigma,ones(nvars,1)];
end

