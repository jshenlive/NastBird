final float PIXELS_PER_SEC = 100;

int numStepsForConstantSpeed(PVector start, PVector end, float speed) {
  PVector displacement = end.copy();
  displacement.sub(start);    // subtract vector start with displacement
  float distance = displacement.mag();   //gets the magnitude of displacement
  return int(distance*speed*FRAME_RATE/PIXELS_PER_SEC);
}
