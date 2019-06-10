class Button {
  String name;
  float xpos;
  float ypos;
  float buttonWidth;
  float buttonHeight;
  color fillColor;
  String message;
  int textSize;
  int offset;
  boolean clicked;
  boolean pressed;


  Button(String name, float xpos, float ypos, float buttonWidth, float buttonHeight, String message, int textSize, int offset) {
    this.name = name;
    this.xpos = xpos;
    this.ypos = ypos;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.message = message;
    this.textSize = textSize;
    this.offset = offset;
    clicked = false;
    pressed = false;
  }

  void exist() {
    display();
  }

  void display() {
    noStroke();
    if (contains(mouseX, mouseY) && !clicked) {
      //fillColor = color(200, 100);
      stroke(255);
      strokeWeight(1);
    } else if (clicked) {
      fillColor = color(50, 100);
      stroke(255);
      strokeWeight(1);
    } else {
      fillColor = color(100, 100);
    }


    fill(fillColor);
    
    rect(xpos, ypos, buttonWidth, buttonHeight);
    textSize(textSize);
    fill(255);
    textAlign(LEFT, TOP);
    text(message, xpos + 15, ypos + buttonHeight/2 - textSize/2 - offset);
  }


  String name() {
    return name;
  }

  boolean contains(int x, int y) {
    if (x >= xpos && x <= xpos + buttonWidth
      && y >= ypos && y <= ypos + buttonHeight) {
      return true;
    }

    return false;
  }

  void wasClicked() {
    clicked = !clicked;
    if (clicked == false) {
      pressed = true;
    }
  }

  boolean isPressed() {
    return pressed;
  }
  
  void done(){
    pressed = false;
  }

  void setX(float x) {
    xpos = x;
  }
}