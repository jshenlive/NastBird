import java.util.Iterator;


class Flock {
  ArrayList<Node> nodes; // An ArrayList for all the nodes
  int numNodes;
  boolean isPlayer;

  Flock(boolean isPlayer, int numNodes) {
    nodes = new ArrayList<Node>(); // Initialize the ArrayList
    this.numNodes = numNodes;
    this.isPlayer = isPlayer;
  }

  void run() {
    for (Node n : nodes) {
      n.run(); 
      pushMatrix();
      scale(GLOBAL_SCALE, GLOBAL_SCALE, 1);
      n.render();
      popMatrix();
    }
  }

  void addNode(Node n) {
    nodes.add(n);
  }

  void delete() {
    Iterator<Node> itr = nodes.iterator();
    while (itr.hasNext()) {
      Node n = itr.next();
      if (!n.alive) {
        itr.remove();
        numNodes--;
      }
    }
  }
}


class Node {
  PImage img;

  int maxLifespan = 60; // frames
  int lifespan;  // total lifespan in frames
  int t;  // number of frames lived so far

  float maxspeed;
  float r;

  boolean alive;
  boolean isPlayer;

  PVector position;
  PVector velocity;

  Node(boolean isPlayer, float x, float y) {
    this.isPlayer = isPlayer;
    if (isPlayer) {
      maxLifespan = 180;
    }
    img = featherImg;
    velocity = PVector.random3D();
    velocity.normalize();
    position = new PVector(x, y, 0);
    r = 1.0;
    maxspeed = 0.075;
    alive = true;
    lifespan = (int)random(maxLifespan);
    t = 0;
  }

  void run() {
    update();
    lifecycle();
  }

  void update() {
    velocity.limit(maxspeed);
    position.add(velocity);
  }

  void lifecycle() {
    t++;
    if (t > lifespan) {
      alive = false;
    }
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(-90);

    pushMatrix();
    translate(position.x, position.y, position.z*0.1);
    rotate(theta);

    if (isPlayer) {
      scale(0.15, 0.15, 1);
      fill(random(1), random(1), random(1));
      drawSingleSquare();
    } else {
      scale(0.25, 0.55, 1);
      drawSingleTextureSquare(img);
    }
    popMatrix();
  }
}
