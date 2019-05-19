
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect text_color IVqT ; %lb tb recsize barsize rec;
global ptb_drawformattedtext_disableClipping

ptb_drawformattedtext_disableClipping = 1;
% Screen setting
bgcolor = 50;

text_color = 255;
fontsize = [28, 32, 41, 54];

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/3; %for mac, [0 0 2560 1600];

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

white = 255;
red = [190 0 0];
blue = [0 85 169];
orange = [255 145 0];

[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
%     font = 'NanumBarunGothic'; % check
%     Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize(2));

while (1)
    [~,~,keyCode] = KbCheck;
    
    if keyCode(KbName('s'))==1
        break
    elseif keyCode(KbName('q'))==1
        abort_experiment('manual');
    end
    
%     Screen(theWindow, 'FillRect', bgcolor, window_rect);
%     Screen('Flip', theWindow);
    
end

%Screen(theWindow,'FillRect', [255 0 0], [W/3 H/3 2*W/3 2*H/3]);
for i = 1:10
    starttime = GetSecs;
    color = [255*i/10 0 0];
    Screen('DrawDots', theWindow, [W/2 H/2], 100, color, [0, 0], 1)
    Screen('Flip', theWindow);
    waitsec_fromstarttime(starttime, 0.3);
end

while (1)
    [~,~,keyCode] = KbCheck;
    
    if keyCode(KbName('s'))==1
        break
    elseif keyCode(KbName('q'))==1
        abort_experiment('manual');
    end
    
%     Screen(theWindow, 'FillRect', bgcolor, window_rect);
%     Screen('Flip', theWindow);
    
end

for i = 1:10
    starttime = GetSecs;
    color = [0 0 255*i/10];
    Screen('DrawDots', theWindow, [W/2 H/2], 100, color, [0, 0], 1)
    Screen('Flip', theWindow);
    waitsec_fromstarttime(starttime, 0.3);
end

while (1)
    [~,~,keyCode] = KbCheck;
    
    if keyCode(KbName('s'))==1
        break
    elseif keyCode(KbName('q'))==1
        abort_experiment('manual');
    end
    
%     Screen(theWindow, 'FillRect', bgcolor, window_rect);
%     Screen('Flip', theWindow);
    §°∞Ì«ÿ∂Û
end

for i = 1:10
    starttime = GetSecs;
    color = [255*i/10 255*i/10 255*i/10];
    Screen('DrawDots', theWindow, [W/2 H/2], 100, color, [0, 0], 1)
    Screen('Flip', theWindow);
    waitsec_fromstarttime(starttime, 0.3);
end