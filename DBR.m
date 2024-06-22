classdef DBR
    properties
        PairsCount double
        Layer1 Layer
        Layer2 Layer
    end
    methods
        function obj = DBR(pairsCount, layer1, layer2)
            obj.PairsCount = pairsCount;
            obj.Layer1 = layer1;
            obj.Layer2 = layer2;
        end
    end
end