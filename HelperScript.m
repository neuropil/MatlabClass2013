% Helper script to put working files on path

[filename, pathname] = uigetfile('*.txt');
addpath(genpath(pathname));