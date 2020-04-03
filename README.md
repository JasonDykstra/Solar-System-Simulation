# Solar-System-Simulation
A sandbox simulator of our Solar System.

My largest project as of the beginning of 2018. I worked on this program with a friend over the course of multiple months and used 4th order Runge-kutta method to simulate our solar system relatively accurately. We made everything from scratch except for the camera library (we used PEasycam) and the star and planet textures. 

The biggest challenge my friend and I faced when creating this program was that we wanted to be able to speed up the simulation to virtually any speed we wanted, but using Euler's method of calculating position based on a single derivative prediction simply wasn't accurate enough. To solve this problem, we went on Khan Academy and watched a lot of 3Blue1Brown videos to teach ourselves enough linear algebra to understand diffrential equations and 4th order Runge-kutta method. Implementing this method from scratch took some time since we had to create a pseudo-diffrential equation using the planets' velocity vectors as a field, but eventually we got it working.
