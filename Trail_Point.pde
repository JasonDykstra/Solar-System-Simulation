class Trail_Point {
  PVector position = new PVector(0, 0, 0);

  Trail_Point(PVector position) {
    this.position.set(position);
  }  
  
  PVector getPos(){
    return position;
  }
  
}