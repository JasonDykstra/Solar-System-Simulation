class Star{
  ArrayList<PVector> drops;
  PVector velocity;
  PVector line;
  int frequency;
  int starBoxSize = 5000;
  float strokeWeight;
  
  /*
    keeps track of every "star" as a point in an ArrayList
    and extends them into lines depending on their velocity
    vector.
  */
  
  Star(int frequency){
    velocity=new PVector(0,0,0);
    this.frequency=frequency;
    drops=new ArrayList<PVector>();
    line=new PVector(0,0,0);
    
    for(int i=0;i<10000;i++){
      drops.add(new PVector(random(-starBoxSize,starBoxSize),random(-starBoxSize,starBoxSize),random(-starBoxSize, starBoxSize)));
    }
  }
  
  //all-in-one run method
  void star(float speed){
    update(speed);
    display(speed);
  }
  
  
  void setFrequency(float speed){
    frequency=int(speed);
  }
  
  //calculate where the points will move next and update them
  void update(float speed){
    velocity=new PVector(0,0,random(speed-speed/3, speed+speed/3));
    if(speed<0.5){
      line=new PVector(0,0,1);
    }else{
      line=velocity.copy();
      line.mult(-1);
    }
    for(int i=0;i<frequency;i++){
      drops.add(new PVector(random(-starBoxSize,starBoxSize),random(-starBoxSize,starBoxSize),-starBoxSize));
    }
    for(int i=0;i<drops.size();i++){
      drops.get(i).add(velocity);      
      if(drops.get(i).z>starBoxSize){
        drops.remove(i);
      }
    }
  }
  
  //draw a line behind the point dependent upon the direction
  void display(float speed){
    stroke(255-speed/2,255-speed/2,255);
    strokeWeight = 1/scaleFactor;
    if(strokeWeight < 1){
      strokeWeight = 1;
    } else if(strokeWeight > 3){
      strokeWeight = 3;
    }
    strokeWeight(strokeWeight);
    for(int i=0;i<drops.size();i++){
      point(drops.get(i).x,drops.get(i).y,drops.get(i).z);
    }
  }
}