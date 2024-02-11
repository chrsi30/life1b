function [cost] = CostFunction_global(theta,modelName,D, Mdata, signaltype, doScale)
if size(theta,1) > 1
    theta = theta';
end


theta = [exp(theta) D.LiverVolume.total Mdata.BloodVolume Mdata.BW ];

if strcmp(signaltype,'Conc')
    [simLiver ,  simSpleen , ~  ]  = wholeBodySimLiverConc(theta, D.time' , modelName, doScale);
    
elseif strcmp(signaltype,'deltaR1')
    [simLiver ,  simSpleen , ~  ]  = wholeBodySimLiver(theta,  D.time' , modelName, doScale);
    
end

%%
%%
c1 = nansum( (( simLiver' - D.liver.mean).^2 )./(D.liver.SEM).^2);

c2 = nansum( (( simSpleen' - D.spleen.mean).^2 )./(D.spleen.SEM.^2) );

%%

%%
cost =  c2 + c1 ;

end

