classdef VCSEL
    properties
        Energy double
        N_down double
        K_down double
        N_up double
        K_up double
        DBRs DBR
        Buffers Layer
        Additional Layer
        Cavity_QW Layer
    end
    methods
        function obj = VCSEL()
            obj.DBRs = DBR.empty;
            obj.Buffers = Layer.empty;
            obj.Additional = Layer.empty;
            obj.Cavity_QW = Layer.empty;
        end
        function obj = addDBR(obj, dbr)
            obj.DBRs(end+1) = dbr;
        end
        function obj = addBuffer(obj, buffer)
            obj.Buffers(end+1) = buffer;
        end
        function obj = setAdditional(obj, layer)
            obj.Additional = layer;
        end
        function obj = setCavityQW(obj, layer)
            obj.Cavity_QW = layer;
        end
    end
end