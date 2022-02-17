
filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
[f, p] = uigetfile(filterspec);
disp(f);
disp(p);
fname = [p f];

disp(fname);
% Make sure user didn't cancel uigetfile dialog
