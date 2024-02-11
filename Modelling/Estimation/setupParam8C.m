function [theta1, scale, px] = setupParam8C(theta,Dx,Mdata)
theta1= [exp(theta(1:end-1)),...
    Dx.LiverVolume.total,...
    Dx.LiverVolume.segments',...
    Mdata.BloodVolume, Mdata.BW ];

for k = 1:8
    if  Dx.liver.segment(1,k) == 0
        eval(strcat('px',int2str(k),'=0;'))
    else
        eval(strcat('px',int2str(k),'=1;'))
    end
end

px = [ px1 px2 px3 px4 px5 px6 px7 px8 ];
theta1 = [ theta1  px ];
%%
scale   = exp(theta(end));

end

