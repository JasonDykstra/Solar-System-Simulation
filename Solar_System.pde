class Solar_System {
  ArrayList<Body> bodies = new ArrayList<Body>();
  float G = 6.67*(pow(10, 12.0));
  
  ArrayList<PVector> positions = new ArrayList<PVector>();
  float[] masses = new float[0];

  //Body Masses are all divided by 10^23
  //Body Velocitys are unadjusted
  //Body Distances are unadjusted
  //G is multiplied by 10^23 to compensate for Masses
  //Gravity calculations are unadjusted
  //Measurements found on wikipedia, used rounded values as well

  float mercuryMass = 3.301;
  float mercuryR = 57.91*pow(10, 9);    //57.91 billion m
  float mercuryV = 47870;     //8.7778 //m/s
  float mercuryAngle = 6.34;

  float venusMass = 41.380;
  float venusR = 108.2*pow(10, 9);
  float venusV = 35020;      //6.4815
  float venusAngle = 2.19;

  float earthMass = 59.722;
  //float earthR = pow(2.5837, 6);
  float earthR = 149.6*pow(10, 9);
  float earthV = 29780;    //5.495
  float earthAngle = 7.155;
  float moonMass = 0.734767309;

  float marsMass = 6.427;
  float marsR = 227.9*pow(10, 9);
  float marsV = 24077;   //4.4630
  float marsAngle = 5.65;

  float jupiterMass = 18985.219;
  float jupiterR = 778.3*pow(10, 9);
  float jupiterV = 13070;    //2.4259
  float jupiterAngle = 6.09;

  float saturnMass = 5684.66;
  float saturnR = 1427*pow(10, 9);
  float saturnV = 9690;    //1.7778
  float saturnAngle = 5.51;

  float uranusMass = 868.20;
  float uranusR = 2871*pow(10, 9);
  float uranusV = 6810;   //1.2593
  float uranusAngle = 6.48;

  float neptuneMass = 1024.31;
  float neptuneR = 4497.1*pow(10, 9);
  float neptuneV = 5430;      //1
  float neptuneAngle=6.43;


  //Non-planet bodies

  float sunMass = 19890000;

  //Halley's Comet
  float halleyMass = 0.0000000022;
  float halleyR = 88.02*pow(10, 9);
  float halleyV = 54034; //9.9511*neptune
  float halleyAngle = 162.26;
  //70560 m/s


  //Scalar for displaying planets
  float radiusScalar = .0001;
  float collision_factor=.8;

  Solar_System() {
    bodies.add(new Body("Sun", "Sun", new PVector(0, 0, 0), new PVector(0, 0, 0), sunMass, radiusScalar, 0, sunTexture));
    bodies.add(new Body("Planet", "Mercury", new PVector(0, mercuryR*sin(radians(mercuryAngle)), mercuryR*cos(radians(mercuryAngle))), new PVector(mercuryV, 0, 0), mercuryMass, radiusScalar, mercuryR, mercuryTexture));
    bodies.add(new Body("Planet", "Venus", new PVector(0, venusR*  sin(radians(venusAngle)), venusR*cos(radians(venusAngle))), new PVector(venusV, 0, 0), venusMass, radiusScalar, venusR, venusTexture));
    bodies.add(new Body("Planet", "Earth", new PVector(0, earthR*sin(radians(earthAngle)), earthR*cos(radians(earthAngle))), new PVector(earthV, 0, 0), earthMass, radiusScalar, earthR, earthTexture));
    bodies.add(new Body("Planet", "Mars", new PVector(0, marsR*sin(radians(marsAngle)), marsR*cos(radians(marsAngle))), new PVector(marsV, 0, 0), marsMass, radiusScalar, marsR, marsTexture));
    bodies.add(new Body("Planet", "Jupiter", new PVector(0, jupiterR*sin(radians(jupiterAngle)), jupiterR*cos(radians(jupiterAngle))), new PVector(jupiterV, 0, 0), jupiterMass, radiusScalar, jupiterR, jupiterTexture));
    bodies.add(new Body("Planet", "Saturn", new PVector(0, saturnR*sin(radians(saturnAngle)), saturnR*cos(radians(saturnAngle))), new PVector(saturnV, 0, 0), saturnMass, radiusScalar, saturnR, saturnTexture));
    bodies.add(new Body("Planet", "Uranus", new PVector(0, uranusR*sin(radians(uranusAngle)), uranusR*cos(radians(uranusAngle))), new PVector(uranusV, 0, 0), uranusMass, radiusScalar, uranusR, uranusTexture));
    bodies.add(new Body("Planet", "Neptune", new PVector(0, neptuneR*sin(radians(neptuneAngle)), neptuneR*cos(radians(neptuneAngle))), new PVector(neptuneV, 0, 0), neptuneMass, radiusScalar, neptuneR, neptuneTexture));
    bodies.add(new Body("Comet", "Halley's Comet", new PVector(0, halleyR*sin(radians(halleyAngle)), halleyR*cos(radians(halleyAngle))), new PVector(halleyV, 0, 0), halleyMass, radiusScalar, halleyR, sunTexture));
    //bodies.add(new Body("Planet", "New Planet", new PVector(200*pow(10, 9), 100*pow(10,9), 100), new PVector(60000, 0, 0), 10, radiusScalar, 120*pow(10, 9), sunTexture));
    for (Body b : bodies) {
      planetListOptions.add(b.name);
    }
  }

  void exist() {
    for (int i = 0; i < timeScale; i++) {
      bodyExist();
    }
    display();
  }

  void display() {

    for (Body body : bodies) {
      noStroke();

      translate(body.display_position.x, body.display_position.y, body.display_position.z);
      body.textureSphere(body.radius);
      translate(-body.display_position.x, -body.display_position.y, -body.display_position.z);

      if (body.name=="Sun") {
        pointLight(255, 255, 255, body.display_position.x, body.display_position.y, body.display_position.z);
      }
    }
  }

  //needs some tweaking, planets can still slingshot each other out of the solar system sometimes, though it's very funny when that happens so we will fix this last
  void collision() {
    for (int i=0; i<bodies.size(); i++) {
      for (int j=0; j<bodies.size(); j++) {
        if (!bodies.get(i).equals(bodies.get(j))) {
          PVector body1 = bodies.get(i).position.copy();
          PVector body2 = bodies.get(j).position.copy();
          PVector difference = body1.sub(body2);
          if (difference.mag()<=collision_factor*(bodies.get(i).radius+bodies.get(j).radius)) {
            if (bodies.get(j).mass>=bodies.get(i).mass) {
              PVector momentum1=bodies.get(i).velocity.mult(bodies.get(i).mass);
              PVector momentum2=bodies.get(j).velocity.mult(bodies.get(j).mass);
              momentum2.add(momentum1);
              bodies.get(j).velocity=momentum2.div(bodies.get(j).mass);
              bodies.get(j).mass+=bodies.get(i).mass;
              bodies.remove(i);
            } else {
              PVector momentum1=bodies.get(j).velocity.mult(bodies.get(j).mass);
              PVector momentum2=bodies.get(i).velocity.mult(bodies.get(i).mass);
              momentum2.add(momentum1);
              bodies.get(i).velocity=momentum2.div(bodies.get(i).mass);
              bodies.get(i).mass+=bodies.get(j).mass;
              bodies.remove(j);
            }
          }
        }
      }
    }
  }

  PVector differential_function(ArrayList<PVector> input_positions, float[] input_masses, int i) {
    PVector output_acceleration=new PVector(0, 0, 0);
    for (int j=0; j<input_positions.size(); j++) {
      if (i!=j) {
        PVector difference = input_positions.get(j).copy().sub(input_positions.get(i).copy());
        float fmag = G*input_masses[i]*input_masses[j]/(difference.mag()*difference.mag());
        output_acceleration.add(difference.setMag(fmag/input_masses[i]));
      }
    }
    return output_acceleration;
  }

  PVector runge_kutta(ArrayList<PVector> input_positions, PVector input_velocity, float[] input_masses, int i) {

    PVector k1=differential_function(input_positions, input_masses, i);

    PVector variable_velocity = new PVector(0, 0, 0);
    ArrayList<PVector> variable_positions = input_positions;

    variable_velocity.set(input_velocity);
    variable_velocity.add(k1.copy().mult(delta_time/2));
    variable_positions.set(i, variable_positions.get(i).copy().add(variable_velocity));

    PVector k2=differential_function(variable_positions, input_masses, i);

    variable_positions = input_positions;
    variable_velocity.set(input_velocity);
    variable_velocity.add(k2.copy().mult(delta_time/2));
    variable_positions.set(i, variable_positions.get(i).copy().add(variable_velocity));

    PVector k3=differential_function(variable_positions, input_masses, i);

    variable_positions = input_positions;
    variable_velocity.set(input_velocity);
    variable_velocity.add(k3.copy().mult(delta_time));
    variable_positions.set(i, variable_positions.get(i).copy().add(variable_velocity));

    PVector k4=differential_function(variable_positions, input_masses, i);

    PVector output_acceleration = new PVector(0, 0, 0);

    output_acceleration.add(k1);
    output_acceleration.add(k2.mult(2));
    output_acceleration.add(k3.mult(2));
    output_acceleration.add(k4);
    output_acceleration.mult(1.0/6.0);

    return output_acceleration;
  }

  void bodyExist() {
    positions.clear();
    for (Body b : bodies) {
      positions.add(b.position);
      masses = append(masses, b.mass);
    }
    for (int i=0; i<bodies.size(); i++) {
      bodies.get(i).acceleration.set(runge_kutta(positions, bodies.get(i).velocity, masses, i));
      bodies.get(i).exist();
    }
  }
  
  void addBody(Body newBody){
    bodies.add(newBody);
  }
  
  
}