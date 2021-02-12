% This script initializes the ARES analysis.

% Initialize.
main_program_directory = pwd;
addpath(genpath(main_program_directory));

% Open options UI.
options = ARES_UI();

% Close the UI (and any other figure)
close all force

% Start Analysis pipeline.
[ARES_film, ARES_film_info, options] = calcium_imaging_guided_analysis (options);