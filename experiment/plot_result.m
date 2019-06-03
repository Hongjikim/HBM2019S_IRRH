%
for tr_i = 1:18
    a = data.dat{tr_i};
    if a.stim_type == 1
        if a.stim_lv == 0
            temp = 38;
        elseif a.stim_lv == 1
            temp = 38.5;
        else
            temp = 39;
        end
        
    elseif a.stim_type == 2
        if a.stim_lv == 0
            temp = 47;
        elseif a.stim_lv == 1
            temp = 47.5;
        else
            temp = 48;
        end
    elseif a.stim_type == 0
        temp = 32;
    end
    x(tr_i) = temp;
    y(tr_i) = a.rating;
    z(tr_i) = a.color_type;
    
end

plot(x(z==1),y(z==1),'bo');hold on;
plot(x(z==2),y(z==2),'ro')
