function [data] = MPC_trial(window_info, line_parameters, color_values, Trials_num, Run_num, Pathway, data, GUI_table_data)
global ip port;

%Assign variables
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


%% SETUP: load the pathway program
PathPrg = load_PathProgram('SEMIC');


%% Jittering time and random cue & stimulus parameters 
jitter_1 = [3,6,7];
jitter_2 = [6,5,3];
jitter_3 = [4,2,3];

% low_intensity = [40,41,42]; 
% high_intensity = [45,46,47];

low_intensity = transpose(GUI_table_data(:,1));
high_intensity = transpose(GUI_table_data(:,2));

%% Convert stimulus intensity to Pathway program decimal
size_Path = size(PathPrg);
size_low_intensity = size(low_intensity);
size_high_intensity = size(high_intensity);

low_intensity_program=[];
high_intensity_program = [];

for i = 1:size_low_intensity(2)
for j = 1:size_Path(1)
    if PathPrg{j,1} == low_intensity(1,i)
        low_intensity_program = [low_intensity_program; PathPrg{j,4}];
    end
end
end

for i = 1:size_high_intensity(2)
for j = 1:size_Path(1)
    if PathPrg{j,1} == high_intensity(1,i)
        high_intensity_program = [high_intensity_program; PathPrg{j,4}];
    end
end
end


%% Trial starts
for trial= 1 : Trials_num
    %% Random generation for stimulus parameters and jittering
    rng('shuffle')
    cue_type_rand = rand();
    cue_prob_rand = rand();
    
    if cue_type_rand > 0.5
        cue_type = "high";
        if cue_prob_rand < 0.8
            cue_prob = "high";
        else
            cue_prob = "low";
        end
    else
        cue_type = "low";
        if cue_prob_rand < 0.8
            cue_prob = "high";
        else
            cue_prob = "low";
        end
    end
    
    jitter_index_rand = rand();
    intensity_index_rand = rand();
    
    if jitter_index_rand < 0.333
        jitter_index = 1;
    elseif jitter_index_rand < 0.666
        jitter_index = 2;
    else
        jitter_index = 3;
    end
    
    if intensity_index_rand < 0.333
        intensity_index = 1;
    elseif intensity_index_rand < 0.666
        intensity_index = 2;
    else
        intensity_index = 3;
    end
    
    
    %% Interval wait secs
    wait_after_cue = 2.5;
    wait_after_jitter_1 = wait_after_cue + jitter_1(jitter_index); %jitter_1 = [3,6,7]
    wait_after_stimulus = wait_after_jitter_1 + 12;
    wait_after_jitter_2 = wait_after_stimulus + jitter_2(jitter_index); %jitter_2 = [6,5,3];
    wait_after_rating = wait_after_jitter_2 + 5;
    wait_after_jitter_3 = wait_after_rating + jitter_3(jitter_index); %jitter_3 = [4,2,3];
    total_trial_time = 33;
    between_trial_time = 1;
    
    %% Adjusting between trial time
    if trial > 1
        waitsec_fromstarttime(data.dat.trial_endtime(trial-1, Run_num), between_trial_time)
    else
        waitsec_fromstarttime(data.dat.run_starttime(trial, Run_num), 1)
    end
        
    
    %% Checking trial start time 
    data.dat.trial_starttime(trial, Run_num) = GetSecs;
    data.dat.between_run_trial_starttime(trial, Run_num) = data.dat.trial_starttime(trial, Run_num) - data.dat.run_starttime(1, Run_num);
    
    %% Cue
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    if cue_type == "high" % if cue type is high
        cue_img = imread('high_cue','jpg');
        %[s1, s2, s3] = size(cue_img);
        Screen('PutImage', theWindow, cue_img); %show the overall rating scale
        Screen('Flip', theWindow);
                
    else % if cue type is low    
        cue_img = imread('low_cue','jpg');
        %[s1, s2, s3] = size(cue_img);
        Screen('PutImage', theWindow, cue_img); %show the overall rating scale
        Screen('Flip', theWindow);
        
    end
    data.dat.cue_time(trial, Run_num) =  GetSecs;
    data.dat.between_trial_start_cue_time(trial, Run_num) = data.dat.cue_time(trial, Run_num) - data.dat.trial_starttime(trial, Run_num);
    
    data.dat.cue_type(trial, Run_num) = cue_type;
    data.dat.cue_prob(trial, Run_num) = cue_prob;
    data.dat.jitter_index(trial, Run_num) = jitter_index;
    data.dat.intensity_index(trial, Run_num) = intensity_index;


    %% Setting stimulus intensity
    if cue_type == "high" % if cue type is high
        if cue_prob == "high" % if cue probability is 80%
            intensity_program = high_intensity_program(intensity_index);
            stimulus_intensity = high_intensity(intensity_index);
        else  % if cue probability is 20%
            intensity_program = low_intensity_program(intensity_index);
            stimulus_intensity = low_intensity(intensity_index);
        end
        
    else % if cue type is low
        if cue_prob == "high"  % if cue probability is 80%
            intensity_program = low_intensity_program(intensity_index);
            stimulus_intensity = low_intensity(intensity_index);
        else  % if cue probability is 20%
            intensity_program = high_intensity_program(intensity_index);
            stimulus_intensity = high_intensity(intensity_index);
        end
    end
    data.dat.stimulus_intensity(trial, Run_num) = stimulus_intensity;

    
    %% -------------Setting Pathway------------------
    if Pathway
        main(ip,port,1, intensity_program);     % select the program 
    end
    
    % Adjusting cue time
    % wait_after_cue = 2.5;
    waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_cue)
        

    %% Jittering1
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    % -------------Ready for Pathway------------------
    if Pathway
        main(ip,port,2); %ready to pre-start
    end 
    
    % Adjusting jitter time
    % wait_after_jitter_1 = wait_after_cue + jitter_1(jitter_index);
    waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_jitter_1)

    
    %% Heat pain stimulus
    if ~Pathway
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, double('Stimulus'), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
    end
    
    % ------------- start to trigger thermal stimulus------------------
    if Pathway
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        main(ip,port,2);
    end
    
    data.dat.stimulus_time(trial, Run_num) = GetSecs;
    
    
    %% stimulus time adjusting
    % wait_after_stimulus = wait_after_jitter_1 + 12;
    waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_stimulus)
    
    
    %% Jittering2
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    % wait_after_jitter_2 = wait_after_stimulus + jitter_2(jitter_index);
    waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_jitter_2)

    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('Flip', theWindow);

    
    %% setting for rating
    rating_types_pls = call_ratingtypes_pls;
    
    all_start_t = GetSecs;
    
    scale = ('overall_int');
    [lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    
    start_t = GetSecs;
    data.dat.rating_starttime(trial, Run_num) = start_t;
    
    ratetype = strcmp(rating_types_pls.alltypes, scale);
    
    % Initial position
    if start_center
        SetMouse(W/2,H/2); % set mouse at the center
    else
        SetMouse(lb,H/2); % set mouse at the left
    end
    
    
    %% rating start
    while true
        [x,~,button] = GetMouse(theWindow);
        [lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
        if x < lb; x = lb; elseif x > rb; x = rb; end
        
        DrawFormattedText(theWindow, double(rating_types_pls.prompts{ratetype}), 'center', H*(1/4), white, [], [], [], 2);
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
        if GetSecs - data.dat.rating_starttime(trial, Run_num) > 5
            break
        end
    end
    
    
    %% saving rating result
    end_t = GetSecs;

    data.dat.rating(trial, Run_num) = (x-lb)/(rb-lb);
    data.dat.rating_endtime(trial, Run_num) = end_t;
    data.dat.rating_duration(trial, Run_num) = end_t - start_t;
    
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('Flip', theWindow);
    
    
    %% rating time adjusting
    %wait_after_rating = wait_after_jitter_2 + 7;
    waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_rating)
    
    
    %% Jittering3
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    %wait_after_jitter_3 = wait_after_rating + jitter_3(jitter_index);
    waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_jitter_3)

    
    %% Adjusting total trial time
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), total_trial_time)

    
    %% saving trial end time
    data.dat.trial_endtime(trial, Run_num) = GetSecs;
    data.dat.trial_duration(trial, Run_num) = data.dat.trial_endtime(trial, Run_num) - data.dat.trial_starttime(trial, Run_num);
    %save(data.datafile, 'data', '-append');

    if trial >1
        data.dat.between_trial_time(trial, Run_num) = data.dat.trial_starttime(trial, Run_num) - data.dat.trial_endtime(trial-1, Run_num);
    else
        data.dat.between_trial_time(trial, Run_num) = 0;
    end
end

end