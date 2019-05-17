function ISRH_task(varargin)

basedir =  'C:\Users\Cocoanlab_WL01\Desktop\Dropbox\fMRI_task_data';
% basedir = pwd;
datdir = fullfile(basedir, 'data'); % (, 'data');
if ~exist(datdir, 'dir'), error('You need to run this code within the PiCo directory.'); end
addpath(genpath(basedir));

%% Global Setting


%% Visual stimuli (colors)



%% Heat stimuli (PATHWAY)

% send trigger to PATHWAY
% save temperature to data


%% VAS rating after heat stimuli