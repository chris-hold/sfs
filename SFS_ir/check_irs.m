function check_irs(irs)
%CHECK_IRS checks if the given irs is stored in the right format
%
%   Usage: check_irs(irs)
%
%   Input options
%       irs - irs struct
%
%   CHECK_IRS(irs) checks if the given irs is stored in our own format.
%   For format details have a look at the IR_format.txt file.
%
%   See also: new_irs, IR_format.txt

% AUTHOR: Hagen Wierstorf


%% ===== Checking of input  parameters ==================================
nargmin = 1;
nargmax = 1;
error(nargchk(nargmin,nargmax,nargin));
if ~isstruct(irs)
    error('%s: irs has to be a struct!',upper(mfilename));
end


%% ===== Format checking =================================================

% Check for the right field entries in the given irs struct
% Get a reference implementation of a irs
ref_irs = new_irs();
% Get fields of reference implementation
ref_fields = fieldnames(ref_irs);
% Get the fields for the given irs
fields = fieldnames(irs);
% Check if all needed fields are present
for ii = 1:length(ref_fields)
    if ~isfield(irs,ref_fields{ii})
        error('%s: The given irs misses the field: %s!',...
            upper(mfilename),ref_fields{ii});
    end
end
% Check if the order of the fields is standard conform to new_irs()
for ii = 1:length(ref_fields)
    if ~strcmp(fields{ii},ref_fields{ii})
        warning('SFS:irs_fields_order',...
                ['%s: the order of fields is not standard conform. ',...
                 'please use order_irs_fields(irs).'],upper(mfilename));
        break;
    end
end

% Check for right measurement angle types
if ~isnumeric(irs.head_azimuth) || ~isvector(irs.head_azimuth)
    error('%s: head_azimuth needs to be a vector.',upper(mfilename));
elseif ~isnumeric(irs.head_elevation) || ~isvector(irs.head_elevation)
    error('%s: head_elevation needs to be a vector.',upper(mfilename));
elseif ~isnumeric(irs.torso_azimuth) || ~isvector(irs.torso_azimuth)
    error('%s: torso_azimuth needs to be a vector.',upper(mfilename));
elseif ~isnumeric(irs.torso_elevation) || ~isvector(irs.torso_elevation)
    error('%s: torso_elevation needs to be a vector.',upper(mfilename));
end

% Check for the right number of entries for the signals and apparent angles 
if size(irs.left,2)~=size(irs.right,2)
    error(['%s: the number of entries for the left ear signal is not ',...
           'consistent with the number of entries in the right channel.'],...
        upper(mfilename));
elseif size(irs.left,2)~=length(irs.apparent_azimuth)
    error(['%s: the number of entries for the left ear signal is not ',...
           'consistent with the number of entries for the apparent_azimuth.'],...
        upper(mfilename));
elseif size(irs.left,2)~=length(irs.apparent_elevation)
    error(['%s: the number of entries for the left ear signal is not ',...
           'consistent with the number of entries in the apparent_elevation.'],...
        upper(mfilename));
end

% Check for the right sizes of the entries for the positions
if ~isnumeric(irs.head_position) | size(irs.head_position)~=[1 3]
    error('%s: head_position needs to be a 1x3 vector.',upper(mfilename));
elseif ~isnumeric(irs.head_reference) | size(irs.head_reference)~=[1 3]
     error('%s: head_reference needs to be a 1x3 vector.',upper(mfilename));
elseif ~isnumeric(irs.source_position) | size(irs.source_position)~=[1 3]
     error('%s: source_position needs to be a 1x3 vector.',upper(mfilename));
elseif ~isnumeric(irs.source_reference) | size(irs.source_reference)~=[1 3]
    error('%s: source_reference needs to be a 1x3 vector.',upper(mfilename));
end

% Check sampling rate
if ~isnumeric(irs.fs) || irs.fs<=0
    error('%s: fs needs to be a positive number.',upper(mfilename));
end

% Check distance
if ~isnumeric(irs.distance) || ...
    irs.distance~=norm(irs.head_position-irs.source_position)
    error('%s: distance has to be norm(head_position-source_position).',...
        upper(mfilename));
end

% Check string entries
if ~ischar(irs.description)
    error('%s: description needs to be a string.',upper(mfilename));
elseif ~ischar(irs.loudspeaker)
    error('%s: loudspeaker needs to be a string.',upper(mfilename));
elseif ~ischar(irs.room)
    error('%s: room needs to be a string.',upper(mfilename));
elseif ~ischar(irs.head)
    error('%s: head needs to be a string.',upper(mfilename));
end