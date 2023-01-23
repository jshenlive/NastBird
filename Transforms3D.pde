/*
Put your projection and camera operations here.
 Add more constants, variables and functions as needed.
 */

//ortho()
float left, right, top, bottom, near, far;

float fovY, aspect, zNear, zFar;

final float NEAR = 0.5;
final float FAR = 200;

PMatrix3D projectOrtho, projectPerspective;

void setupProjections() {
  ortho(-1.1, 1.1, 1, -1, NEAR, FAR); // PLACEHOLDER - CHANGE THIS LINE TO USE YOUR CALCULATED PARAMETERS!
  projectOrtho = getProjection();
  fovY = PI/3;
  perspective(fovY, 1, NEAR, FAR); // PLACEHOLDER - CHANGE THIS LINE TO USE YOUR CALCULATED PARAMETERS!
  fixFrustumYAxis();
  projectPerspective = getProjection();
}

void updateOrthoBounds() {
  topXBound = 10;
  botXBound = 10;
  topYBound = 9;
  botYBound = -9;
}

void updatePerspectiveBounds() {
  topXBound = 14;
  botXBound = 8;
  topYBound = 11;
  botYBound = -8;
  orthoOffset = 0;
}
