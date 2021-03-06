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

boolean beatToDraw = false;
final int BEAT_DECAY_START = 30;
final int BEAT_DETECT_DELAY_MS = 300;
int beatDecay = BEAT_DECAY_START;
float sliceSize;

public int sketchWidth() { return displayWidth; }

public int sketchHeight() {return displayHeight; }

public String sketchRenderer() { return P2D; }
/**
 * Configures the frame rate, window size, and you can add any code here for any global state
 * that needs to be managed. 
 **/
void setup() {
  // Enables a resizeable window
  if (frame != null) {
    frame.setResizable(true);
  }
  frameRate(30);
  size(sketchWidth(), sketchHeight(), sketchRenderer());
  ellipseMode(RADIUS);
  
  /**
   * Minim is the instance object for accessing the minim API.
   * Read more about Minim here: http://code.compartmental.net/tools/minim/ 
   **/
  minim = new Minim(this);  
  // Get a reference to this computer's stereo input with a buffer size of 1024 samples.
  in = minim.getLineIn(Minim.STEREO, 1024);
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  // Once a beat is detected, the beat detector will ignore beats for the specified time (ms)
  beat.setSensitivity(BEAT_DETECT_DELAY_MS);  
  // Attach a BeatListener to our audio input
  beatListener = new BeatListener(beat, in);  

  sliceSize = (sketchWidth() / in.bufferSize()) * 4;  
}

void draw() 
{
  background(0, 211, 211);

  for(int i = 0; i < in.bufferSize() - 1; i+= 4)
  {
    stroke(135, 0, 136);    
    line(i* sliceSize, (sketchHeight() / 4), i * sliceSize, (sketchHeight() / 4) - (in.left.get(i + 1) * 3000));
    stroke(123, 183, 0);
    drawAmplitudeBar(i, 3 * sketchHeight() / 4, in.right.get(i)); 
  }
  
  if(beat.isKick()) {
    beatToDraw = true;
    beatDecay =  BEAT_DECAY_START;
  } 
  
  int quarterScreen = sketchHeight() / 4;
  float beatDelta = (quarterScreen / BEAT_DECAY_START);
  if(beatToDraw) {
    ellipse(4 * sketchWidth() / 6, sketchHeight() / 4, beatDecay * beatDelta, beatDecay * beatDelta);
    ellipse(2 * sketchWidth() / 6, sketchHeight() / 4, beatDecay * beatDelta, beatDecay * beatDelta);
    ellipse(3 * sketchWidth() / 6, 3 * sketchHeight() / 4, beatDecay * beatDelta, beatDecay * beatDelta);
    stroke(165 * (1/beatDecay) , 132 * (1/beatDecay), 0);
    
    beatDecay--;
    if(beatDecay == 10) {
      beatToDraw = false; 
    }
  }
}

void drawAmplitudeBar(int slice, int yOrigin, float amplitude) {
  float x, y, h;  
  x = slice * sliceSize;
  h = (amplitude * 3000);
  if(amplitude < 0) {
    y = yOrigin + h;
  } else {
    y = yOrigin;
  }
  rect(x, y, sliceSize * 4, Math.abs(h));
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


