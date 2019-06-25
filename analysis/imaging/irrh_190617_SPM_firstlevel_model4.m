% first level model 1
% single trial
% doesn't remove ventricle and white matter
% view 160 & rating 4
%
%% directory setting

% wissen
basedir = '/Users/hongji/Dropbox/IRRH_2019S';
scriptdir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging';
img_dir = fullfile(basedir, '/IRRH_imaging/preprocessed');
modeldir = fullfile(scriptdir, '/first_level/model4_27');

if ~exist(modeldir, 'dir'), mkdir(modeldir); end

subjects = canlab_list_subjects(img_dir, 'sub-irrh*');

%% read canlab_dataset
% onsets
cd('/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging'); 
load('onsets_stim.mat'); % 2 x 90
load('stim_type.mat');
load('colors_type.mat');
load('duration_stim.mat');
load('names_stim.mat');

%% loop for subjects
d = [];
for sub_j = 1:2 %numel(subjects)
    % session number = 1 && mri_inclusion = 1(it means normal)    n = 61
    % d = [d datetime('now')]
    
    subject_id = subjects{sub_j+2};
    subj_dir = fullfile(img_dir, subject_id);
    subj_outputdir = fullfile(modeldir, subject_id);
    cd(subj_dir);
    
    disp('======================================================')
    fprintf('WORKING ON: %s\n', subject_id);
    disp('======================================================')
    
    TR = 0.46;
    hpfilterlen = 180;
    images_by_run = filenames(fullfile(subj_dir, 'func/mw*task-RB*.nii'));
  
    stim_run_idx = repmat(1:5, 18,1); stim_run_idx = stim_run_idx(:); % 160 x 1
    conditions_per_run = [18 18 18 18 18];
    onsets = [];
    durations = [];
    names = [];
    
    % run loop
    for run_i = 1:5
        
        onsets_temp = num2cell(onsets_stim(sub_j, stim_run_idx==run_i)');
        onsets = [onsets;onsets_temp];
        
        duration_temp = num2cell(duration_stim(sub_j, stim_run_idx==run_i)');
        durations = [durations;duration_temp];
        
        names_temp = names_stim(sub_j, stim_run_idx==run_i)';
        for trial_i = 1:numel(names_temp)
            names_temp{trial_i} = sprintf('%s_%02d', names_temp{trial_i}, trial_i);
        end
        names = [names;names_temp];
        
        clear *_temp;
        
    end
    
    %% prepare and save nuisance
    
    load(fullfile(subj_dir, 'PREPROC.mat'));
    nuisance_dir = fullfile(subj_dir, 'nuisance_mat');
    if ~exist(nuisance_dir, 'dir'), mkdir(nuisance_dir); end
    
    % without remove vw
    if numel(filenames(fullfile(nuisance_dir, 'nuisance_run*.mat')))==6
        % skip
    else
        warning('No nuisance files. Please check')
        input('');
        for run_i = 1:numel(PREPROC.nuisance.mvmt_covariates)
            R = [[PREPROC.nuisance.mvmt_covariates{run_i} PREPROC.nuisance.mvmt_covariates{run_i}.^2 ...
                [zeros(1,6); diff(PREPROC.nuisance.mvmt_covariates{run_i})] [zeros(1,6); diff(PREPROC.nuisance.mvmt_covariates{run_i})].^2]...
                PREPROC.nuisance.spike_covariates{run_i}];
            R = [R zscore((1:size(R,1))')]; % linear drift
            savename = fullfile(nuisance_dir, sprintf('nuisance_run%02d.mat', run_i));
            fprintf('\nsaving... %s', savename);
            save(savename, 'R');
        end
    end
    
        multi_nuisance_matfilenames{1} = fullfile(nuisance_dir, sprintf('nuisance_run%01d.mat', 1));
        multi_nuisance_matfilenames{2} = fullfile(nuisance_dir, sprintf('nuisance_run%01d.mat', 2));
        multi_nuisance_matfilenames{3} = fullfile(nuisance_dir, sprintf('nuisance_run%01d.mat', 4));
        multi_nuisance_matfilenames{4} = fullfile(nuisance_dir, sprintf('nuisance_run%01d.mat', 5));
        multi_nuisance_matfilenames{5} = fullfile(nuisance_dir, sprintf('nuisance_run%01d.mat', 6));
        
    %% first-level model job
    
    matlabbatch = canlab_spm_fmri_model_job(subj_outputdir, TR, hpfilterlen, images_by_run, conditions_per_run, onsets, ...
        durations, names, multi_nuisance_matfilenames, 'is4d', 'notimemod');
    
    if ~exist(subj_outputdir, 'dir'), mkdir(subj_outputdir); end
    save(fullfile(subj_outputdir, 'spm_model_spec_estimate_job.mat'), 'matlabbatch');
    spm_jobman('run', matlabbatch);
    
    %
    cd(subj_outputdir);
    out = scn_spm_design_check(subj_outputdir, 'events_only');
    
    savename = fullfile(subj_outputdir, 'vifs.mat');
    save(savename, 'out');
    
    %% delete unneccessary files and make a symbolic links for later use
    load(fullfile(subj_outputdir, 'SPM.mat'));
    betaimgs = filenames(fullfile(subj_outputdir, 'beta_*nii'));
    
    delete_file_idx = [find(contains(SPM.xX.name, 'R'))';find(contains(SPM.xX.name, 'constant'))'];
    for z = 1:numel(delete_file_idx)
        delete(betaimgs{delete_file_idx(z)});
    end
    
    j= 0;
    for run_i = 1:5
        for trial_i = 1:18
            j = j+1;
            eval(sprintf('!ln -s beta_%04d.nii stim_%03d.nii', find(contains(SPM.xX.name, sprintf('Sn(%d) stim_%02d', run_i, trial_i))), j));
        end
    end
    
    rating_beta_idx = find(contains(SPM.xX.name, 'rating'));
    for i = 1:numel(rating_beta_idx)
        eval(sprintf('!ln -s beta_%04d.nii rating_%02d.nii', rating_beta_idx(i), i));
    end
end % one subject loop end