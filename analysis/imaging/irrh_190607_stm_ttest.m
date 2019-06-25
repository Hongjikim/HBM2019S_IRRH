%% Single Trial Model

% SETUP(2): Making directory and subject code
cd('/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging');
load('colors_type.mat');
load('stim_type.mat');

subj_idx = 5;

if subj_idx ==3
    preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model3/sub-irrh003';
else
    % preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model3/sub-irrh004';
    preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4_27/sub-irrh005';
end

%% condition indexing

% roi_masks = which('Fan_et_al_atlas_r280.nii');
% load(fullfile(preproc_subject_dir{ii}, 'PREPROC.mat'));
beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
blue_base = [];
blue_warm = [];
blue_pain = [];
red_base = [];
red_warm = [];
red_pain = [];

for beta_i = 1:size(beta_fnames,1)
    clear dat
    dat = fmri_data(beta_fnames(beta_i,:), which('gray_matter_mask.img'));
    if colors_type(subj_idx-4,beta_i) == 1 % blue
        if stim_type(subj_idx-4,beta_i) == 0 % base
            blue_base = [blue_base, dat.dat];
        elseif stim_type(subj_idx-4,beta_i) == 1 % warm
            blue_warm = [blue_warm, dat.dat];
        else
            blue_pain = [blue_pain, dat.dat];
        end
    else % red
        if stim_type(subj_idx-4,beta_i) == 0 % base
            red_base = [red_base, dat.dat];
        elseif stim_type(subj_idx-4,beta_i) == 1 % warm
            red_warm = [red_warm, dat.dat];
        else
            red_pain = [red_pain, dat.dat];
        end
    end
    disp([num2str(beta_i), ': done']);
end

%% new_pain
new_pain.dat = [mean(new_pain.dat(:,1:3),2), mean(new_pain.dat(:,4:6),2), mean(new_pain.dat(:,7:9),2), ...
    mean(new_pain.dat(:,10:12),2), mean(new_pain.dat(:,13:15),2), mean(new_pain.dat(:,16:18),2), ...
    mean(new_pain.dat(:,19:21),2), mean(new_pain.dat(:,22:24),2), mean(new_pain.dat(:,25:27),2), ...
    mean(new_pain.dat(:,28:30),2)];

%% (RP - RB ) - (BP - BB) 
  new_pain = dat;
  new_pain.dat = [red_pain - red_base - blue_pain + blue_base];

%%
bb_run5_sub03 = [mean(blue_base(:,1:3),2), mean(blue_base(:,4:6),2), mean(blue_base(:,7:9),2), ...
    mean(blue_base(:,10:12),2), mean(blue_base(:,13:15),2)];
save('bb_run5_sub04.mat', 'bb_run5_sub03');

bw_run5_sub03 = [mean(blue_warm(:,1:3),2), mean(blue_warm(:,4:6),2), mean(blue_warm(:,7:9),2), ...
    mean(blue_warm(:,10:12),2), mean(blue_warm(:,13:15),2)];
save('bw_run5_sub04.mat', 'bw_run5_sub03');

bp_run5_sub03 = [mean(blue_pain(:,1:3),2), mean(blue_pain(:,4:6),2), mean(blue_pain(:,7:9),2), ...
    mean(blue_pain(:,10:12),2), mean(blue_pain(:,13:15),2)];
save('bp_run5_sub04.mat', 'bp_run5_sub03');

rb_run5_sub03 = [mean(red_base(:,1:3),2), mean(blue_pain(:,4:6),2), mean(blue_pain(:,7:9),2), ...
    mean(blue_pain(:,10:12),2), mean(blue_pain(:,13:15),2)];
save('rb_run5_sub04.mat', 'rb_run5_sub03');

rw_run5_sub03 = [mean(red_warm(:,1:3),2), mean(red_warm(:,4:6),2), mean(red_warm(:,7:9),2), ...
    mean(red_warm(:,10:12),2), mean(red_warm(:,13:15),2)];
save('rw_run5_sub04.mat', 'rw_run5_sub03');

rp_run5_sub03 = [mean(red_pain(:,1:3),2), mean(red_pain(:,4:6),2), mean(red_pain(:,7:9),2), ...
    mean(red_pain(:,10:12),2), mean(red_pain(:,13:15),2)];
save('rp_run5_sub04.mat', 'rp_run5_sub03');

%%
save('blue_dat_03.mat', 'blue_dat');
save('red_dat_03.mat', 'red_dat');
diff_dat = red_dat;
diff_dat.dat = red_dat.dat - blue_dat.dat;
save('diff_dat_nomean_03.mat', 'diff_dat');

%%
tr = 0.46;
% roi_masks = which('Fan_et_al_atlas_r280.nii');
% load(fullfile(preproc_subject_dir{ii}, 'PREPROC.mat'));
beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
blue_beta = []; red_beta = [];
for beta_i = 1:size(beta_fnames,1)
    clear dat
    dat = fmri_data(beta_fnames(beta_i,:), which('gray_matter_mask.img'));
    if colors_type(subj_idx-2,beta_i) ==1 % blue
        blue_beta = [blue_beta, dat.dat];
    else % red
        red_beta = [red_beta, dat.dat];
    end
    disp([num2str(beta_i), ': done']);
end

%% blue vs. red

tr = 0.46;
% roi_masks = which('Fan_et_al_atlas_r280.nii');
% load(fullfile(preproc_subject_dir{ii}, 'PREPROC.mat'));
beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
blue_beta = []; red_beta = [];
for beta_i = 1:size(beta_fnames,1)
    clear dat
    dat = fmri_data(beta_fnames(beta_i,:), which('gray_matter_mask.img'));
    if colors_type(subj_idx-2,beta_i) ==1 % blue
        if ~exist('blue_dat')
            blue_dat = dat;
        else
            blue_dat.dat = [blue_dat.dat, dat.dat];
        end
    else % red
        if ~exist('red_dat')
            red_dat = dat;
        else
            red_dat.dat = [red_dat.dat, dat.dat];
        end
    end
    disp([num2str(beta_i), ': done']);
end

%%
save('blue_dat_03.mat', 'blue_dat');
save('red_dat_03.mat', 'red_dat');
diff_dat = red_dat;
diff_dat.dat = red_dat.dat - blue_dat.dat;
save('diff_dat_nomean_03.mat', 'diff_dat');

%% RED vs BLUE (IRRH03, 04 combined)

% load data
blue03 = load('blue_dat_03.mat'); blue04 = load('blue_dat_04.mat');
red03 = load('red_dat_03.mat'); red04 = load('red_dat_04.mat');

% combine two subjects
blue_all = blue03.blue_dat;
blue_all.dat = [blue03.blue_dat.dat, blue04.blue_dat.dat];

red_all = red03.red_dat;
red_all.dat = [red03.red_dat.dat, red04.red_dat.dat];

diff_all = red_all;
diff_all.dat = red_all.dat - blue_all.dat;

save('diff_all_dat_nomean_0304.mat', 'diff_all');

% plot
tdat = ttest(diff_all);
tdat_threshold = threshold(tdat, .05, 'unc', 'k',10);
% orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
% orthveiws(ma)

brain_activations_wani(region(tdat_threshold))
% brain_activations_wani(region(tdat_threshold),'surface_only')

%%
% load('diff_dat.mat')
tdat = ttest(diff_dat);
% tdat = ttest(diff_dat, .05, 'unc');

% tdat_threshold = threshold(tdat, .05, 'fdr', 'k', 10);
tdat_threshold = threshold(tdat, .05, 'unc', 'k', 50);
tdat_threshold = threshold(tdat, .5, 'fdr', 'k',10);
orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
orthveiws(ma)

brain_activations_wani(region(tdat_threshold))
brain_activations_wani(region(ma))
brain_activations_wani(region(tdat_threshold),'surface_only')

%%
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
brain_activations_wani(region(ma));

%% pain vs warm

tr = 0.46;
% roi_masks = which('Fan_et_al_atlas_r280.nii');
% load(fullfile(preproc_subject_dir{ii}, 'PREPROC.mat'));
beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
blue_beta = []; red_beta = [];
for beta_i = 1:size(beta_fnames,1)
    clear dat
    dat = fmri_data(beta_fnames(beta_i,:), which('gray_matter_mask.img'));
    if colors_type(subj_idx-2,beta_i) ==1 % blue
        if ~exist('blue_dat')
            blue_dat = dat;
        else
            blue_dat.dat = [blue_dat.dat, dat.dat];
        end
    else % red
        if ~exist('red_dat')
            red_dat = dat;
        else
            red_dat.dat = [red_dat.dat, dat.dat];
        end
    end
    disp([num2str(beta_i), ': done']);
end

%% reorganization

%load
bbfiles = filenames(fullfile(pwd, 'bb*'));
bwfiles = filenames(fullfile(pwd, 'bw*'));
bpfiles = filenames(fullfile(pwd, 'bp*'));
rbfiles = filenames(fullfile(pwd, 'rb*'));
rwfiles = filenames(fullfile(pwd, 'rw*'));
rpfiles = filenames(fullfile(pwd, 'rp*'));

bb3 = load(bbfiles{2}); bb4 = load(bbfiles{3}); clear bbfiles;
bw3 = load(bwfiles{2}); bw4 = load(bwfiles{3}); clear bwfiles;
bp3 = load(bpfiles{2}); bp4 = load(bpfiles{3}); clear bpfiles;
rb3 = load(rbfiles{2}); rb4 = load(rbfiles{3}); clear rbfiles;
rw3 = load(rwfiles{2}); rw4 = load(rwfiles{3}); clear rwfiles;
rp3 = load(rpfiles{2}); rp4 = load(rpfiles{3}); clear rpfiles;

%%

% combine two subjects
blue_base = dat; blue_base.dat = [bb3.bb_run5_sub03, bb4.bb_run5_sub03];
blue_warm = dat; blue_warm.dat = [bw3.bw_run5_sub03, bw4.bw_run5_sub03];
blue_pain = dat; blue_pain.dat = [bp3.bp_run5_sub03, bp4.bp_run5_sub03];

red_base = dat; red_base.dat = [rb3.rb_run5_sub03, rb4.rb_run5_sub03];
red_warm = dat; red_warm.dat = [rw3.rw_run5_sub03, rw4.rw_run5_sub03];
red_pain = dat; red_pain.dat = [rp3.rp_run5_sub03, rp4.rp_run5_sub03];

save('blue_base.mat', 'blue_base');
save('blue_warm.mat', 'blue_warm');
save('blue_pain.mat', 'blue_pain');
save('red_base.mat', 'red_base');
save('red_warm.mat', 'red_warm');
save('red_pain.mat', 'red_pain');

%% load two subject
load('blue_base.mat')
load('blue_warm.mat')
load('blue_pain.mat')
load('red_base.mat')
load('red_warm.mat')
load('red_pain.mat')


%% subject 4 only

preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model3/sub-irrh004';
beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
dat = fmri_data(beta_fnames(1,:), which('gray_matter_mask.img'));

blue_base = dat; blue_base.dat = bb4.bb_run5_sub03;
blue_warm = dat; blue_warm.dat = bw4.bw_run5_sub03;
blue_pain = dat; blue_pain.dat = bp4.bp_run5_sub03;

red_base = dat; red_base.dat = rb4.rb_run5_sub03;
red_warm = dat; red_warm.dat = rw4.rw_run5_sub03;
red_pain = dat; red_pain.dat = rp4.rp_run5_sub03;

%% subject 3 only

preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model3/sub-irrh003';
beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
dat = fmri_data(beta_fnames(1,:), which('gray_matter_mask.img'));

blue_base = dat; blue_base.dat = bb3.bb_run5_sub03;
blue_warm = dat; blue_warm.dat = bw3.bw_run5_sub03;
blue_pain = dat; blue_pain.dat = bp3.bp_run5_sub03;

red_base = dat; red_base.dat = rb3.rb_run5_sub03;
red_warm = dat; red_warm.dat = rw3.rw_run5_sub03;
red_pain = dat; red_pain.dat = rp3.rp_run5_sub03;

%% ttest Pain vs. Base ( (RP - RB) - (BP - BB))

diff_red = red_pain; diff_red.dat = red_warm.dat - red_base.dat;
diff_blue = blue_pain; diff_blue.dat = blue_warm.dat - blue_base.dat;

sum_pain = red_pain; sum_pain.dat = (red_pain.dat + blue_pain.dat)/2;
sum_warm = red_pain; sum_warm.dat = (red_warm.dat + blue_warm.dat)/2;
sum_base = red_pain; sum_base.dat = (red_base.dat + blue_base.dat)/2;

diff_warm_base_RB = diff_red; diff_warm_base_RB.dat = diff_red.dat - diff_blue.dat;
diff_warm_base_RB = diff_red; diff_warm_base_RB.dat = (diff_red.dat + diff_blue.dat)/2;
diff_pain_warm = sum_pain; diff_pain_warm.dat = (sum_pain.dat - sum_warm.dat);
% plot
tdat = ttest(diff_warm_base_RB);
tdat_threshold = threshold(tdat, .005, 'unc', 'k', 10);
% tdat_threshold = threshold(tdat, .05, 'fdr', 'k' ,10);
% brain_activations_wani(region(tdat_threshold))
tdat_threshold = threshold(tdat, .01, 'unc', 'k', 10);

% orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
close all;
brain_activations_wani(region(ma))

%% ttest Warm vs. Base 

diff_red = red_warm; diff_red.dat = red_warm.dat - red_base.dat;
diff_blue = blue_warm; diff_blue.dat = blue_warm.dat - blue_base.dat;

diff_warm_base_RB = diff_red; diff_warm_base_RB.dat = diff_red.dat - diff_blue.dat;

% plot
tdat = ttest(diff_warm_base_RB);
tdat_threshold = threshold(tdat, .1, 'unc', 'k', 50);
% tdat_threshold = threshold(tdat, .05, 'fdr', 'k' ,10);
% brain_activations_wani(region(tdat_threshold))

% orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
brain_activations_wani(region(ma))

%% compare two preproc (Pain - Base)

diff_new = new_pain;
diff_new.dat = new_pain.dat - new_pain.dat;

diff_old = old_pain;
diff_old.dat = old_pain.dat - old_base.dat;

tdat = ttest(diff_old);
tdat_threshold = threshold(tdat, .005, 'unc', 'k', 10);
% tdat_threshold = threshold(tdat, .05, 'fdr', 'k' ,10);
% brain_activations_wani(region(tdat_threshold))

% orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
brain_activations_wani(region(ma))


