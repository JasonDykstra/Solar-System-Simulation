class God_Console {
  boolean runOnce = false;

  God_Console() {
  }

  void display() {
    textSize(20);
    fill(255);
    
    for (Slider s : sliders) {


      if (s.name == "Zoom") {

        //only do this if the slider is being updated
        if (s.updating == true) {
          scaleFactor = s.sliderValue;
        } else if (s.updating == false) {
          s.setValue(scaleFactor);
        }
      }

      if (s.name == "Time") {
        if (s.updating == true) {
          timeScale = s.sliderValue;
        } else if (s.updating == false) {
          s.setValue(timeScale);
        }
      }

      s.update();
      s.display();
    }




    for (Button b : menuButtons) {
      if (b.name() == "backButton") {
        b.exist();
      }
    }

    for (DropdownMenu d : dropdownMenus) {
      d.exist();
      center = d.title;
    }
  }
}