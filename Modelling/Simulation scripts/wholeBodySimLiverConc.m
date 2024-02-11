function varargout = wholeBodySimLiverConc(param,simTime,modelName,doScale)


if strcmp(modelName,'forsgren_NoBack_personalized')
scale = param(4);
simParam = [ param(1:3) param(5:end)]';  

end    


if doScale == 0
    scale = 1;
end


  
%% Simulation settings
simOptions = [];
simOptions.maxnumsteps = 1e8;
simOptions.abstol = 1e-10;
simOptions.reltol = 1e-10;
simOptions.minstep = 0;
simOptions.maxstep = inf;

ICs = SBinitialconditions(modelName);
[pNames,~] = SBparameters(modelName);

%% Simulate
if simTime(1) == 0
    
simData = SBPDsimulate(modelName, simTime, ICs, pNames, simParam, simOptions);
simLiver   = simData.reactionvalues(1:end, ismember(simData.reactions,{'Cl'}))*scale*1000;
simSpleen  = simData.reactionvalues(1:end, ismember(simData.reactions,{'Cs'}))*scale*1000;        
    
else
simTime = [ 0 simTime' ];

simData = SBPDsimulate(modelName, simTime, ICs, pNames, simParam, simOptions);
simLiver   = simData.reactionvalues(2:end, ismember(simData.reactions,{'Cl'}))*scale*1000;
simSpleen  = simData.reactionvalues(2:end, ismember(simData.reactions,{'Cs'}))*scale*1000;    

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