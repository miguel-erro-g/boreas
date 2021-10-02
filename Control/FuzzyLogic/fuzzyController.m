%% Fuzzy Inferance Systems
% Decide temperature reference signal for a HVAC system based on 
% time of the day and the difference between the building inside temperature and ambiental temperature

fis = mamfis('Name','TemperatureSetter');
% Inputs
    fis = addInput(fis,[0 10],'Name','deltaT');
            fis = addMF(fis,"deltaT","trapmf",[-1 0 1 2],"Name","chico");
            fis = addMF(fis,"deltaT","trapmf",[1 2 3 4],"Name","mediano");
            fis = addMF(fis,"deltaT","trapmf",[3 4 15 16],"Name","grande");
            figure
            plotmf(fis,"input",1)

    fis = addInput(fis,[0 24]*60,'Name','Horario');
            fis = addMF(fis,"Horario","trapmf",[0 0 6 6.5]*60,"Name","B");
            fis = addMF(fis,"Horario","trapmf",[6 6.5 19.5 20]*60,"Name","I1");
            fis = addMF(fis,"Horario","trapmf",[19.5 20 22 22.5]*60,"Name","P");
            fis = addMF(fis,"Horario","trapmf",[22 22.5 24 25]*60,"Name","I2");
            figure
            plotmf(fis,"input",2)

% Output
    fis = addOutput(fis,[-4 3],'Name','deltaSetPoint');
          fis = addMF(fis,"deltaSetPoint","trapmf",[-5 -4 -3 -2],"Name","bajaleMucho");
          fis = addMF(fis,"deltaSetPoint","trapmf",[-3 -2 -1 -0.5],"Name","bajale");
          fis = addMF(fis,"deltaSetPoint","trapmf",[-1 -0.5 0.5 0.75],"Name","dejale");
          fis = addMF(fis,"deltaSetPoint","trapmf",[0.5 0.75 3 4],"Name","subele");
          figure
          plotmf(fis,"output",1)
% Rules
        rules = ["deltaT==chico & Horario==B => deltaSetPoint=bajale",... 
            "deltaT==mediano & Horario==B => deltaSetPoint=bajale",... 
            "deltaT==grande & Horario==B => deltaSetPoint=bajaleMucho",...
            "deltaT==chico & Horario==I1 => deltaSetPoint=dejale",...
            "deltaT==chico & Horario==I2 => deltaSetPoint=dejale",...
            "deltaT==mediano & Horario==I1 => deltaSetPoint=dejale",...
            "deltaT==mediano & Horario==I2 => deltaSetPoint=dejale",...
            "deltaT==grande & Horario==I1 => deltaSetPoint=dejale",...
            "deltaT==grande & Horario==I2 => deltaSetPoint=dejale",...
            "deltaT==chico & Horario==P => deltaSetPoint=subele",...
            "deltaT==mediano & Horario==P => deltaSetPoint=subele",...
            "deltaT==grande & Horario==P => deltaSetPoint=subele"];
    fis = addRule(fis,rules);
    
    options = gensurfOptions;
    options.NumGridPoints = 50;
    gensurf(fis,options)
    