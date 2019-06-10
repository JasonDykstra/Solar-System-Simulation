class Solar_System_Info {
  float xpos = 15;
  float offset;
  float textSize;
  float namesSize;
  float valuesSize;

  ArrayList<Body> bodies;
  

  Solar_System_Info(ArrayList<Body> bodies) {
    offset = 17;
    textSize = 0;
    namesSize = 18;
    valuesSize = 13;

    this.bodies=bodies;
  }

  void display() {
    
    for(Button b : menuButtons){
      if(b.name() == "backButton"){
        b.exist();
      }
    }
    

    for (Body body : bodies) {
      textSize = namesSize;
      stroke(255, 255);
      fill(255, 255);
      textSize(textSize);

      text(body.name, xpos, 2*textSize+offset);
      offset+=2*textSize;

      textSize=valuesSize;
      textSize(textSize);
      String mass=""+body.mass*pow(10, 23);
      mass = mass.substring(0, 5) + "x10^" + mass.substring(mass.length() - 2, mass.length()) + " kg";
      text("Mass: "+mass, xpos + 10, 2*textSize+offset);
      offset+=1.7*textSize;

      String distance=""+body.distance;
      if (body.name!="Sun") {
        distance=distance.substring(0, 4)+"x10^"+distance.substring(distance.length()-1, distance.length())+" km";
      } else {
        distance="0 km";
      }
      text("Distance: "+distance, xpos + 10, 2*textSize+offset);
      offset += 1.7*textSize;
    }
    offset = 17;
  }
  
  void setX(float xpos){
    this.xpos = xpos;
  }
}