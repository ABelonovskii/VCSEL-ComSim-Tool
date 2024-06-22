classdef Layer
    properties
        Thickness double
        N double
        K double
    end
    methods
        function obj = Layer(thickness, n, k)
            obj.Thickness = thickness;
            obj.N = n;
            obj.K = k;
        end
    end
end