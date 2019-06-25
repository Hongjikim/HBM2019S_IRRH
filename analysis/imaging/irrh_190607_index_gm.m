%% Making color and stim type index
for sub_i = 1:2
    cd('/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging');
   load('colors_type.mat');
   load('stim_type.mat');
   
   
    
end

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

