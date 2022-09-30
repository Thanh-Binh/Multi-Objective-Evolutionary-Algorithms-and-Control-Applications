function [xa,sigma,gf,MutationSuccess]=esmutint(x,xa,sigma,gf,nwwindex,xrange,FunName,Par);
% [xa,sigma,gf,MutationSuccess]=esmutint(x,xa,sigma,gf,nwwindex,xrange,FunName,Par);
%
% Integer Mutation


nvars        = Par(1);
NumMutation  = Par(3);
NumOffsMut   = Par(4);

MutationSuccess=1;
xout=x(:);

for  MutIter=1:NumMutation*NumOffsMut,
      xout=randperm(nvars)';
      x(:)=xout;
      gfi=feval(FunName,x); 
      xa=[xa,xout];gf=[gf,gfi];sigma=[sigma,ones(nvars,1)];
end

