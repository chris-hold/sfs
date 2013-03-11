function ir = ir_wfs_25d(X,phi,xs,src,L,irs,conf)
%BRS_WFS_25D Generate a IR for WFS
%
%   Usage: ir_wfs = ir_wfs_25d(X,phi,xs,src,L,irs,[conf])
%
%   Input parameters:
%       X       - listener position (m)
%       phi     - listener direction [head orientation] (rad)
%                 0 means the head is oriented towards the x-axis.
%       xs      - virtual source position [ys > Y0 => focused source] (m)
%       src     - source type: 'pw' -plane wave
%                              'ps' - point source
%                              'fs' - focused source
%       L       - Length of loudspeaker array (m)
%       irs     - IR data set for the secondary sources
%       conf    - optional configuration struct (see SFS_config)
%
%   Output parameters:
%       ir      - Impulse response for the desired WFS array (nx2 matrix)
%
%   IR_WFS_25D(X,phi,xs,src,L,irs,conf) calculates a binaural room impulse
%   response for a virtual source at xs for a virtual WFS array and a
%   listener located at X.
%
% see also: brs_wfs_25d, ir_point_source, auralize_ir

%*****************************************************************************
% Copyright (c) 2010-2013 Quality & Usability Lab, together with             *
%                         Assessment of IP-based Applications                *
%                         Deutsche Telekom Laboratories, TU Berlin           *
%                         Ernst-Reuter-Platz 7, 10587 Berlin, Germany        *
%                                                                            *
% Copyright (c) 2013      Institut fuer Nachrichtentechnik                   *
%                         Universitaet Rostock                               *
%                         Richard-Wagner-Strasse 31, 18119 Rostock           *
%                                                                            *
% This file is part of the Sound Field Synthesis-Toolbox (SFS).              *
%                                                                            *
% The SFS is free software:  you can redistribute it and/or modify it  under *
% the terms of the  GNU  General  Public  License  as published by the  Free *
% Software Foundation, either version 3 of the License,  or (at your option) *
% any later version.                                                         *
%                                                                            *
% The SFS is distributed in the hope that it will be useful, but WITHOUT ANY *
% WARRANTY;  without even the implied warranty of MERCHANTABILITY or FITNESS *
% FOR A PARTICULAR PURPOSE.                                                  *
% See the GNU General Public License for more details.                       *
%                                                                            *
% You should  have received a copy  of the GNU General Public License  along *
% with this program.  If not, see <http://www.gnu.org/licenses/>.            *
%                                                                            *
% The SFS is a toolbox for Matlab/Octave to  simulate and  investigate sound *
% field  synthesis  methods  like  wave  field  synthesis  or  higher  order *
% ambisonics.                                                                *
%                                                                            *
% http://dev.qu.tu-berlin.de/projects/sfs-toolbox       sfstoolbox@gmail.com *
%*****************************************************************************


%% ===== Checking of input  parameters ==================================
nargmin = 6;
nargmax = 7;
narginchk(nargmin,nargmax);
if nargin==nargmax-1
    conf = SFS_config;
end
[X,xs] = position_vector(X,xs);
if conf.debug
    isargscalar(phi);
    isargpositivescalar(L);
    isargchar(src);
    check_irs(irs);
end


%% ===== Configuration ===================================================
xref = conf.xref;


%% ===== Computation =====================================================
% Get secondary sources
x0 = secondary_source_positions(L,conf);
x0 = secondary_source_selection(x0,xs,src,xref);
% Generate tapering window
win = tapering_window(x0,conf);

% Get driving signals
[d,delay] = driving_function_imp_wfs_25d(x0,xs,src,conf);
% Apply tapering window
d = bsxfun(@times,d,win');

% generate the impulse response for WFS
ir = ir_generic(X,phi,x0,d,irs,conf);
