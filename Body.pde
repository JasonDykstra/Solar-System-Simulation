class Body {
  PVector position = new PVector(0, 0, 0);
  PVector display_position = position.copy();
  PVector velocity = new PVector(0, 0, 0);
  PVector acceleration = new PVector(0, 0, 0);

  String name;

  float mass;
  float distance;
  float radius;
  float angle;
  float massScalar;
  float velocityScalar;

  String type;
  boolean drawTrail=false;
  boolean drawBody=true;
  boolean isCenter = false;

  ArrayList<Trail_Point> trail = new ArrayList<Trail_Point>();
  ArrayList<Trail_Line> trailLines = new ArrayList<Trail_Line>();

  int trailCounter = 0;

  //F1 = v2-v1
  //F2 = v1-v2


  int ptsW, ptsH;

  PImage texture;

  int numPointsW;
  int numPointsH_2pi; 
  int numPointsH;

  float[] coorX;
  float[] coorY;
  float[] coorZ;
  float[] multXZ;

  float u=0;  // Width variable for the texture
  float v=0;  // Height variable for the texture
  float defaultU = 0;

  float lastEarthPositionZ = 0;
  
  float display_distance_scalar=2*pow(10,9);

  Body(String type, String name, PVector position, PVector velocity, float mass, float radiusScalar, float distance, PImage texture) {
    this.type = type;
    this.name=name;
    this.position.set(position);
    this.display_position.set(position);

    this.velocity.set(velocity);

    this.mass = mass;

    this.distance=distance;

    switch(type) {
    case "Sun":
      this.radius = pow(mass*(radiusScalar), 1/3.0);
      break;
    case "Planet":
      this.radius = pow(1000*mass*(radiusScalar), 1/3.0);
      break;
    case "Comet":
      this.radius = 2;
      break;
    default: 
      println("you messed up");
    }


    this.texture = texture;
    ptsW = 30;
    ptsH = 30;
    numPointsW = 0;
    numPointsH_2pi = 0;
    numPointsH = 0;

    initializeSphere(ptsW, ptsH);
  }

  void exist() {
    if(name == "Sun"){
      lastSunPos.set(position.copy());
    }
    
    velocity.add(acceleration.copy().mult(delta_time));
    position.add(velocity.copy().mult(delta_time));
    
    calculate();
    display_position = position.copy().mult(1/display_distance_scalar);
    
    if (drawBody) {
      //update speed based on velocity
      if (trailCounter >= 5/velocity.copy().mag()) {
        addTrail();
        trailCounter = 0;
      }
      drawTrail();
      trailCounter++;
    }
  }

  void calculate() {
    
    if (lastEarthPositionZ < 0 && name == "Earth" && position.z >= 0) {
      earthOrbitCounter++;
    }

    if (name == "Earth") {
      lastEarthPositionZ = position.z;
    }
  }

  void addTrail() {
    trail.add(new Trail_Point(display_position));

    //add a new line between two most recent points along a body's path
    if (trail.size() >= 2) {
      trailLines.add(new Trail_Line(trail.get(trail.size() - 2).position, trail.get(trail.size() - 1).position));
    }
  }


  void drawTrail() {
    //"catch up" line
    if (trail.size() >= 1) {
      line(trail.get(trail.size() - 1).position.x, trail.get(trail.size() - 1).position.y, trail.get(trail.size() - 1).position.z, display_position.x, display_position.y, display_position.z);
    }

    //update alpha of trail lines and remove them if their alpha is 0
    for (int i = 0; i < trailLines.size(); i++) {
      trailLines.get(i).update(this.display_position);
      if (trailLines.get(i).getAlpha() <= 0) {
        trailLines.remove(i);
      }
    }
  }


  void initializeSphere(int numPtsW, int numPtsH_2pi) {
    // The number of points around the width and height
    numPointsW=numPtsW+1;
    numPointsH_2pi=numPtsH_2pi;  // How many actual pts around the sphere (not just from top to bottom)
    numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

    coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
    coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
    coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
    multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

    for (int i=0; i<numPointsW; i++) {  // For all the points around the width
      float thetaW=i*2*PI/(numPointsW-1);
      coorX[i]=sin(thetaW);
      coorZ[i]=cos(thetaW);
    }

    for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
      if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
        float thetaH=(i-1)*2*PI/(numPointsH_2pi);
        coorY[i]=cos(PI+thetaH); 
        multXZ[i]=0;
      } else {
        //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
        float thetaH=i*2*PI/(numPointsH_2pi);

        //PI+ below makes the top always the point instead of the bottom.
        coorY[i]=cos(PI+thetaH); 
        multXZ[i]=sin(thetaH);
      }
    }
  }

  void textureSphere(float r) { 

    // These are so we can map certain parts of the image on to the shape 
    float changeU=texture.width/float(numPointsW-1); 
    float changeV=texture.height/float(numPointsH-1); 


    beginShape(TRIANGLE_STRIP);
    textureWrap(REPEAT); //processing doesn't have a "remove texture" function like background(0); so it's just infinitely wrapping 
    texture(texture);
    for (int i=0; i<(numPointsH-1); i++) {  // For all the rings but top and bottom
      // Goes into the array here instead of loop to save time
      float coory=coorY[i];
      float cooryPlus=coorY[i+1];

      float multxz=multXZ[i];
      float multxzPlus=multXZ[i+1];

      for (int j=0; j<numPointsW; j++) { // For all the pts in the ring
        normal(-coorX[j]*multxz, -coory, -coorZ[j]*multxz);
        vertex(coorX[j]*multxz*r, coory*r, coorZ[j]*multxz*r, u, v);
        normal(-coorX[j]*multxzPlus, -cooryPlus, -coorZ[j]*multxzPlus);
        vertex(coorX[j]*multxzPlus*r, cooryPlus*r, coorZ[j]*multxzPlus*r, u, v+changeV);
        u+=changeU;
      }
      v+=changeV;
      u=defaultU;
    }
    endShape();
    v = 0;
    defaultU -= 1;
    u = defaultU;
  }
}
