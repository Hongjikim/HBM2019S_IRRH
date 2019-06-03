% first level model 1
% single trial
% doesn't remove ventricle and white matter
% view 160 & rating 4
%
%% directory setting

% wani's imac
% basedir = '/Volumes/cocoanlab/accumbens_sync';
% scriptdir = '/Users/clinpsywoo/Nas/FAST/scripts/imaging';
% img_dir = fullfile(basedir, '/data/FAST/imaging/preprocessed');
% modeldir = fullfile(basedir, 'project/FAST/analysis/imaging/first_level/model1');

% Directory _ accumbens
[basedir, fastdatadir, fastprojectdir] = fast_vary_path('accumbens');
[D, ~, ~, ~] = fast_load_data(fastprojectdir);

scriptdir = fullfile(fastprojectdir, '/scripts/imaging');
img_dir = fullfile(fastdatadir, 'imaging/preprocessed');
modeldir = fullfile(fastprojectdir, 'analysis/imaging/first_level/model01_spm_sing_tri_noremv_vw');
if ~exist(modeldir, 'dir'), mkdir(modeldir); end

subjects = canlab_list_subjects(img_dir, 'sub-fast*');

%% read canlab_dataset
% onsets 
onsets_view = get_var(D, 'eventonsettime', 'conditional', {'eventname', 'view'});   % 93 x 160
onsets_emotion_select = get_var(D, 'eventonsettime', 'conditional', {'eventname', 'emotion_selection'});    % 93 x 20
onsets_concentration = get_var(D, 'eventonsettime', 'conditional', {'eventname', 'concentration'}); % 93 x 8

% names
names_view = get_var(D, 'eventname', 'conditional', {'eventname', 'view'});
names_emotion_select = get_var(D, 'eventname', 'conditional', {'eventname', 'emotion_selection'});
names_concentration = get_var(D, 'eventname', 'conditional', {'eventname', 'concentration'});

% durations
durations_view = get_var(D, 'eventduration', 'conditional', {'eventname', 'view'});
durations_emotion_select = get_var(D, 'eventduration', 'conditional', {'eventname', 'emotion_selection'});
durations_concentration = get_var(D, 'eventduration', 'conditional', {'eventname', 'concentration'});

%% loop for subjects
d = [];
for sub_j = 1:numel(D.Subj_Level.id)        
    % session number = 1 && mri_inclusion = 1(it means normal)    n = 61
        if D.Subj_Level.data(sub_j,3) == 1 &&  D.Subj_Level.data(sub_j,6) == 1
        d = [d datetime('now')]
        
        subject_id = D.Subj_Level.id{sub_j};
        subj_dir = fullfile(img_dir, subject_id);
        subj_outputdir = fullfile(modeldir, subject_id);        
        cd(subj_dir);
        
        disp('======================================================')
        fprintf('WORKING ON: %s\n', subject_id);
        disp('======================================================')
        
        TR = 0.46;
        hpfilterlen = 180;
        images_by_run = filenames(fullfile(subj_dir, 'func/sw*task-fastfmri*.nii'));
        conditions_per_run = [41 41 41 41];
        
        view_run_idx = repmat(1:4, 40,1); view_run_idx = view_run_idx(:); % 160 x 1
        emotion_select_run_idx = repmat(1:4, 5,1); emotion_select_run_idx = emotion_select_run_idx(:);  % 20 x 1 
        concentration_select_run_idx = repmat(1:4, 2,1); concentration_select_run_idx = concentration_select_run_idx(:); % 8 x 1
        
        onsets = [];
        durations = [];
        names = [];
        
        % run loop
        for run_i = 1:4
            
            onsets_temp = num2cell(onsets_view(sub_j, view_run_idx==run_i)');
            onsets = [onsets;onsets_temp];
            
            duration_temp = num2cell(durations_view(sub_j, view_run_idx==run_i)');
            durations = [durations;duration_temp];
            
            names_temp = names_view(sub_j, view_run_idx==run_i)';
            for trial_i = 1:numel(names_temp)
                names_temp{trial_i} = sprintf('%s_%02d', names_temp{trial_i}, trial_i);
            end
            names = [names;names_temp];
            
            clear *_temp;
            
            onsets_temp{1} = [onsets_emotion_select(sub_j, emotion_select_run_idx==run_i)'; onsets_concentration(sub_j, concentration_select_run_idx==run_i)'];
            onsets = [onsets;onsets_temp];
            
            duration_temp{1} = [durations_emotion_select(sub_j, emotion_select_run_idx==run_i)'; durations_concentration(sub_j, concentration_select_run_idx==run_i)'];
            durations = [durations;duration_temp];
            
            names_temp = names_emotion_select(sub_j, emotion_select_run_idx==run_i)';
            names = [names;{'rating'}];
            
            clear *_temp;
            %
            %     onsets_temp{1} = onsets_concentration(subj_idx, concentration_select_run_idx==run_i)';
            %     onsets = [onsets;onsets_temp];
            %
            %     duration_temp{1} = durations_concentration(subj_idx, concentration_select_run_idx==run_i)';
            %     durations = [durations;duration_temp];
            %
            %     names_temp = names_concentration(subj_idx, concentration_select_run_idx==run_i)';
            %     names = [names;names_temp(1)];
        end
        
        %% prepare and save nuisance
        
        load(fullfile(subj_dir, 'PREPROC.mat'));
        nuisance_dir = fullfile(subj_dir, 'nuisance_mat');
        if ~exist(nuisance_dir, 'dir'), mkdir(nuisance_dir); end
        
        % without remove vw
        if numel(filenames(fullfile(nuisance_dir, 'nuisance_run*.mat')))==9
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
        
        multi_nuisance_matfilenames{1} = fullfile(nuisance_dir, sprintf('nuisance_run%02d.mat', 3));
        multi_nuisance_matfilenames{2} = fullfile(nuisance_dir, sprintf('nuisance_run%02d.mat', 5));
        multi_nuisance_matfilenames{3} = fullfile(nuisance_dir, sprintf('nuisance_run%02d.mat', 7));
        multi_nuisance_matfilenames{4} = fullfile(nuisance_dir, sprintf('nuisance_run%02d.mat', 9));
        
        %% first-level model job
        
        matlabbatch = canlab_spm_fmri_model_job(subj_outputdir, TR, hpfilterlen, images_by_run, conditions_per_run, onsets, ...
            durations, names, multi_nuisance_matfilenames, 'is4d', 'notimemod');
        
        if ~exist(subj_outputdir, 'dir'), mkdir(subj_outputdir); end
        save(fullfile(subj_outputdir, 'spm_model_spec_estimate_job.mat'), 'matlabbatch');
        spm_jobman('run', matlabbatch);
        
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
        for run_i = 1:4
            for trial_i = 1:40
                j = j+1;
                eval(sprintf('!ln -s beta_%04d.nii view_%03d.nii', find(contains(SPM.xX.name, sprintf('Sn(%d) view_%02d', run_i, trial_i))), j));
            end
        end
        
        rating_beta_idx = find(contains(SPM.xX.name, 'rating'));
        for i = 1:numel(rating_beta_idx)
            eval(sprintf('!ln -s beta_%04d.nii rating_%02d.nii', rating_beta_idx(i), i));
        end        
    end
end  % one subject loop end