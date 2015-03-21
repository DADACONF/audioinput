/**
 * Proof of concept for building an audiovisualizer using Processing
 * Lifted most of this code from example sketches on the processing website. 
 **/
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
BeatDetect beat;
BeatListener beatListener;

float beatDecay = -1;

void setup()
{
  size(displayWidth, displayHeight);
  colorMode(RGB, 255, 255, 255, 1.0);
  ellipseMode(RADIUS);
  frameRate(30);
  
  /**
   * Minim is the instance object for accessing the minim API.
   * Read more about Minim here: http://code.compartmental.net/tools/minim/ 
   **/
  minim = new Minim(this);  
  // Get a reference to this computer's stereo input with a buffer size of 1024 samples.
  in = minim.getLineIn(Minim.STEREO, 1024);
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  // Once a beat is detected, the beat detector will ignore beats for the specified time (ms)
  beat.setSensitivity(300);  
  // Attach a BeatListener to our audio input
  beatListener = new BeatListener(beat, in);  
}

color[] beatColors = {
  color(255, 0, 0),
  color(0, 255, 0),
  color(0, 0, 255)
};
int beatColor = 0;

void draw()
{
  background(0);
  noFill();
  
  int n = 100;
  
  if (beat.isKick()) {
    beatDecay = 0;
    beatColor++;
    beatColor %= 3;
  } else if (beatDecay >= 0) {
    beatDecay += 5;
    if (beatDecay >= n) {
      beatDecay = -1; 
    }
  }
  
  for (int i = 0; i < n; i++)
  {
    if (beatDecay >= 0) {
      color from = beatColors[beatColor];
      color to   = color(255);
      stroke(lerpColor(from, to, abs(beatDecay - i) / 2), 0.6);
    } else {
      stroke(255, 0.6);
    }
    strokeWeight(16 + max(in.left.get(i * in.bufferSize() / n) * 200, -16));
    ellipse(width / 2, height / 2, i * 8, i * 8);
  }
}

/**
 * A very basic AudioListener that detects beats when given a sample of a source. 
 **/
class BeatListener implements AudioListener
{
 private BeatDetect beat;
 private AudioInput source;

  BeatListener(BeatDetect beat, AudioInput source) 
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  } 
  
  void samples(float[] samps)
  {
    beat.detect(source.mix); 
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix); 
  }
}


