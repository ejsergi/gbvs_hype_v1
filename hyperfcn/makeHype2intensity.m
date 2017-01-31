function Intim = makeHype2intensity(hypIM,lambda,CMFname,IlluName,gamma)

% Converts the hyperspectral image into a intensity grayscale image 
%   - hypIM: Hyperspectral image with size MxNxD being D the number of
%       spectral channels.
%   - lambda: Is an array containing the wavelenghts of the D spectral
%       channels.
%   - CMFname: String containing the name of the color matching function to
%       be used. For a complete list of the avaliable CMFs check the help 
%       of colorMatchFcn.m 
%       If no input is entered CIE1931 will be used.
%   - IlluName: String with name of the illuminant to be used. For a 
%       complete list of the avaliable illuminant, check help of the 
%       function illuminant.m
%       If no input is entered the default illuminant will be D65
%   - gamma: Gamma value to correct the RGB image. If no input the default
%   	is set to 0.6

if ( (~exist('CMFname','var')) || (isempty(CMFname)) )
    CMFname = 'CIE_1931';
end
if ( (~exist('IlluName','var')) || (isempty(IlluName)) )
    IlluName = 'D65';
end
if ( (~exist('gamma','var')) || (isempty(gamma)) )
    gamma = 0.6;
end

[xS, yS, zS] = size(hypIM);
hypSP = reshape(hypIM, xS*yS, zS);
[CMFlambda, xFcn, yFcn, zFcn] = colorMatchFcn(CMFname);
[Illulambda, energy] = illuminant(IlluName);
cmf = cat(1, xFcn, yFcn, zFcn)';
cmf = interp1(CMFlambda',cmf,lambda');
energy = interp1(Illulambda,energy,lambda')/100;
cmfIllu = cmf(:,2) .* energy;

nonanvalues = ~isnan(cmfIllu);
XYZim = reshape(hypSP(:,nonanvalues)*cmfIllu(nonanvalues),xS,yS,[]);
Intim = XYZim.^(gamma);
Intim = Intim - min(Intim(:));
Intim = Intim / max(Intim(:));
