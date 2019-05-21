%% generate Trial Sequence
% need run info (making ts for n runs)

basedir = '/Users/hongji/Dropbox/Courses/1_GBME_2019S/HumanBrainMapping1/TeamProject/codes/HBM2019S_IRRH';
datdir = fullfile(basedir, 'data'); % (, 'data');
if ~exist(datdir, 'dir'), error('You need to run this code within the IRRH directory.'); end
addpath(genpath(basedir));

rng('shuffle');

sid = input('Subject ID? (e.g., R001): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '_data']), 'char');
if ~exist(subject_dir, 'dir')
    mkdir(fullfile(datdir, [sid '_data']));
end

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

ts.datafile = fullfile(subject_dir, [subjdate, '_ts_', sid, '.mat']);

run_num = 18;
stim_num = 2;

% assign color type (heat/cold)

rand_stim_i = randperm(run_num, run_num/stim_num);
rand_stim = zeros(1,run_num);
for k = 1:numel(rand_stim_i)
    rand_stim(rand_stim_i(k)) = 1;
end
rand_stim(find(rand_stim==0)) = 2;

% assign level type (1/2/3)
for stim_i = 1:2
    rand_lv_i = randperm(run_num/stim_num, run_num/stim_num/3);
    rand_lv_1 = zeros(1,run_num/stim_num);
    for k = 1:numel(rand_lv_i)
        rand_lv_1(rand_lv_i(k)) = 1;
    end
    
    rand_lv_j = randperm(run_num/stim_num - run_num/stim_num/3, run_num/stim_num/3);
    temp_zero = find(rand_lv_1 == 0);
    
    for k = 1:numel(rand_lv_j)
        rand_lv_1(temp_zero(rand_lv_j(k))) = 2;
    end
    
    if stim_i == 1
        red_lv = rand_lv_1;
    else
        blue_lv = rand_lv_1;
    end
end

n_lv1 = 0;
n_lv2 = 0;
for i = 1:run_num
    if rand_stim(i) == 1
        n_lv1 = n_lv1 + 1;
        color_type = 'red';
        stim_lv = red_lv(n_lv1);
    elseif rand_stim(i) == 2
        n_lv2 = n_lv2 + 1;
        color_type = 'blue';
        stim_lv = blue_lv(n_lv2);
    end
    
    ts.stim_type{i} = color_type;
    ts.stim_lv(i) = stim_lv;
    
end

save(ts.datafile, 'ts');
