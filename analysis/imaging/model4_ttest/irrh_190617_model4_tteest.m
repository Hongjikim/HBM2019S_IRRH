%% reorganization

%load
bbfiles = filenames(fullfile(pwd, 'bb*'));
bwfiles = filenames(fullfile(pwd, 'bw*'));
bpfiles = filenames(fullfile(pwd, 'bp*'));
rbfiles = filenames(fullfile(pwd, 'rb*'));
rwfiles = filenames(fullfile(pwd, 'rw*'));
rpfiles = filenames(fullfile(pwd, 'rp*'));

bb3 = load(bbfiles{1}); bb4 = load(bbfiles{2}); clear bbfiles;
bw3 = load(bwfiles{1}); bw4 = load(bwfiles{2}); clear bwfiles;
bp3 = load(bpfiles{1}); bp4 = load(bpfiles{2}); clear bpfiles;
rb3 = load(rbfiles{1}); rb4 = load(rbfiles{2}); clear rbfiles;
rw3 = load(rwfiles{1}); rw4 = load(rwfiles{2}); clear rwfiles;
rp3 = load(rpfiles{1}); rp4 = load(rpfiles{2}); clear rpfiles;

%%

% combine two subjects
blue_base = dat; blue_base.dat = [bb3.bb_run5_sub03 + bb4.bb_run5_sub03]/2;
blue_warm = dat; blue_warm.dat = [bw3.bw_run5_sub03 + bw4.bw_run5_sub03]/2;
blue_pain = dat; blue_pain.dat = [bp3.bp_run5_sub03 + bp4.bp_run5_sub03]/2;

red_base = dat; red_base.dat = [rb3.rb_run5_sub03 + rb4.rb_run5_sub03]/2;
red_warm = dat; red_warm.dat = [rw3.rw_run5_sub03 + rw4.rw_run5_sub03]/2;
red_pain = dat; red_pain.dat = [rp3.rp_run5_sub03 + rp4.rp_run5_sub03]/2;

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

preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/sub-irrh006';
beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
dat = fmri_data(beta_fnames(1,:), which('gray_matter_mask.img'));

blue_base = dat; blue_base.dat = bb4.bb_run5_sub03;
blue_warm = dat; blue_warm.dat = bw4.bw_run5_sub03;
blue_pain = dat; blue_pain.dat = bp4.bp_run5_sub03;

red_base = dat; red_base.dat = rb4.rb_run5_sub03;
red_warm = dat; red_warm.dat = rw4.rw_run5_sub03;
red_pain = dat; red_pain.dat = rp4.rp_run5_sub03;

%% subject 3 only

preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/sub-irrh005';
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

diff_pain_base.dat = [red_pain.dat - red_base.dat, blue_pain.dat - blue_base.dat];
diff_warm_base.dat = [red_warm.dat - red_base.dat, blue_warm.dat - blue_base.dat];

sum_pain = red_pain; sum_pain.dat = (red_pain.dat + blue_pain.dat)/2;
sum_warm = red_pain; sum_warm.dat = (red_warm.dat + blue_warm.dat)/2;
sum_base = red_pain; sum_base.dat = (red_base.dat + blue_base.dat)/2;

% Pain vs Base (Red + blue)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - red_base.dat, blue_pain.dat - blue_base.dat];

% Warm vs Base (Red + blue)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_warm.dat - red_base.dat, blue_warm.dat - blue_base.dat];

% Red vs Blue (all condition)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - blue_pain.dat, red_warm.dat - blue_warm.dat, red_base.dat - blue_base.dat];

% Red vs Blue (PW condition)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - blue_pain.dat, red_warm.dat - blue_warm.dat];

% Red vs Blue (base only)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_base.dat - blue_base.dat];

% RP vs BP
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - blue_pain.dat];

% Rw vs Bw
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_warm.dat - blue_warm.dat];

% RP - RB vs BP - BB
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - red_base.dat - blue_pain.dat + blue_base.dat];

% RW - RB vs BW - BB
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_warm.dat - red_base.dat - blue_warm.dat + blue_base.dat];

%%
diff_pain_base = red_pain; diff_pain_base.dat = sum_pain.dat - sum_base.dat;

diff_warm_base_RB = diff_red; diff_warm_base_RB.dat = diff_red.dat - diff_blue.dat;
diff_warm_base_RB = diff_red; diff_warm_base_RB.dat = (diff_red.dat + diff_blue.dat)/2;
diff_pain_warm = sum_pain; diff_pain_warm.dat = (sum_pain.dat - sum_warm.dat);

% plot
tdat = ttest(diff_redblue);
tdat_threshold = threshold(tdat, .05, 'unc', 'k', 50);
% tdat_threshold = threshold(tdat, .05, 'fdr', 'k' ,10);
% brain_activations_wani(region(tdat_threshold))
% tdat_threshold = threshold(tdat, .01, 'unc', 'k', 10);

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
diff_new.dat = new_pain.dat - new_base.dat;

diff_old = old_pain;
diff_old.dat = old_pain.dat - old_base.dat;

tdat = ttest(diff_old);
tdat_threshold = threshold(tdat, .005, 'unc', 'k', 10);
% tdat_threshold = threshold(tdat, .05, 'fdr', 'k' ,10);
% brain_activations_wani(region(tdat_threshold))

% orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
brain_activations_wani(region(ma))
