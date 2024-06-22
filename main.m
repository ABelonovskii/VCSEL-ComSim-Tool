% Import necessary libraries
import com.comsol.model.*
import com.comsol.model.util.*


N_top_DBR = 20;
bottom_DBR = 25;

startentry = 1;
endentry = 1000;

port = 2036;

% Add path for COMSOL
addpath('C:\Program Files\COMSOL\COMSOL61\Multiphysics\mli');
mphstart('localhost', port);

% Create the file name string based on the number of pairs
file_name = sprintf('vertical_cavity_surface_emitting_laser_%d_%d.mph', N_top_DBR, bottom_DBR);

% Load the COMSOL model
model = mphload(file_name);

% Constants
hc9 = 1239.84197596064; % Convert energy to wavelength with nanometer adjustment

% Connect to database
conn = sqlite('vcsel_data_VCSEL_2.db', 'connect');
data = fetch(conn, 'SELECT input_data FROM vcsel_exp_data');

% Loop through database entries
for entry = startentry:endentry
    tic  % Start timer
    
    % Extract parameters from input string
    vcsel = extractParameters(data{entry,1});
    
    % Update COMSOL model parameters
    updateComsolModel(model, vcsel, hc9);
    
    % Run the COMSOL studies and retrieve results
    [evalData, gainData, evalErrorFlag, gainErrorFlag] = runComsolStudies(model);

    % Generate output strings based on COMSOL results
    [eigenmodes_str, freq_threshold_str] = generateOutputStrings(evalData, gainData, hc9, evalErrorFlag, gainErrorFlag);
    
    % Update database with results
    updateDatabase(conn, data{entry,1}, eigenmodes_str, freq_threshold_str);
    
    elapsedTime = toc;  % Stop the timer
    disp([num2str(N_top_DBR), '/', num2str(bottom_DBR), ' Entry ', num2str(entry), '. Total time: ', num2str(elapsedTime), ' seconds. Current time: ', datestr(datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss'))]);
end


% Close database connection
close(conn);


% Helper function to update COMSOL model parameters
function updateComsolModel(model, vcsel, hc9)
    model.param.set('lda0', hc9/vcsel.Energy + "[nm]");
    model.param.set('n_up', vcsel.N_up);
    model.param.set('n_bottom', vcsel.N_down);
    model.param.set('k_up', vcsel.K_up);
    model.param.set('k_bottom', vcsel.K_down);

    dbr = vcsel.DBRs(1);
    % Set parameters for the first layer of the DBR
    model.param.set('t_DBR_1', dbr.Layer1.Thickness + "[nm]");
    model.param.set('n_1', dbr.Layer1.N);
    model.param.set('k_1', dbr.Layer1.K);
    
    % Set parameters for the second layer of the DBR
    model.param.set('t_DBR_2', dbr.Layer2.Thickness + "[nm]");
    model.param.set('n_2', dbr.Layer2.N);
    model.param.set('k_2', dbr.Layer2.K);

    % Set parameters for the buffer layer
    model.param.set('t_buffer', vcsel.Buffers(1).Thickness + "[nm]");

    % Set parameters for the Cavity_QW layer
    model.param.set('t_QW', vcsel.Cavity_QW.Thickness + "[nm]");
    model.param.set('gain_QW', vcsel.Cavity_QW.K + "[1/cm]");


    %model.save('C:\Users\lehas\Desktop\T_VCSEL\simulations\VCSEL_case\NewComsolModel2.mph');
end

% Helper function to run the COMSOL studies and retrieve results
function [evalData, gainData, evalErrorFlag, gainErrorFlag] = runComsolStudies(model)
    evalErrorFlag = 0;
    gainErrorFlag = 0;

    try
        model.study('std1').run();
        model.result.numerical('gev1').run();
        evalData = model.result.numerical('gev1').getReal();
    catch
        evalErrorFlag = 1;
        evalData = 0;
    end

    if evalErrorFlag == 0
        try
            model.study('std2').run();
            model.result.numerical('gev2').run();
            gainData = model.result.numerical('gev2').getReal();
        catch
            gainErrorFlag = 1;
            gainData = 0;
        end
    else 
        gainErrorFlag = 1;
        gainData = 0;
    end

end

% Helper function to generate output strings based on COMSOL results
function [eigenmodes_str, freq_threshold_str] = generateOutputStrings(evalData, gainData, hc9, evalErrorFlag, gainErrorFlag)
    if evalErrorFlag == 0

        EIGEN_ENERGY_1 = hc9/evalData(3,1);
        Q1 = evalData(2,1);
        
        if size(evalData, 2) >= 2
            EIGEN_ENERGY_2 = hc9/evalData(3,2);
            Q2 = evalData(2,2);
            eigenmodes_str = sprintf('EIGEN_ENERGY_1 %f Q1 %f EIGEN_ENERGY_2 %f Q2 %f', EIGEN_ENERGY_1, Q1, EIGEN_ENERGY_2, Q2);
        else
            eigenmodes_str = sprintf('EIGEN_ENERGY_1 %f Q1 %f', EIGEN_ENERGY_1, Q1);
        end
        
    else
        eigenmodes_str = "[]";
    end

    if gainErrorFlag == 0
        
        TRESHOLD_MATERIAL_GAIN = gainData(4);
        ENERGY = hc9/gainData(2);
        kappa_QW = -1*gainData(3);

        freq_threshold_str = sprintf('TRESHOLD_MATERIAL_GAIN %f ENERGY %f kappa_QW %f', TRESHOLD_MATERIAL_GAIN, ENERGY, kappa_QW);
    else
        freq_threshold_str = "[]";
    end
end

% Helper function to update the database with results
function updateDatabase(conn, inputString, eigenmodes_str, freq_threshold_str)
    update_query = sprintf('UPDATE vcsel_exp_data SET eigenmodes_solution = ''%s'', freq_threshold_solution = ''%s'' WHERE input_data = ''%s''', eigenmodes_str, freq_threshold_str, inputString);
    exec(conn, update_query);
end