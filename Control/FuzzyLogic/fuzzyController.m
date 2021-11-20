%% Fuzzy Inferance Systems
% Decide temperature reference signal for a HVAC system based on 
% time of the day and the difference between the building inside temperature and ambiental temperature

fis1 = mamfis('Name','PrecalculateSetPointChange');
% Inputs
    fis1 = addInput(fis1,[0    10],'Name','deltaT');
            fis1 = addMF(fis1,"deltaT","trapmf",[-1 0 1 2],"Name","chico");
            fis1 = addMF(fis1,"deltaT","trapmf",[1 2 3 4],"Name","mediano");
            fis1 = addMF(fis1,"deltaT","trapmf",[3 4 15 16],"Name","grande");
            figure
            plotmf(fis1,"input",1)

    fis1 = addInput(fis1,[0 24]*60,'Name','Horario');
            fis1 = addMF(fis1,"Horario","trapmf",[0 0 6 6.5]*60,"Name","B");
            fis1 = addMF(fis1,"Horario","trapmf",[6 6.5 19.5 20]*60,"Name","I1");
            fis1 = addMF(fis1,"Horario","trapmf",[19.5 20 22 22.5]*60,"Name","P");
            fis1 = addMF(fis1,"Horario","trapmf",[22 22.5 24 25]*60,"Name","I2");
            figure
            plotmf(fis1,"input",2)

% Output
    fis1 = addOutput(fis1,[-4 3],'Name','deltaSetPoint');
          fis1 = addMF(fis1,"deltaSetPoint","trapmf",[-5 -4 -3 -2],"Name","bajaleMucho");
          fis1 = addMF(fis1,"deltaSetPoint","trapmf",[-3 -2 -1 -0.5],"Name","bajale");
          fis1 = addMF(fis1,"deltaSetPoint","trapmf",[-1 -0.5 0.5 0.75],"Name","dejale");
          fis1 = addMF(fis1,"deltaSetPoint","trapmf",[0.5 0.75 3 4],"Name","subele");
          figure
          plotmf(fis1,"output",1)
% Rules
        rules1 =  ["deltaT==chico & Horario==B => deltaSetPoint=dejale",... 
            "deltaT==mediano & Horario==B => deltaSetPoint=dejale",... 
            "deltaT==grande & Horario==B => deltaSetPoint=bajale",...
            "deltaT==chico & Horario==I1 => deltaSetPoint=subele",...
            "deltaT==chico & Horario==I2 => deltaSetPoint=subele",...
            "deltaT==mediano & Horario==I1 => deltaSetPoint=dejale",...
            "deltaT==mediano & Horario==I2 => deltaSetPoint=dejale",...
            "deltaT==grande & Horario==I1 => deltaSetPoint=bajale",...
            "deltaT==grande & Horario==I2 => deltaSetPoint=bajale",...
            "deltaT==chico & Horario==P => deltaSetPoint=subele",...
            "deltaT==mediano & Horario==P => deltaSetPoint=subele",...
            "deltaT==grande & Horario==P => deltaSetPoint=subele"];
    fis1 = addRule(fis1,rules1);
    
    options = gensurfOptions;
    options.NumGridPoints = 50;
    gensurf(fis1,options)
    
fis2 = mamfis('Name','TemperatureSetter');
% Inputs
    fis2 = addInput(fis2,[-4 3],'Name','precalculated_deltaSetPoint');
          fis2 = addMF(fis2,"precalculated_deltaSetPoint","trapmf",[-5 -4 -3 -2],"Name","bajaleMucho");
          fis2 = addMF(fis2,"precalculated_deltaSetPoint","trapmf",[-3 -2 -1 -0.5],"Name","bajale");
          fis2 = addMF(fis2,"precalculated_deltaSetPoint","trapmf",[-1 -0.5 0.5 0.75],"Name","dejale");
          fis2 = addMF(fis2,"precalculated_deltaSetPoint","trapmf",[0.5 0.75 3 4],"Name","subele");
          figure
          plotmf(fis2,"input",1)

    fis2 = addInput(fis2,[18 26],'Name','Comfort');
            fis2 = addMF(fis2,"Comfort","zmf",[ 20 22],"Name","frio");
            fis2 = addMF(fis2,"Comfort","trapmf",[21 22 24 25],"Name","bueno");
            fis2 = addMF(fis2,"Comfort","smf",[24 25],"Name","caliente");
            figure
            plotmf(fis2,"input",2)

% Output
    fis2 = addOutput(fis2,[-4 3],'Name','deltaSetPoint');
          fis2 = addMF(fis2,"deltaSetPoint","trapmf",[-5 -4 -3 -2],"Name","bajaleMucho");
          fis2 = addMF(fis2,"deltaSetPoint","trapmf",[-3 -2 -1 -0.5],"Name","bajale");
          fis2 = addMF(fis2,"deltaSetPoint","trapmf",[-1 -0.5 0.5 0.75],"Name","dejale");
          fis2 = addMF(fis2,"deltaSetPoint","trapmf",[0.5 0.75 3 4],"Name","subele");
          figure
          plotmf(fis2,"output",1)
    
% Rules
        rules2 = ["Comfort==frio     & precalculated_deltaSetPoint==bajaleMucho => deltaSetPoint=dejale",... 
                  "Comfort==frio     & precalculated_deltaSetPoint==bajale      => deltaSetPoint=bajale",... 
                  "Comfort==frio     & precalculated_deltaSetPoint==dejale      => deltaSetPoint=dejale",...
                  "Comfort==frio     & precalculated_deltaSetPoint==subele      => deltaSetPoint=subele",...
                  "Comfort==bueno    & precalculated_deltaSetPoint==bajaleMucho => deltaSetPoint=bajaleMucho",...
                  "Comfort==bueno    & precalculated_deltaSetPoint==bajale      => deltaSetPoint=bajale",...
                  "Comfort==bueno    & precalculated_deltaSetPoint==dejale      => deltaSetPoint=dejale",...
                  "Comfort==bueno    & precalculated_deltaSetPoint==subele      => deltaSetPoint=subele",...
                  "Comfort==caliente & precalculated_deltaSetPoint==bajaleMucho => deltaSetPoint=bajaleMucho",...
                  "Comfort==caliente & precalculated_deltaSetPoint==bajale      => deltaSetPoint=bajale",...
                  "Comfort==caliente & precalculated_deltaSetPoint==dejale      => deltaSetPoint=bajale",...
                  "Comfort==caliente & precalculated_deltaSetPoint==subele      => deltaSetPoint=dejale"];
    fis2 = addRule(fis2,rules2);
    
    options = gensurfOptions;
    options.NumGridPoints = 50;
    gensurf(fis2,options)
    
    