class Menu {

  float menux;
  float menuy;
  boolean slideIn;
  float slideSpeed;
  int counter;
  boolean slideOut;

  Solar_System_Info info;
  God_Console godConsole;

  Menu(ArrayList<Body> solarSystemBodies) {
    info = new Solar_System_Info(solarSystemBodies);
    godConsole = new God_Console();
    menux = -200;
    menuy = 0;
    slideIn = false;
    slideSpeed = 10;
    counter = 0;
  }


  void run() {
    noLights();
    fill(255, 60);
    rect(menux, menuy, 200, height);
    if (menux > 0) {
      menux = 0;
      slideIn = false;
      counter = 0;
      slideSpeed = 10;
      menuIsMoving = false;
    } else if (menux < -200) {
      menux = -200;
      slideOut = false;
      counter = 0;
      slideSpeed = 10;
      menuIsMoving = false;
    }



    //slide in from left
    if (slideIn && menux < 0) {
      for (Button b : menuButtons) {
        b.setX(menux);
      }
      for (Slider s : sliders) {
        s.setX(menux + 20);
      }
      for (DropdownMenu d : dropdownMenus) {
        d.setX(menux + 20);
        for(Button b : d.getListButtons()){
          b.setX(menux + 20);
        }
      }
      info.setX(menux + 15);
      menux += slideSpeed;
      if (counter >= 11-slideSpeed) {
        slideSpeed -= 1;
        counter = 0;
      }
      counter++;
    }



    if (slideOut || slideIn) {
      menuIsMoving = true;
    }

    //slide out to the left
    if (slideOut && menux > -200) {
      for (Button b : menuButtons) {

        b.setX(menux);
      }
      for (Slider s : sliders) {
        s.setX(menux + 20);
      }
      for (DropdownMenu d : dropdownMenus) {
        d.setX(menux + 20);
        for(Button b : d.getListButtons()){
          b.setX(menux + 20);
        }
      }
      info.setX(menux + 15);
      menux -= slideSpeed;
      if (counter >= 12-slideSpeed) {
        slideSpeed -= 1;
        counter = 0;
      }
      counter++;
    }


    switch(menuState) {
    case 0:
      //menu
      for (Button b : menuButtons) {
        if (b.name() == "menuSliders"
          || b.name() == "info") {
          b.exist();
        }

        //randomly gets pressed after clikcing back button in god console menu,
        // after changing a value for center of screen
        if (b.name() == "info" && b.isPressed()) {
          menuState = 2;
          b.done();
        }

        if (b.name() == "menuSliders" && b.isPressed()) {
          menuState = 1;
          b.done();
        }
      }
      break;
    case 1:
      //sliders
      fill(255);
      text("Earth orbits: " + earthOrbitCounter, 20 + menux, 240);
      godConsole.display();
      for (Button b : menuButtons) {
        if (b.name() == "backButton") {
          
          if (b.isPressed()) {
            menuState = 0;
            b.done();
          }
          b.exist();
        }
      }


      break;
    case 2:
      //info
      info.display();
      for (Button b : menuButtons) {
        if (b.name() == "backButton") {
          b.exist();
          if (b.isPressed()) {
            menuState = 0;
            b.done();
          }
        }
      }
      break;



    default: 
      println("You messed up");
    }
  }

  void setMenuState(int newState) {
    menuState = newState;
  }

  void slideIn() {
    slideIn = true;
  }

  void slideOut() {
    slideOut = true;
  }
}