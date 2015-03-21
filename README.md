# Making Audio Visualizations With Processing (on a mac)

This project is for getting people up and running visualizing audio using Processing (one of the more popular visualization libraries) and Minim (an audio analysis library built into processing.)

## Prerequisities 

## Install Processing
Download Processing from http://www.processing.org

Decompress the folder and drag Processing into your Applications folder on a mac. 

### Install Soundflower (optional)

If you'd like to process audio of any kind being played on your computer, I recommend using Soundflower to route your mac's output into it's input. I don't have a PC so I don't know how to do this on win/linux.

Download Soundflower from here: https://rogueamoeba.com/freebies/soundflower/

You may not be able to install Soundflower without enabling installing unsigned software on OSX. Navigate to  System Preferences->Security & Privacy->General and select  "Allow apps to be downloaded from anywhere"
This is normally an unsafe thing to do but Soundflower is alright. 

After installing Soundflower restart your computer. 

1. Go to  Audio MIDI Setup and create a multi output device. Add built-in output and Soundflower(64ch) to this device.
2. From Sound Preferences select your output as the multi output device. Under input select Soundflower(64ch)
3. Press play on a music app and ensure that the input levels in Sound Preferences react to audio being played. If the bars move, things are working.

# Visualizing Audio

1. Clone this repository if you have't already
  `git clone git@github.com:DADACONF/audioinput.git`
2. Open Processing
3. Go to File->Open and select the example/audioinput.pde from the repository you just cloned 
4. Press play in processing
5. Press play in a music app
6. Return to processing and you should see stuff happen
7. Get weird

# References
+ http://sweb.cityu.edu.hk/sm1204/2012A/page20/index.html
