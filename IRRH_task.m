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

font = window_info.font ;
fontsize = window_info.fontsize;
theWindow = window_info.theWindow;
window_num = window_info.window_num ;
window_rect = window_info.window_rect;
H = window_info.H ;
W = window_info.W;

lb1 = line_parameters.lb1 ;
lb2 = line_parameters.lb2 ;
rb1 = line_parameters.rb1;
rb2 = line_parameters.rb2;
scale_H = line_parameters.scale_H ;
scale_W = line_parameters.scale_W;
anchor_lms = line_parameters.anchor_lms;

bgcolor = color_values.bgcolor;
orange = color_values.orange;
red = color_values.red;
white = color_values.white;

%% sync 's' from scanner

while (1)
    [~,~,keyCode] = KbCheck;
    
    if keyCode(KbName('s'))==1
        break
    elseif keyCode(KbName('q'))==1
        abort_experiment('manual');
    end
    
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('TextSize', theWindow, fontsize);
    ready_prompt = double('참가자가 준비되었으면, \n 이미징을 시작합니다 (s).');
    DrawFormattedText(theWindow, ready_prompt,'center', 'center', white, [], [], [], 1.5); %'center', 'textH'
    Screen('Flip', theWindow);
    
end

data.runscan_starttime = GetSecs; % run start timestamp

%% tasks start
for tr_i = 1:numel(ts.stim_type)
    dat{tr_i}.trial_start_time = GetSecs;
    dat{tr_i}.stim_type = ts.stim_type{tr_i};
    dat{tr_i}.stim_lv = ts.stim_lv(tr_i);
    
    %% Visual stimuli (colors)
    
    if ts.stim_type{tr_i} == 'heat'
        for sec = 1:12
            starttime = GetSecs;
            if sec < 7
                color = [255*sec/10 0 0];
            else
                color = [255*(13-sec)/10 0 0];
            end
            Screen('DrawDots', theWindow, [W/2 H/2], 100, color, [0, 0], 1);
            Screen('Flip', theWindow);
            waitsec_fromstarttime(starttime, 1);
        end
    elseif ts.stim_type{tr_i} == 'cold'
        for sec = 1:12
            starttime = GetSecs;
            if sec < 7
                color = [0 0 255*sec/10];
            else
                color = [0 0 255*(13-sec)/10];
            end
            Screen('DrawDots', theWindow, [W/2 H/2], 100, color, [0, 0], 1);
            Screen('Flip', theWindow);
            waitsec_fromstarttime(starttime, 1);
        end
    end
    
    %% Heat stimuli (PATHWAY)
    
    % send trigger to PATHWAY
    % load stimuli type and level from ts
     
    %% VAS rating after heat stimuli
    
    % setting for rating
    rating_types = call_ratingtypes_pls;
    
    all_start_t = GetSecs;
    
    scale = ('overall_int');
    [lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    
    start_t = GetSecs;
    dat{tr_i}.rating_starttime = start_t;
    
    ratetype = strcmp(rating_types.alltypes, scale);
    
    % Initial position
    if start_center
        SetMouse(W/2,H/2); % set mouse at the center
    else
        SetMouse(lb,H/2); % set mouse at the left
    end
    
    
    % rating start
    while true
        [x,~,button] = GetMouse(theWindow);
        [lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
        if x < lb; x = lb; elseif x > rb; x = rb; end
        
        DrawFormattedText(theWindow, double(rating_types.prompts{ratetype}), 'center', H*(1/4), white, [], [], [], 2);
        Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
        Screen('Flip', theWindow);
        
        if button(1)
            while button(1)
                [~,~,button] = GetMouse(theWindow);
            end
            break
        end
        
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q')) == 1
            abort_experiment('manual');
            break
        end
        if GetSecs - dat{tr_i}.rating_starttime > 5
            break
        end
    end
    
    
    % saving rating result
    end_t = GetSecs;
    
    dat{tr_i}.rating = (x-lb)/(rb-lb);
    dat{tr_i}.rating_endtime = end_t;
    dat{tr_i}.rating_duration = end_t - start_t;
    
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('Flip', theWindow);
    
    
end
%% save data
data.dat = dat;
save(data.datafile, 'data', '-append');
end
