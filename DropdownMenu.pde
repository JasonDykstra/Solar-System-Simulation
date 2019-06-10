class DropdownMenu{
  float xpos;
  float ypos;
  float barWidth;
  float barHeight;
  boolean pressed;
  String title;
  color fillColor;
  color defaultFillColor;
  boolean clicked;
  int textSize;
  float offset;
  boolean menuIsOpen;
  ArrayList<String> options;
  ArrayList<Button> listButtons = new ArrayList<Button>();
  String name;
  
  
  
  DropdownMenu(String name, float xpos, float ypos, float barWidth, float barHeight, String title, float offset, ArrayList<String> options){
    this.name = name;
    this.xpos = xpos;
    this.ypos = ypos;
    this.barWidth = barWidth;
    this.barHeight = barHeight;
    this.title = title;
    clicked = false;
    pressed = false;
    defaultFillColor = color(100, 100);
    textSize = 15;
    this.offset = offset;
    menuIsOpen = false;
    this.options = options;
    for(int i = 0; i < options.size(); i++){
      listButtons.add(new Button(options.get(i), xpos, ypos + barHeight*(i+1), barWidth, barHeight, options.get(i), 12, 3)); 
    }
  }
  
  void exist(){
    display();
  }
  
  void display(){
    
    noStroke();
    if(contains(mouseX, mouseY) && !clicked){
      stroke(255);
      strokeWeight(1);
    } else if(clicked){
      fillColor = color(50, 100);
      stroke(255);
      strokeWeight(1);
    } else {
      fillColor = defaultFillColor;
    }
    
    fill(fillColor);
    
    rect(xpos, ypos, barWidth, barHeight);
    textSize(textSize);
    fill(255);
    
    textAlign(LEFT, CENTER);
    text(name, xpos, ypos - barHeight/2 + offset);
    text(title, xpos + 5, ypos + barHeight/2 - offset);
    textAlign(LEFT, TOP);
    
    
    if(menuIsOpen){
      for(int i = 0; i < options.size(); i++){
        //fill(defaultFillColor);
        for(Button b : listButtons){
          
          if(b.isPressed()){
            b.done();
            menuIsOpen = false;
            title = b.name;
          }
          b.exist();
        }
      }
    }
  }
  
  boolean contains(int x, int y) {
    if (x >= xpos && x <= xpos + barWidth
      && y >= ypos && y <= ypos + barHeight) {
      return true;
    }

    return false;
  }

  void wasClicked() {
    clicked = !clicked;
    if (clicked == false) {
      pressed = !pressed;
      menuIsOpen = !menuIsOpen;
    }
  }
  
  boolean isPressed(){
    return pressed;
  }
  
  void setX(float x){
    xpos = x;
  }
  
  ArrayList<Button> getListButtons(){
    return listButtons;
  }
}