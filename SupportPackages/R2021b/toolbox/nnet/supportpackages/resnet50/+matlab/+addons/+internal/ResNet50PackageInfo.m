classdef ResNet50PackageInfo < matlab.addons.internal.SupportPackageInfoBase
    %ResNet50 support package support for MATLAB Compiler.
    
    %   Copyright 2017-2018 The MathWorks, Inc.
    
    methods
        function obj = ResNet50PackageInfo()
            obj.baseProduct = 'Deep Learning Toolbox';
            obj.displayName = 'Deep Learning Toolbox Model for ResNet-50 Network';
            obj.name        = 'Deep Learning Toolbox Model for ResNet-50 Network';
            
            sproot = matlabshared.supportpkg.getSupportPackageRoot();
            
            % Define all the data that should be deployed from the support
            % package. This includes the actual language data, which will
            % be archived in the CTF.
            obj.mandatoryIncludeList = {...
                fullfile(sproot, 'toolbox','nnet','supportpackages','resnet50','+nnet') ...
                fullfile(sproot, 'toolbox','nnet','supportpackages','resnet50','resnet50.rights') ...
                fullfile(sproot, 'toolbox','nnet','supportpackages','resnet50','license_addendum') ...
                fullfile(sproot, 'toolbox','nnet','supportpackages','resnet50','data','resnet50.mat') };
            
            % Specify that the resnet50.mat data file should only be
            % suggested in the deploy app if the resnet50.m file is used in
            % the application code. Otherwise, there is no need to mention
            % it.
            obj.conditionalIncludeMap = containers.Map;
            obj.conditionalIncludeMap(fullfile(toolboxdir('nnet'), 'cnn', 'spkgs', 'resnet50.m')) = {};
            
        end
    end
end
