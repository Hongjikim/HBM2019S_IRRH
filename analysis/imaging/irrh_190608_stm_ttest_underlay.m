%% Single Trial Model

% SETUP(2): Making directory and subject code
cd('/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging');
load('colors_type.mat');
load('stim_type.mat');

subj_idx = 3;

if subj_idx ==3
    preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model3/sub-irrh003';
else
    preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model3/sub-irrh004';
end

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

%%
% load('diff_dat.mat')
tdat = ttest(diff_dat);
% tdat = ttest(diff_dat, .05, 'unc');

% tdat_threshold = threshold(tdat, .05, 'fdr', 'k', 10);
tdat_threshold = threshold(tdat, .05, 'unc');
tdat_threshold = threshold(tdat, .05, 'unc','k',10);
orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
orthveiws(ma)

brain_activations_wani(region(tdat_threshold))
brain_activations_wani(region(tdat_threshold),'surface_only')

