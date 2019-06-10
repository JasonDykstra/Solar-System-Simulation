class Slider {
  String name;
  float xpos;
  float ypos;
  float sliderx;
  float sliderValue;
  float max;
  float min;
  float barLength;
  int strokeWeight = 4;
  int defaultSliderRadius = 15;
  int sliderRadius;
  boolean draggable = false;
  boolean updating = false;


  Slider(String name, float startValue, float xpos, float ypos, float max, float barLength) {
    this.name = name;
    this.xpos = xpos;
    this.ypos = ypos;
    this.max = max;
    this.barLength = barLength;
    setValue(startValue);
  }

  Slider(String name, float startValue, float xpos, float ypos, float min, float max, float barLength) {
    this.name = name;
    this.xpos = xpos;
    this.ypos = ypos;
    this.min = min;
    this.max = max;
    this.barLength = barLength;
    setValue(startValue);
  }

  void update() {
    
    
    if (draggable) {
      updating = true;
      if (mouseX >= xpos
        && mouseX <= xpos + barLength) {
        sliderx = mouseX;
      }

      if (mouseX < xpos + ((min * barLength)/max)) {
        sliderx = xpos + ((min * barLength)/max);
      } else if (mouseX > xpos + barLength) {
        sliderx = xpos + barLength;
      }
      sliderRadius = defaultSliderRadius + 3;
      
      
    } else if(draggable == false){
      updating = false;
    }




    //returns value of slider [0, 1]
    sliderValue = ((sliderx - xpos)/barLength)*max;
  }

  void display() {
    if (!draggable) {
      sliderRadius = defaultSliderRadius;
    }
    textSize(15);
    stroke(255);
    fill(255);
    strokeWeight(strokeWeight);
    line(xpos, ypos, xpos + barLength, ypos);
    noStroke();
    ellipse(sliderx, ypos, sliderRadius, sliderRadius);
    stroke(255);
    fill(255);
    text(name, xpos, ypos - 30);
    textAlign(RIGHT);
    text(sliderValue, xpos + barLength, ypos - 15);
    textAlign(LEFT, TOP);
  }

  void check() {
    if (mouseX >= xpos - sliderRadius
      && mouseX <= xpos + barLength + sliderRadius
      && mouseY >= ypos - sliderRadius
      && mouseY <= ypos + strokeWeight + sliderRadius) {
      draggable = true;
    }
  }

  void setUndraggable() {
    draggable = false;
  }
  
  void setValue(float value){
    sliderx = xpos + ((value * barLength)/max);
  }
  
  void setStartValue(float value){
    sliderx = xpos + ((value * barLength)/max);
  }
  
  void setX(float xpos){
    this.xpos = xpos;
  }
  
}