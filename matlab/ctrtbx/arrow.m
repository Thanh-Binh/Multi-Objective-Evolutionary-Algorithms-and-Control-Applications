function arrow(x,y,Length,Type,HeadLength,Angle,Weight,Color)
% arrow(x,y,Length,Type,HeadLength,Angle,Weight,Color)
% Used to draw a arrow with
%   Length - Length of the arrow
%   Type   - Type of the arrow
%            'r' - right
%            'l' - left
%            'u' - up
%            'd' - down
%   HeadLength - Length of the arrow's head
%   Angle      - angel 


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin < 8, 
   Color='black';
   if nargin < 7,
     Weight='norm';
   end
end

Xarrow=HeadLength;
Yarrow=HeadLength*tan(Angle);

if Weight==2, Diff=.0000;else, Diff=0;end
switch Type,
  case 'r'
     tmp=x+Length;
     line([x tmp],[y y],'Color',Color,'LineWidth',Weight);
     y=y+Diff;
     line([tmp tmp-Xarrow],[y y+Yarrow],'Color',Color,'LineWidth',1);
     line([tmp tmp-Xarrow],[y y-Yarrow],'Color',Color,'LineWidth',1);

  case 'l'
     tmp=x-Length;
     line([x tmp],[y y],'Color',Color,'LineWidth',Weight);
     y=y+Diff;
     line([tmp tmp+Xarrow],[y y+Yarrow],'Color',Color,'LineWidth',1);
     line([tmp tmp+Xarrow],[y y-Yarrow],'Color',Color,'LineWidth',1);

  case 'u'
     tmp=y+Length;
     line([x x],[y tmp],'Color',Color,'LineWidth',Weight);
     line([x x-Yarrow],[tmp tmp-Xarrow],'Color',Color,'LineWidth',1);
     line([x x+Yarrow],[tmp tmp-Xarrow],'Color',Color,'LineWidth',1);
  case 'd'
     tmp=y-Length;
     line([x x],[y tmp],'Color',Color,'LineWidth',Weight);
     line([x x-Yarrow],[tmp tmp+Xarrow],'Color',Color,'LineWidth',1);
     line([x x+Yarrow],[tmp tmp+Xarrow],'Color',Color,'LineWidth',1);

end

