# Adaptation of GBVS to Hype (V1)

This code is an adaptation of the GBVS original matlab [code](http://www.vision.caltech.edu/~harel/share/gbvs.php), proposed in:

> J. Harel, C. Koch, and P. Perona, "Graph-Based Visual Saliency", Proceedings of Neural Information Processing Systems (NIPS), 2006.

## Documentation

The codes follows the same file structure as the original *GBVS* code. Inside each file there have been modifications so it can read and analyze hyperspectral images. Original *GBVS* took a RGB image and extracted some already defined features, saved in so called feature maps. Afterwards it uses all the feature maps in different scales to create the activation maps, where all the pixels in each map are compared with each other graphically.

### Hyperspectral features

The features functions have been either created or adapted to take a hyperspectral image as an input and give a specific feature map. Each function in the directory `/util/featureChannels` is a function to create a different feature map:

#### Adapted features

- **Color ('C')**: It first transforms the hyperspectral image in RGB using CMFs and then it returns two maps: blue-yellow and red-green, as computed in Itti's model.
- **DKL Color ('D')**: It uses the DKL space to return the three channels as a three maps: Luminosity, blue-yellow and red-green. First it transforms the hyperspectal image to RGB using CMFs and then is transformed to the DKL color space.
- **Intensity ('I')**: It uses the V function to transform the hyperspectal image to a monochannel intensity image.
- **Orientation ('O')**: It uses gabor filters over the intensity channel to enhance the angle in four different angles. The angles to use is a parameter of the function, by default set to 0º, 45º, 90º and 135º.
- **Contrast ('R')**: It finds the contrast out of the intensity channel.

#### Created features

- **CIELab ('L')**: It returns each of the channels of the CIELab space as a map: Lightness (L), red-green (a) and blue-yellow (b). Is recommended to use this space instead of Itti's or DKL, since it shows better the perceptual difference. The CIELab values are calculated by transforming the hyperspectral image into XYZ using the CMFs and then transformed to CIELab.
- **PCA ('P')**: It takes each of the pixels of the hyperspectral image as a reflectance vector, then it uses all of them to find the principal components through PCA. Afterwards it returns the *n* first components of each pixel as an image. This calculation allows to find the channels where the maximum variance is located in the spectral image. This can be considered an efficient way of reducing the dimensionality without loosing information, and in this case finding the maximum difference between the spectral pixels in the same image. 

After all the features are created, they are activated, normalize and combined to form a final saliency map, in the same way as it is proposed in the *GBVS*.

### Parameters

When running the function, two inputs need to be entered. First the hyperspectral image, being it a MxNxD matrix where D are the spectral dimensions. The second input is a struct with all the parameters needed. The struct with all the default parameters can be created running the function `makeGBVSParams.m`.

All the parameters are usually set to defaults for a standard *GBVS* procedure. But in the case of this hyperspectral modifictaion, three parameters need to be set:

- **channels**: A string containing the letters that indicate what features need to be used. As default for hyperspectral images is recommended to use CIELab ('L'), PCA ('P') and Orientation ('O'), `'LPO'`.
- **lambda**: is a vector indicating the wavelength of which correspond each channel of the hyperspectral image. 
- **numberPCA**: the number of first principals components that should be passed to the activation maps. Usually the 3 first components contains 90% of the information.

## Installing and Running 

Before running any script we need to change the directory to the folder `/gbvs` and then execute the script `gbvs_install.m` which will add all the dependencies to the path and save it.

The next step is to create the *struct* variable containing all the parameters, and then adjust some important parameters, as the next example:
```matlab
param = makeGBVSParams;
param.channels = 'LPO';                % Feature maps to be computed

param.lambda = 400:10:1000;            % Wavelenght of each channel of the
                                       % input image
                                        
param.numberPCA = 3;                   % Number of PCAs to be used
```

Once we have the image and the parameters we can call `gbvs_hype_v1` which will return the saliency map. 

The script `demoHype.m` shows an example of how to run the functions and then display the map overlying the image.

### False color

There is an adaptation function `falsecolot_gbvs` which separates the hyperspectral image in visible and infrared. Applying *GBVS* to both of them separately and returning a false color map with the visible information (green) and the infrared (purple) together. The function needs an extra input which is the cutting wavelength (usually 700 nm).

The script `demoFalse.m` shows an example of how to call the function and display the result.

### Results

The following image shows the output example of both, *GBVS* and the false color modification.
![](https://i.imgur.com/KZfscRo.png)

