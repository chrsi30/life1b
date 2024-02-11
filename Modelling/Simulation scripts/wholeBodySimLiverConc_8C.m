function varargout = wholeBodySimLiverConc_8C(param, simTime, modelName ,scale , doScale)

%% Simulation settings
simOptions = [];
simOptions.maxnumsteps = 1e8;
simOptions.abstol = 1e-10;
simOptions.reltol = 1e-10;
simOptions.minstep = 0;
simOptions.maxstep = inf;

ICs = SBinitialconditions(modelName);
[pNames,p0] = SBparameters(modelName);

%% Simulate

if  strcmp(modelName,'forsgren_NoBack_8C')
    simParam = param(1:end);
elseif strcmp(modelName,'forsgren_NoBack_8C_resection') 
    if length(param) < 37
        simParam = [ param(1:end) p0(end) ];
    else
        simParam = param(1:end);
    end

end

if doScale == 0
    scale = 1;
end


if simTime(1) == 0
simTime = simTime';
simData = SBPDsimulate(modelName, simTime, ICs, pNames, simParam, simOptions);
simLiver.sim_segment_c1   = simData.reactionvalues(1:end, ismember(simData.reactions,{'C1'}))*scale*1000;
simLiver.sim_segment_c2   = simData.reactionvalues(1:end, ismember(simData.reactions,{'C2'}))*scale*1000;
simLiver.sim_segment_c3   = simData.reactionvalues(1:end, ismember(simData.reactions,{'C3'}))*scale*1000;
simLiver.sim_segment_c4   = simData.reactionvalues(1:end, ismember(simData.reactions,{'C4'}))*scale*1000;
simLiver.sim_segment_c5   = simData.reactionvalues(1:end, ismember(simData.reactions,{'C5'}))*scale*1000;
simLiver.sim_segment_c6   = simData.reactionvalues(1:end, ismember(simData.reactions,{'C6'}))*scale*1000;
simLiver.sim_segment_c7   = simData.reactionvalues(1:end, ismember(simData.reactions,{'C7'}))*scale*1000;
simLiver.sim_segment_c8   = simData.reactionvalues(1:end, ismember(simData.reactions,{'C8'}))*scale*1000;
simSpleen                 = simData.reactionvalues(1:end, ismember(simData.reactions,{'Cs'}))*scale*1000;


else
simTime = [ 0 simTime' ];
simData = SBPDsimulate(modelName, simTime, ICs, pNames, simParam, simOptions);
simLiver.sim_segment_c1   = simData.reactionvalues(2:end, ismember(simData.reactions,{'C1'}))*scale*1000;
simLiver.sim_segment_c2   = simData.reactionvalues(2:end, ismember(simData.reactions,{'C2'}))*scale*1000;
simLiver.sim_segment_c3   = simData.reactionvalues(2:end, ismember(simData.reactions,{'C3'}))*scale*1000;
simLiver.sim_segment_c4   = simData.reactionvalues(2:end, ismember(simData.reactions,{'C4'}))*scale*1000;
simLiver.sim_segment_c5   = simData.reactionvalues(2:end, ismember(simData.reactions,{'C5'}))*scale*1000;
simLiver.sim_segment_c6   = simData.reactionvalues(2:end, ismember(simData.reactions,{'C6'}))*scale*1000;
simLiver.sim_segment_c7   = simData.reactionvalues(2:end, ismember(simData.reactions,{'C7'}))*scale*1000;
simLiver.sim_segment_c8   = simData.reactionvalues(2:end, ismember(simData.reactions,{'C8'}))*scale*1000;
simSpleen                 = simData.reactionvalues(2:end, ismember(simData.reactions,{'Cs'}))*scale*1000;

end



if nargout == 1
    varargout{1} = [simLiver; simSpleen];
elseif nargout == 2
    varargout{1} = simLiver;
    varargout{2} = simSpleen;
elseif nargout == 3
    varargout{1} = simLiver;
    varargout{2} = simSpleen;
    varargout{3} = simData;
end



end