function vcsel = extractParameters(str)
% Helper function to extract parameters from input string
    tokens = strsplit(str);
    vcsel = VCSEL();
    i = 1;
    while i <= length(tokens)
        token = tokens{i};
        switch token
            case 'ENERGY'
                i = i + 1;
                vcsel.Energy = str2double(tokens{i});
            case 'BOUNDARY'
                i = i + 1;
                while ~ismember(tokens{i}, {'N', 'K'})
                    i = i + 1;
                end
                if strcmp(tokens{i}, 'N')
                    i = i + 1;
                    if isempty(vcsel.N_down)
                        vcsel.N_down = str2double(tokens{i});
                    else
                        vcsel.N_up = str2double(tokens{i});
                    end
                end
                while ~strcmp(tokens{i}, 'K')
                    i = i + 1;
                end
                i = i + 1;
                if isempty(vcsel.K_down)
                    vcsel.K_down = str2double(tokens{i});
                else
                    vcsel.K_up = str2double(tokens{i});
                end
            case 'PAIRS_COUNT'
                i = i + 1;
                pairsCount = str2double(tokens{i});
                while ~strcmp(tokens{i}, 'THICKNESS')
                    i = i + 1;
                end
                i = i + 1;
                thickness1 = str2double(tokens{i});
                while ~strcmp(tokens{i}, 'N')
                    i = i + 1;
                end
                i = i + 1;
                n1 = str2double(tokens{i});
                while ~strcmp(tokens{i}, 'K')
                    i = i + 1;
                end
                i = i + 1;
                k1 = str2double(tokens{i});
                while ~strcmp(tokens{i}, 'THICKNESS')
                    i = i + 1;
                end
                i = i + 1;
                thickness2 = str2double(tokens{i});
                while ~strcmp(tokens{i}, 'N')
                    i = i + 1;
                end
                i = i + 1;
                n2 = str2double(tokens{i});
                while ~strcmp(tokens{i}, 'K')
                    i = i + 1;
                end
                i = i + 1;
                k2 = str2double(tokens{i});
                layer1 = Layer(thickness1, n1, k1);
                layer2 = Layer(thickness2, n2, k2);
                dbr = DBR(pairsCount, layer1, layer2);
                vcsel = vcsel.addDBR(dbr);
            case 'LAYER'
                % First we parse the current layer
                i = i + 2; % Skip 'THICKNESS'
                thickness = str2double(tokens{i});
                i = i + 2; % Skip 'N'
                n = str2double(tokens{i});
                i = i + 2; % Skip 'K'
                k = str2double(tokens{i});
                currentLayer = Layer(thickness, n, k);
                
                % Logic for adding layers
                if isempty(vcsel.Additional)
                    vcsel.Additional = currentLayer;
                elseif isempty(vcsel.Buffers)
                    vcsel.Buffers = currentLayer;
                elseif isempty(vcsel.Cavity_QW)
                    vcsel.Cavity_QW = currentLayer;
                else
                    vcsel.Buffers = [vcsel.Buffers, currentLayer]; %  Adding a second buffer layer
                end
                    
        end
        i = i + 1;
    end
end