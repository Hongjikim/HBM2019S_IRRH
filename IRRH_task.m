function IRRH_task(varargin)

%% directory set up

basedir = '/Users/hongji/Dropbox/Courses/1_GBME_2019S/HumanBrainMapping1/TeamProject/codes/HBM2019S_IRRH';
datdir = fullfile(basedir, 'data'); % (, 'data');
if ~exist(datdir, 'dir'), error('You need to run this code within the IRRH directory.'); end
addpath(genpath(basedir));

%% varagin

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'test', 'testmode'}
                screen_mode = 'test';
        end
    end
end

%% save data

sid = input('Subject ID? (e.g., R001): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '_data']), 'char');
if ~exist(subject_dir, 'dir')
    mkdir(fullfile(datdir, [sid '_data']));
end

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

run_n = input('Run number? (e.g., 1): ');

data.subject = sid;
data.datafile = fullfile(subject_dir, [subjdate, '_', sid, '_run', sprintf('%.2d', run_n), '.mat']);
data.version = 'IRRH_v1_2019';
data.starttime = datestr(nowtime, 0);
data.starttime_getsecs = GetSecs;

if exist(data.datafile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', data.subject, subjdate);
    cont_or_not = input(['\nYou type the run number that is inconsistent with the data previously saved.', ...
        '\nWill you go on with your run number that typed just before?', ...
        '\n1: Yes, continue with typed run number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('ERROR: Break by user.')
    elseif cont_or_not == 1
        save(data.datafile, 'data');
    end
else
    save(data.datafile, 'data');
end

ts_fname = filenames(fullfile(subject_dir, '*ts*'));

load(ts_fname{1});

%% global setting

global theWindow W H; % window property
global white red orange bgcolor ; % color
global fontsize window_rect

[window_info, line_parameters, color_values] = IRRH_setscreen(screen_mode);

%% sync 's' from scanner

while (1)
    [~,~,keyCode] = KbCheck;
    
    if keyCode(KbName('s'))==1
        break
    elseif keyCode(KbName('q'))==1
        abort_experiment('manual');
    end
    
    %     Screen(theWindow, 'FillRect', bgcolor, window_rect);
    %     Screen('Flip', theWindow);
    
end

data.runscan_starttime = GetSecs; % run start timestamp

%% tasks start
for tr_i = 1:numel(ts.stim_type)
    dat{tr_i}.trial_start_time = GetSecs;
    dat{tr_i}.stim_type = ts.stim_type{tr_i};
    dat{tr_i}.stim_lv = ts.stim_lv{tr_i};
    
    %% Visual stimuli (colors)
    
    if ts.stim_type{tr_i} == 'heat'
        for sec = 1:10
            starttime = GetSecs;
            color = [255*i/10 0 0];
            Screen('DrawDots', theWindow, [W/2 H/2], 100, color, [0, 0], 1)
            Screen('Flip', theWindow);
            waitsec_fromstarttime(starttime, 0.3);
        end
    elseif ts.stim_type{tr_i} == 'cold'
        for i = 1:10
            starttime = GetSecs;
            color = [0 0 255*i/10];
            Screen('DrawDots', theWindow, [W/2 H/2], 100, color, [0, 0], 1)
            Screen('Flip', theWindow);
            waitsec_fromstarttime(starttime, 0.3);
        end
    end
    
    %% Heat stimuli (PATHWAY)
    
    % send trigger to PATHWAY
    % save temperature(or/and level) to data
    
    dat{tr_i}.temerature = ts.stim_type{tr_i};
    dat{tr_i}.level = ts.stim_lv(tr_i);
    
    
    %% VAS rating after heat stimuli
    
    
    
    
end
%% save data
data.dat = dat;
save(data.datafile, 'data', '-append');
end
