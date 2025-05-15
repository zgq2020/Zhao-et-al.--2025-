--------------------------------------------
This script modified from Chandel et al. (2024), to automatically track mosquito and calculate preference.

From https://github.com/Craig-Montell-Lab/Chandel_DeBeaubien_2023

Chandel, A., Debeaubien, N. A., Ganguly, A., Meyerhof, G. T., Krumholz, A. A., Liu, J., et al. （2024）. Thermal infrared directs host-seeking behaviour in Aedes aegypti mosquitoes. Nature, 633, 615-623.

--------------------------------------------
# Installation

This code requires a MATLAB installation with Image Processing and Computer Vision Toolbox.

For MATLAB system requirements please visit: https://www.mathworks.com/support/requirements/matlab-system-requirements.html

This code has been tested on Windows operating systems.  This code has been tested on MATLAB vserions R2022b and later.  This code does not require any non-standard software.

--------------------------------------------
# Principle

Mosquito identification: A black-and-white background model was utilized to detect mosquitoes, which appear as black blots against the white background.

Score: The script divides each video frame into two equally sized study regions using the coordinates of six reference points: the four corners, the top center, and the bottom center. The left study area is defined by the top-left and bottom-left corner coordinates, along with the top-center and bottom-center coordinates.  Conversely, the right study area is defined by the top-right and bottom-right corner coordinates, using the same top-center and bottom-center coordinates. The PI for each video frame was calculated using the formula: PI = (number of mosquitoes in the right area - number of mosquitoes in the left area) / (number of mosquitoes in the right area + number of mosquitoes in the left area).  It is important to note that during technical replicates, the positive or negative value of the PI may require manual adjustment.  Finally, the PI per minute was determined by averaging the PI values across all video frames within that minute.

--------------------------------------------
# Usage Steps:
1. Open the Launch.m script.

    Replace the content within single quotes in YourPath = 'YourPath' with the directory where your script is located (line 2 of Lanch.m).

2. Place the '.mov' or '.mp4' video files in a folder named 'v'.

    A test video named "video.1" has been placed in the folder.

    You can modify the code fileList = dir('*.mp4') to recognize different video types (line 24 of Lanuch.m).

3. Run the Launch.m script, and a window will pop up for you to select the directory, and just click to 'select folder'.

    Lines 32-33 allow you to customize the coordinate range of the two areas.

4. The results obtained from video analysis are saved in '.mat' files under the video directory.Generate a '.mat' file every minute.
   
    vidName_1.mat represents the results of the analysis from minute 0 to minute 1 of the original video.

    vidName_2.mat represents the results of the analysis from minute 1 to minute 2 of the original video.
   
    ...

--------------------------------------------
Uncomment lines 51 to 65, and you can see the effect of mosquito extraction.

Uncomment lines 33-37, 68-70, and 83, and you can save the visualized video.

--------------------------------------------
If you put video.S1.mp4 in the v folder and run the code, the result you output will be:

Video.1_1_PI = -0.0666;

Video.1_2_PI = 0.0283;

Video.1_3_PI = 0.0809;

Video.1_4_PI = 0.1248;

Video.1_5_PI = 0.1540.
