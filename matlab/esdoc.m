function esdoc()
%ESDOC A utility for loading HTML documentation into a Web browser.

evolut_dir=fwhich('evolut.m');
es_dir=evolut_dir(1:end-8);
esdoc_html=[es_dir 'html' filesep 'esdoc.html'];

% Load the correct HTML file into the browser.
stat = web(esdoc_html);
if (stat==2)
    error(['Could not launch Web browser. Please make sure that'  sprintf('\n') ...
        'you have enough free memory to launch the browser.']);
elseif (stat)
    error(['Could not load HTML file into Web browser. Please make sure that'  sprintf('\n') ...
        'you have a Web browser properly installed on your system.']);
end
