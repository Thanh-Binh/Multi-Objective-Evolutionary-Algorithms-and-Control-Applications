function ext=textent(txtobj)
%TEXTENT Obtains platform independent text extent property.
%       EXT = TEXTENT(TXTOBJ) estimates a platform independent extent of
%       the text object TXTOBJ.  EXT is returned as a four element vector of
%       the same form the Handle Graphics extent property returns --
%       the lower left x and y positions, the width and the height of the
%       text object.
%
%       This function uses the alignment of the given text object to compute
%       the platform independent extent.  The object is re-aligned to
%       different positional extremes and the resulting two extent 
%       properties are used to determine the "true" extent.  This process is
%       slow and isn't completely independent of the platform.  It does,
%       however, result in an extent which is closer to being platform
%       independent than the Handle Graphics 'extent' text property.
%
%       This function should only be used where platform independence is
%       very important.
%
%       See also GET and TEXT.



% Error checking.
if ~strcmp(get(txtobj, 'type'), 'text')
   error('Argument must be a text object.')
end

% Create some test objects with the given properties.
savpos = get(txtobj, 'position');
savvalign = get(txtobj, 'verticalalignment');
savhalign = get(txtobj, 'horizontalalignment');
savvis = get(txtobj, 'visible');
s0 = get(txtobj, 'extent');

% First find the upper left corner of the actual extent.
set(txtobj, 'position', savpos, 'verticalalignment', 'baseline',...
            'visible', 'off', 'horizontalalignment', 'left');
s1 = get(txtobj, 'extent');
set(txtobj, 'position', savpos, 'verticalalignment', 'top',...
            'horizontalalignment', 'right');
s2 = get(txtobj, 'extent');

ext = [(savpos(1:2)-(s1(1:2)-s0(1:2))) abs(s1(1:2)-s2(1:2))];

% Set the object back to the original properties.
set(txtobj, 'position', savpos, 'verticalalignment', savvalign,...
            'visible', savvis, 'horizontalalignment', savhalign);







