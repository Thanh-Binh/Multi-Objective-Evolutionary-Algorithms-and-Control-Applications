function ESPop=setpopul(OptTask,ES)
% ESPop=setpopul(OptTask,ES)
%
% Set the first Population for the Evolution Strategy
%
% See Also: EVOLUT.M, EVOLSTR.M

% All Rights Reserved, Oct. 1996 
% To Thanh Binh IFAT Uni. of Magdeburg Germany


x=OptTask.x;
ESPop.dim=size(x);

xout=x(:);
nvars=length(xout);
nI=ES.parameter(1);
xrange=OptTask.xrange;
dispersion=ES.parameter(14);

SetPopAlg=ES.algorithm.setpop;
if strcmp(SetPopAlg,'Standard'),
    ESPop=setpopstandard(x,xout,nvars,nI,xrange,dispersion,ES,ESPop);
elseif strcmp(SetPopAlg,'Integer'),
    gfanf=[];
    for i=1:nI,
       x(:)=randperm(nvars)';   
       gf=feval(ES.file.funtmp,x);   % OptTask.p
       xa(:,i)=x(:);gfanf=[gfanf,gf]; 
    end;
    sigma=dispersion*rand(nvars,nI); 
    ESPop.x=xa;ESPop.s=sigma;ESPop.obj=gfanf;
    ESPop.generation=0;
    ESPop.dim=[ESPop.dim,size(gfanf,1)-1];

else
    esmsg('Not implemented','Error','error');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  ESPop=setpopstandard(x,xout,nvars,nI,xrange,dispersion,ES,ESPop);

xa=zeros(nvars,nI);
gfanf=[]; 
 
if ~isempty(xrange),
    xrange=xrange';
    Range=xrange(:,2)-xrange(:,1);
end

if ES.parameter(13)==1,
  for i=1:nI,
    resftest=0; 
    while ~resftest
       if isempty(xrange),
          x(:)=xout-dispersion*(ones(nvars,1)-2*rand(nvars,1)); 
          % uniform distribution in [-dispersion,dispersion]
       else,
          x(:)=xrange(:,1)+Range.*rand(nvars,1); 
       end
       gf=feval(ES.file.funtmp,x);   % OptTask.p
       if ~isinf(gf(1)), 
          xa(:,i)=x(:);gfanf=[gfanf,gf]; 
          resftest=1;
       end
    end;
  end
  sigma=dispersion*rand(nvars,nI);                          
  % each Indiv. has  a own strategy parameters

elseif ES.parameter(13)==2,
  for i=1:nI,
    resftest=0;
    while ~resftest
       if isempty(xrange),
          x(:)=xout+dispersion*randn(nvars,1);
       else,
          x(:)=xrange(:,1)+Range.*rand(nvars,1); 
       end
       gf=feval(ES.file.funtmp,x);
       if ~isinf(gf(1)), 
         xa(:,i)=x(:);gfanf=[gfanf,gf]; 
         resftest=1;
       end
    end;
  end
  sigma=abs(dispersion*randn(nvars,nI));

end

% check for the upper boundaries of sigma
if ~isempty(xrange),   % Strategy parameters shouldn't be bigger than 
                       % the size of the search space
  SigmaMax=.5*Range(:,ones(1,nI));
  SigmaBiggerIndex=sigma>SigmaMax;
  sigma=sigma.*(~SigmaBiggerIndex)+SigmaMax.*SigmaBiggerIndex;
end

% check for the lower boundaries of sigma
SigmaMin=.1;
for i=1:nvars,
  SmallValIndx=find(sigma(i,:)<SigmaMin);
  SmallValIndxLength=length(SmallValIndx); 
  if SmallValIndxLength, 
     sigma(i,SmallValIndx)=SigmaMin*ones(1,SmallValIndxLength);
  end
end
ESPop.x=xa;ESPop.s=sigma;ESPop.obj=gfanf;
ESPop.generation=0;
ESPop.dim=[ESPop.dim,size(gfanf,1)-1];
