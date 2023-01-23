
float stepUp;

void enemyLevelUp() {

  if (maxEnemies < 10) {
    enemiesProperties.add(maxEnemies, new boolean[NUM_ENEMY_PROPERTIES]);
    newEnemies.add(maxEnemies, new Enemy(maxEnemies));
    birdFrame.add(0.0);
    enemiesProperties.get(maxEnemies)[SHOW]=true;
    maxEnemies++;
    levelUp = false;
  }

  if (minEnemyScale > 0.65 ) {
    minEnemyScale -= 0.04;
  }

  if (maxEnemyScale >= minEnemyScale) {
    maxEnemyScale -= 0.01;
  }


  if (stepUp > 7) {
    stepUp-=1;
  }
  //System.out.println("Difficulty Increased!");
}

void playerLevelUp() {
  life++;
  //System.out.println("Bonus Life!");
}
