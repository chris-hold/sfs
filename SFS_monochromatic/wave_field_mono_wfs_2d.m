function [x,y,P,ls_activity] = wave_field_mono_wfs_2d(X,Y,xs,L,f,src,conf)
%WAVE_FIELD_MONO_WFS_25D simulates a wave field for 2D WFS
%
%   Usage: [x,y,P] = wave_field_mono_wfs_2d(X,Y,xs,L,f,src,conf)
%          [x,y,P] = wave_field_mono_wfs_2d(X,Y,xs,L,f,src)
%
%   Input parameters:
%       X           - length of the X axis (m); single value or [xmin,xmax]
%       Y           - length of the Y axis (m); single value or [ymin,ymax]
%       xs          - position of point source (m)
%       L           - array length (m)
%       f           - monochromatic frequency (Hz)
%       src         - source type of the virtual source
%                         'pw' - plane wave (xs, ys are the direction of the
%                                plane wave in this case)
%                         'ps' - point source
%                         'fs' - focused source
%       conf        - optional configuration struct (see SFS_config)
%
%   Output parameters:
%       x           - corresponding x axis
%       y           - corresponding y axis
%       P           - Simulated wave field
%
%   WAVE_FIELD_MONO_WFS_2D(X,Y,xs,L,f,src,conf) simulates a wave
%   field of the given source type (src) using a WFS 2 dimensional driving
%   function in the temporal domain. This means by calculating the integral for
%   P with a summation.
%   To plot the result use plot_wavefield(x,y,P).
%
%   References:
%       Spors2009 - Physical and Perceptual Properties of Focused Sources in
%           Wave Field Synthesis (AES127)
%       Williams1999 - Fourier Acoustics (Academic Press)
%
%   see also: plot_wavefield, driving_function_mono_wfs_2d

% AUTHOR: Hagen Wierstorf
% $LastChangedDate$
% $LastChangedRevision$
% $LastChangedBy$


%% ===== Checking of input  parameters ==================================
nargmin = 6;
nargmax = 7;
error(nargchk(nargmin,nargmax,nargin));
isargvector(X,Y);
xs = position_vector(xs);
isargpositivescalar(L,f);
isargchar(src);
if nargin<nargmax
    conf = SFS_config;
else
    isargstruct(conf);
end


%% ===== Configuration ==================================================
% xy resolution
xysamples = conf.xysamples;
% loudspeaker distance
dx0 = conf.dx0;
% Plotting result
useplot = conf.useplot;


%% ===== Variables ======================================================
% Setting x- and y-axis
[X,Y] = setting_xy_ranges(X,Y,conf);
% Geometry
x = linspace(X(1),X(2),xysamples);
y = linspace(Y(1),Y(2),xysamples);


%% ===== Computation ====================================================

% Calculate the wave field in time-frequency domain
%
% Get the position of the loudspeakers and its activity
x0 = secondary_source_positions(L,conf);
ls_activity = secondary_source_selection(x0,xs,src);
% Generate tapering window
win = tapwin(L,ls_activity,conf);
ls_activity = ls_activity .* win;
% Create a x-y-grid to avoid a loop
[xx,yy] = meshgrid(x,y);
% Initialize empty wave field
P = zeros(length(y),length(x));
% Use only active secondary sources
x0 = x0(ls_activity>0,:);
win = win(ls_activity>0);
% Integration over secondary source positions
for ii = 1:length(x0)

    % ====================================================================
    % Secondary source model G(x-x0,omega)
    % This is the model for the loudspeakers we apply. We use line sources
    % for 2D synthesis.
    G = line_source(xx,yy,x0(ii,1:3),f);

    % ====================================================================
    % Driving function D(x0,omega)
    D = driving_function_mono_wfs_2d(x0(ii,:),xs,f,src,conf);

    % ====================================================================
    % Integration
    %              /
    % P(x,omega) = | D(x0,omega) G(x-x0,omega) dx0
    %              /
    %
    % see: Spors2009, Williams1993 p. 36
    %
    % NOTE: win(ii) is the factor of the tapering window in order to have fewer
    % truncation artifacts. If you don't use a tapering window win(ii) will
    % always be one.
    P = P + win(ii)*D.*G;

end

% === Primary source correction ===
if(0)
    omega = 2*pi*f;
    c = conf.c;
    xref = position_vector(conf.xref);
    C = exp(-1i*(omega/c*norm(xref-xs) - pi/2)) / ...
    ( pi*norm(xref-xs)*besselh(0,2,omega/c*norm(xref-xs)) )
    P = P .* C;
end

% === Scale signal (at xref) ===
P = norm_wave_field(P,x,y,conf);


% ===== Plotting =========================================================
if(useplot)
    plot_wavefield(x,y,P,L,ls_activity,conf);
end