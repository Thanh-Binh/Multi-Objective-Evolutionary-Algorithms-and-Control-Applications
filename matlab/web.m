function stat=web(html_file,waitForNetscape)
%WEB Open Web browser on site or files.
%   WEB URL opens a Web browser and loads the file or Web site specified
%   in the URL (Uniform Resource Locator).  The URL can be of any form
%   that your browser can support.  Generally, it can specify a local 
%   file or a Web site on the Internet.
%
%   STAT = WEB(...) returns the status of the WEB command in the variable
%   STAT. STAT = 0 indicates successful execution. STAT = 1 indicates that
%   the browser was not found. STAT = 2 indicates that the browser was
%   found, but could not be launched.
%
%   The Web browser used is specified in the DOCOPT M-file on UNIX and in
%   the preferences dialog on Windows and Macintosh.
%
%   Examples:
%      web file:/disk/dir1/dir2/foo.html
%         opens the file foo.html in your browser and
%
%      web(['file:' which('foo.html')])
%         will also work if the file is on the MATLAB path.
%
%      web http://www.mathworks.com
%         loads The MathWorks Web page into your browser.
%
%      web mailto:email_address
%         uses your browser to send mail.
%
%   See also DOC, DOCOPT and HTHELP.

%   Copyright (c) 1984-96 by The MathWorks, Inc.
%   $Revision: 1.17 $

% If no argument is specified, set html_file to [].
if nargin==0
  html_file = [];
end
if nargin==1,
  waitForNetscape=0;
end

% Initialize error status.
stat = 0;

% determine what computer we're on
if (~isunix & ~strncmp(computer,'MAC',3) & ~strncmp(computer, 'PC', 2))
    error(['Not yet available for this architecture: ', computer, '.'])
end

% get options
[doccmd,options] = docopt;

% open HTML file in browser
if isunix
   % The unix command has a bunch of problems when we try to handle errors.
   % Assume we submit to unix:
   %
   %    Mosiac file &
   %
   %    1. We don't know what shell is being used. It depends on the platform.
   %    2. The unix command does not save stderr
   %    3. You cannot save output since this blocks the return of the MATLAB
   %    prompt.
   %    4. You will always get the pid message and if there is a error message
   %    it will be cryptic one from the system.
   %    5. Status is always successful.
   %
   % Because of the above problems, there is no error handling. The user
   % will have to figure out things from the system error message.

   comm = ['sh -c ''' doccmd ' ' options ' -remote "openURL(' html_file ')" > /dev/null 2>&1 ''' ];

   if strmatch(doccmd, strvcat('netscape', 'Netscape'))
      lockfile=dir([getenv('HOME') '/.netscape']);
      if strmatch('lock',strvcat(lockfile.name),'exact')
         % if the netscape lock file exists than try to open 
         % html_file in an existing netscape session
         status = unix(comm);
      else
         status=1;
      end
   else
      % Mosaic or Arena must be the browser can not look for netscape lock file
      % To the best of my knowledge Mosaic & Arena don't support -remote  bmb
      % so just start a new session
      status=1;
   end

   if status
      % browser not running, then start it up.
      comm = ['sh -c ''' doccmd ' ' options ' ' html_file ' > /dev/null 2>1 &'''   ];
      status = unix(comm);
      if status
         stat = 1;
      end

      %
      % if waitForNetscape is nonzero, hang around in a loop until
      % netscape launches and connects to the X-server.  I do this by
      % exploiting the fact that the remote commands operate throuth the
      % netscape global translation table.  I chose 'undefined-key' as a
      % no-op to test for netscape being alive and running.
      %
      if waitForNetscape,
         comm = ['sh -c ''' doccmd ' ' options ' -remote "undefined-key()" > /dev/null 2>&1 '''];

         while ~status,
             status = unix(comm);
             pause(1);
         end
      end
    end

elseif (strncmp(computer,'MAC',3))
    % convert between Mac and URL file conventions
    if (strncmp(html_file,'file:',5))
        if (html_file(6) ~= '/')
            html_file = ['file:/' strrep(html_file(6:end),filesep,'/')];
        end
    end
    [doccmd,docsig] = system_dependent(16);
    stat = macurl(doccmd,docsig,html_file);

elseif (strncmp(computer,'PC',2))
    stat = ibrowse(html_file);
end



