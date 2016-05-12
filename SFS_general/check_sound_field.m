function check_sound_field(P,t)
%CHECK_SOUND_FIELD checks if we have any activity in the sound field and returns a
%   warning otherwise.
%
%   Usage: check_sound_field(P,t)
%
%   Input parameters:
%       P       - sound field
%       t       - time t / samples
%
%   CHECK_SOUND_FIELD(P,t) checks if the sound field is different from zero.
%   If this is not the case it returns a warning.
%
%   See also: sound_field_imp_wfs, norm_sound_field

%*****************************************************************************
% The MIT License (MIT)                                                      *
%                                                                            *
% Copyright (c) 2010-2016 SFS Toolbox Team                                   *
%                                                                            *
% Permission is hereby granted,  free of charge,  to any person  obtaining a *
% copy of this software and associated documentation files (the "Software"), *
% to deal in the Software without  restriction, including without limitation *
% the rights  to use, copy, modify, merge,  publish, distribute, sublicense, *
% and/or  sell copies of  the Software,  and to permit  persons to whom  the *
% Software is furnished to do so, subject to the following conditions:       *
%                                                                            *
% The above copyright notice and this permission notice shall be included in *
% all copies or substantial portions of the Software.                        *
%                                                                            *
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *
% IMPLIED, INCLUDING BUT  NOT LIMITED TO THE  WARRANTIES OF MERCHANTABILITY, *
% FITNESS  FOR A PARTICULAR  PURPOSE AND  NONINFRINGEMENT. IN NO EVENT SHALL *
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
% LIABILITY, WHETHER  IN AN  ACTION OF CONTRACT, TORT  OR OTHERWISE, ARISING *
% FROM,  OUT OF  OR IN  CONNECTION  WITH THE  SOFTWARE OR  THE USE  OR OTHER *
% DEALINGS IN THE SOFTWARE.                                                  *
%                                                                            *
% The SFS Toolbox  allows to simulate and  investigate sound field synthesis *
% methods like wave field synthesis or higher order ambisonics.              *
%                                                                            *
% http://sfstoolbox.org                                 sfstoolbox@gmail.com *
%*****************************************************************************


%% ===== Checking of input parameters ====================================
nargmin = 2;
nargmax = 2;
narginchk(nargmin,nargmax);
isargnumeric(P);
isargscalar(t);


%% ===== Computation =====================================================
if length(P)==1, return; end
%
if max(abs(P(:)))==0 || all(isnan(P(:)))
    warning('SFS:check_sound_field',...
        ['The activity in the simulated sound field is zero. ',...
         'Maybe you should use another time frame t than %i. '],t);
end
