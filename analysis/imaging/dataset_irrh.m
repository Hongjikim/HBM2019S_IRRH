%% Making temporary dataset for IRRH
for sub_i = 1:2
    basedir = '/Users/hongji/Dropbox/IRRH_2019S';
    scriptdir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging';
    taskdat_dir = fullfile(basedir, '/scripts_git/experiment/data');
    img_dir = fullfile(basedir, '/IRRH_imaging/preprocessed');
    subjects = canlab_list_subjects(img_dir, 'sub-irrh*');
    subject_dir = filenames(fullfile(taskdat_dir, ['*', subjects{sub_i}(end), '*']), 'char');
    fnames_run = filenames(fullfile(subject_dir, '*run0*'));
    clear stim_onset color_temp stim_temp duration_temp rating_temp
    
    for run_i = [1:2, 4:6]
        if run_i > 3
            run_n = run_i - 1;
        else
            run_n = run_i;
        end
        clear data
        load(fnames_run{run_i});
        for tr_i = 1:numel(data.dat)
            stim_onset(run_n,tr_i) = data.dat{tr_i}.stim_start_time - data.runscan_starttime_skey - (0.46*18);
            color_temp(run_n, tr_i) = data.dat{tr_i}.color_type;
            stim_temp(run_n, tr_i) = data.dat{tr_i}.stim_type;
            duration_temp(run_n, tr_i) = data.dat{tr_i}.rating_starttime - data.dat{tr_i}.stim_start_time;
            
            rating_onset(run_n, tr_i) = data.dat{tr_i}.rating_starttime - data.runscan_starttime_skey - (0.46*18);
            duration_rating_temp(run_n, tr_i) = data.dat{tr_i}.rating_duration;
        end
    end
    
    onsets_stim(sub_i,:) = reshape(stim_onset', 1, 90) ;
    colors_type(sub_i,:) = reshape(color_temp', 1, 90) ;
    stim_type(sub_i,:) = reshape(stim_temp', 1, 90) ;
    duration_stim(sub_i,:) = reshape(duration_temp', 1, 90);
    
    onsets_rating(sub_i,:) = reshape(rating_onset', 1, 90);
    duration_rating(sub_i,:) = reshape(duration_rating_temp', 1, 90);
end

%%
save('onsets_stim.mat', 'onsets_stim');
save('colors_type.mat', 'colors_type');
save('stim_type.mat', 'stim_type');
save('duration_stim.mat', 'duration_stim');
%%
save('onsets_rating.mat', 'onsets_rating');
save('duration_rating.mat', 'duration_rating');

%% name
for subj = 1:size(colors_type,1)
    for k = 1:size(colors_type,2)
        if colors_type(subj,k) == 1 % blue
            if stim_type(subj,k) == 0
                names_stim{subj,k} = 'bl_no';
            elseif stim_type(subj,k) == 1
                names_stim{subj,k} = 'bl_warm';
            else
                names_stim{subj,k} = 'bl_pain';
            end
        else % red
            if stim_type(subj,k) == 0
                names_stim{subj,k} = 'rd_no';
            elseif stim_type(subj,k) == 1
                names_stim{subj,k} = 'rd_warm';
            else
                names_stim{subj,k} = 'rd_pain';
            end
        end
    end
end

save('names_stim.mat', 'names_stim');

%% name for rating

for subj = 1:size(onsets_rating,1)
    for rating_i = 1:size(onsets_rating,2)
        names_rating{subj, rating_i} = 'rating';
    end
end

save('names_rating.mat', 'names_rating')