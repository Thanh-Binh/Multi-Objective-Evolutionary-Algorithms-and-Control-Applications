function tfStr=wtfstr(W,ii,nW1)
% tfStr=wtfstr(W,ii,nW1)
% Format a weighting function matrix W into a transfer function string
%
% Used by w1ui and w2ui

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 




if nargin==2, % Weight W1
   tfstr1='';tfstr2='';tfstr3='';tfstr4='';
   if ii==1,np=1; else,np=sum(sum(W(1:ii-1,3:4)))+ii;end
   if all(~W(ii,2:4))
      tfstr2=[tfstr2,'p',num2str(np)];
   else
      if W(ii,1)==0,% poles and zeros
         tfstr1=[tfstr1,'p',num2str(np)];
         if W(ii,3),
            for j=1:W(ii,3),tfstr1=[tfstr1,'(s+p',num2str(np+j),')'];end,
         end
         if W(ii,2)==1,
            tfstr4='s';
         elseif(W(ii,2)>1),
            tfstr4=['s^',num2str(W(ii,2))];
         end
         if W(ii,4),
            for j=1:W(ii,4),tfstr4=[tfstr4,'(s+p',num2str(np+W(ii,3)+j),')'];end,
         end
      else % polynomials
         tfstr1=[tfstr1,'p',num2str(np)];
         if W(ii,3),
            for j=1:W(ii,3),
               if j==1,
                  tfstr1=[tfstr1,'+p',num2str(np+j),'s'];
               else
                  tfstr1=[tfstr1,'+p',num2str(np+j),'s^',num2str(j)];
               end
            end,
         end
         if W(ii,2)==1,
            tfstr4='s';
         elseif(W(ii,2)>1),
            tfstr4=['s^',num2str(W(ii,2))];
         end
         if W(ii,4),
            tfstr4=[tfstr4,'(1'];
            for j=1:W(ii,4),
               if j==1,
                  tfstr4=[tfstr4,'+p',num2str(np+W(ii,3)+j),'s'];
               else
                  tfstr4=[tfstr4,'+p',num2str(np+W(ii,3)+j),'s^',num2str(j)];
               end
            end,
            tfstr4=[tfstr4,')'];
         end
      end
   end

else % Weight W2
   tfstr1='';tfstr2='';tfstr3='';tfstr4='';
   if ii==1,
      np=1+nW1; 
   else,
      para=find(W(1:ii-1,1)<2);
      np=sum(sum(W(para,3:4)))+length(para)+nW1+1;
   end
   if W(ii,1)==0,% poles and zeros
      if all(~W(ii,3:4))
         tfstr2=[tfstr2,'p',num2str(np)];
      else
         tfstr1=[tfstr1,'p',num2str(np)];
         if W(ii,3),
            for j=1:W(ii,3),
               tfstr1=[tfstr1,'(s+p',num2str(np+j),')'];
            end,
         end % zeros
         if W(ii,4),
            for j=1:W(ii,4),
               tfstr4=[tfstr4,'(s+p',num2str(np+W(ii,3)+j),')'];
            end,
         end % poles
      end
   elseif W(ii,1)==1,% polynomials
      if all(~W(ii,3:4))
         tfstr2=[tfstr2,'p',num2str(np)];
      else
         tfstr1=[tfstr1,'p',num2str(np)];
         if W(ii,3),
            for j=1:W(ii,3),
               if j==1,
                  tfstr1=[tfstr1,'+p',num2str(np+j),'s'];
               else
                  tfstr1=[tfstr1,'+p',num2str(np+j),'s^',num2str(j)];
               end
            end,
         end
         if W(ii,4),
            tfstr4=[tfstr4,'(1'];
            for j=1:W(ii,4),
               if j==1,
                  tfstr4=[tfstr4,'+p',num2str(np+W(ii,3)+j),'s'];
               else
                  tfstr4=[tfstr4,'+p',num2str(np+W(ii,3)+j),'s^',num2str(j)];
               end
            end,
            tfstr4=[tfstr4,')'];
         end
      end
   elseif W(ii,1)==2,% unity
      tfstr2=[tfstr2,'1'];
   end
end
len_1=length(tfstr1);
len_4=length(tfstr4);

if len_1|len_4,
   tfstr2=[setstr(45*ones(1,max(len_1,len_4)))];
end
tfStr=str2mat(tfstr1,tfstr2,tfstr4);
