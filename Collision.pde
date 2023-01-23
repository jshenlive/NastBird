
boolean checkCollision(float x2, float x1, float y2, float y1, float r1, float r2) {
  if (doMasterCollision) {
    float circleDist = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
    float radiiSum = (r1+r2)*(r1*r2);
    if (circleDist <= radiiSum) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

void hits(boolean isPlayer, float x, float y) {
  int numNodes = 0;
  if (isPlayer) {
    numNodes = 1000;
  } else {
    numNodes = 100;
  }

  flock.add(new Flock(isPlayer, numNodes));
  Flock curr = flock.get(flock.size()-1);
  for (int i = 0; i < numNodes; i++) {
    curr.addNode(new Node(isPlayer, x, y));
  }
}
