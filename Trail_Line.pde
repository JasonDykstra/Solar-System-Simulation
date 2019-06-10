class Trail_Line {
  PVector position1 = new PVector(0, 0, 0);
  PVector position2 = new PVector(0, 0, 0);
  int alpha = 200;
  float strokeWeight = 2;
  int counter = 0;
  //planet position to scale subAlpha
  PVector position = new PVector(0, 0, 0);

  Trail_Line(PVector position1, PVector position2) {
    this.position1.set(position1);
    this.position2.set(position2);
  }

  void update(PVector position) {
    this.position.set(position.copy());
    strokeWeight = 1/scaleFactor;
    if (strokeWeight < 1) {
      strokeWeight = 1;
    } else if (strokeWeight > 5) {
      strokeWeight = 5;
    }
    strokeWeight(strokeWeight);
    stroke(0, 255, 100, alpha);

    line(position1.x, position1.y, position1.z, position2.x, position2.y, position2.z);

    subAlpha();
  }

  void subAlpha(){
      if(counter >= 1){
      alpha -= 1;
      counter = 0;
    }
    counter++;
  }

  int getAlpha() {
    return alpha;
  }
}