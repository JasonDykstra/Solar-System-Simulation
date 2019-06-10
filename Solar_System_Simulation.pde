import peasy.PeasyCam;
PeasyCam camera;

float timeScale = 1;


int frequency = 1;
float speed = 1;
float acceleration = 0.3;
float scaleFactor;
float scaleStep;
float rotateX;
float rotateY;
String center;
float centerX;
float centerY;
float centerZ;
float delta_time=86400*1; //(seconds in 1 day) * (days)


int menuState = 0;
boolean menuOpen = false;
boolean menuIsMoving = false;

PImage sunTexture;
PImage mercuryTexture;
PImage venusTexture;
PImage earthTexture;
PImage marsTexture;
PImage jupiterTexture;
PImage saturnTexture;
PImage uranusTexture;
PImage neptuneTexture;


int earthOrbitCounter = 0;

PVector lastSunPos = new PVector(0, 0, 0);


boolean addPlanet = false;


Star star;
Solar_System solarSystem;
Menu menu;


ArrayList<Button> menuButtons = new ArrayList<Button>();
ArrayList<Slider> sliders = new ArrayList<Slider>();
ArrayList<DropdownMenu> dropdownMenus = new ArrayList<DropdownMenu>();
ArrayList<String> planetListOptions = new ArrayList<String>();


/*
 ~=+=+=+=+=+=+=+=~
 | ACTIVITY LOG: |
 ~=+=+=+=+=+=+=+=~
 
 We (sorta) did it! We got gravity to work with multiple bodies! 10:25:45, 12/21/17 - Evab & Jazin
 
 Added all EIGHT planets and got their relative positions, velocities, inclination angles, and sizes 3:21:52, 12/22/17 - Evab & Jazin
 
 Made program Dr. Pierce worthy 11:41:45, 1/17/18 - Evab & Jazin 
 
 Successfully integrated PeasyCam library into program to allow "looking at" an object without having to
 write a translate statement that would give you an aneurysm simply by looking at it 9:26:39, 1/24/18 - Jazin
 
 Realized we have been using -6.67 for G, not 6.67E-11 12:02:14, 2/6/18 - Jazin
 
 Help, current time - Evab & Jazin
 */

void setup() {
  size(1440, 855, P3D);
  smooth(8);
  camera = new PeasyCam(this, 400);
  //Zooming makes everything dissappear when closer than 75 units,
  //set the scalar to 0 for now so I can just use scaleFactor
  camera.setWheelScale(0);
  //Only allow pitch and yaw, no roll
  camera.setSuppressRollRotationMode();

  sunTexture = loadImage("sunTexture.jpg");
  mercuryTexture = loadImage("mercuryTexture.jpg");
  venusTexture = loadImage("venusTexture.jpg");
  earthTexture = loadImage("earthTexture.jpg");
  marsTexture = loadImage("marsTexture.jpg");
  jupiterTexture = loadImage("jupiterTexture.jpg");
  saturnTexture = loadImage("saturnTexture.jpg");
  uranusTexture = loadImage("uranusTexture.jpg");
  neptuneTexture = loadImage("neptuneTexture.jpg");


  star = new Star(frequency);  
  scaleFactor = 1.5;
  scaleStep = 0.1;
  rotateX = 0;
  rotateY = 0;
  center = "Sun";
  centerX = 0;
  centerY = 0;
  centerZ = 0;
  solarSystem = new Solar_System();
  menu = new Menu(solarSystem.bodies);


  //Menu buttons
  menuButtons.add(new Button("backButton", 0, 0, 200, 40, "< Back", 15, 2));
  menuButtons.add(new Button("menuSliders", -200, 200, 200, 40, "Sliders", 15, 2));
  menuButtons.add(new Button("info", -200, 400, 200, 40, "Information", 15, 2));


  //Sliders
  sliders.add(new Slider("Zoom", scaleFactor, 20, 100, 0.15, 10, 160));
  sliders.add(new Slider("Time", timeScale, 20, 200, 0.1, 20, 160));

  //listOptions declared in solar system class

  dropdownMenus.add(new DropdownMenu("Center of screen:", -200, 300, 160, 25, center, 2, planetListOptions));
}

void draw() {
  background(0);

  pushMatrix();
  for (Body body : solarSystem.bodies) {
    if (body.name == center) {
      camera.lookAt(body.display_position.x * scaleFactor, body.display_position.y * scaleFactor, body.display_position.z * scaleFactor, 0);
    }
  }
  scale(scaleFactor);
  star.star(speed);
  solarSystem.exist();
  popMatrix();

  //keep this in 2D
  camera.beginHUD();
  menu.run();
  camera.endHUD();
}

void mouseWheel(MouseEvent event) {
  if (scaleFactor + -event.getCount() * scaleStep >= 0.15
    && scaleFactor + -event.getCount() * scaleStep <= 10) {
    scaleFactor += -event.getCount() * scaleStep;
  }
}

void keyPressed() {

  if (key == 'o') {
    scaleFactor += scaleStep;
  } else if (key == 'p' && scaleFactor > scaleStep*2) {
    scaleFactor -= scaleStep;
  } else 
  if (key == 'm') {
    if (menuOpen == false && menuIsMoving == false) {
      menu.slideIn();
      menuOpen = true;
    } else if (menuOpen == true && menuIsMoving == false) {
      menu.slideOut();
      menuOpen = false;
    }
  }

  if (key=='w') {
    timeScale += 1;
  }

  if (key=='s') {
    if (timeScale >= 2) {
      timeScale -= 1;
    }
  }
}

void mouseDragged() {
  //set camera inactive when dragging in menu
  if (mouseX < 200 && menuOpen) {
    camera.setActive(false);
  } else {
    camera.setActive(true);
  }


  for (Button b : menuButtons) {
    if (!b.contains(mouseX, mouseY)) {
      b.clicked = false;
    } else if (b.contains(mouseX, mouseY) && mousePressed) {
      b.clicked = true;
    }
  }

  for (DropdownMenu d : dropdownMenus) {
    for (Button b : d.getListButtons()) {
      if (!b.contains(mouseX, mouseY)) {
        b.clicked = false;
      } else if (b.contains(mouseX, mouseY) && mousePressed) {
        b.clicked = true;
      }
    }
  }
}

void mousePressed() {
  for (Button b : menuButtons) {
    if (b.contains(mouseX, mouseY)) {
      b.wasClicked();
    }
  }

  for (Slider s : sliders) {
    if (menuState == 1) {
      s.check();
    }
  }

  for (DropdownMenu d : dropdownMenus) {
    if (d.contains(mouseX, mouseY)) {
      d.wasClicked();
    }

    for (Button b : d.getListButtons()) {
      if (b.contains(mouseX, mouseY)) {
        b.wasClicked();
      }
    }
  }
}

void mouseReleased() {
  for (Button b : menuButtons) {
    if (b.contains(mouseX, mouseY)) {
      b.wasClicked();
    }
  }

  for (Slider s : sliders) {
    if (menuState == 1) {
      s.setUndraggable();
    }
  }

  for (DropdownMenu d : dropdownMenus) {
    if (d.contains(mouseX, mouseY)) {
      d.wasClicked();
    }

    for (Button b : d.getListButtons()) {
      if (b.contains(mouseX, mouseY)) {
        b.wasClicked();
      }
    }
  }
}

void keyReleased() {
  if (key == 'y' && addPlanet == false) {
    solarSystem.addBody(new Body("Planet", "New Planet", new PVector(200*pow(10, 9), 100*pow(10, 9), 100), new PVector(60000, 0, 0), 10, solarSystem.radiusScalar, 120*pow(10, 9), sunTexture));
    //                          String type, String name,               PVector position,                    PVector velocity,   float mass, float radiusScalar,   float distance, PImage texture
  }
}