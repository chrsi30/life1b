%% Linking all folders and subfolders to path.

addpath(genpath('..'))
addpath(genpath('./Estimation'))
addpath(genpath('./Misc'))
addpath(genpath('./Models'))
addpath(genpath('./Plot scripts'))
addpath(genpath('./Results'))
addpath(genpath('./Simulation scripts'))
addpath(genpath('../DATA'))

load_string_data = 'MeanSEM';

cd ..
run('./DATA/generate_id.m')
load('./DATA/meta_data.mat');
load('./DATA/D_MeanSEM');
cd './Modelling'
