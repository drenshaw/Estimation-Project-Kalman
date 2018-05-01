/**
 * Show GY521 Data.
 * 
 * Reads the serial port to get x- and y- axis rotational data from an accelerometer,
 * a gyroscope, and complementary-filtered combination of the two, and displays the
 * orientation data as it applies to three different colored rectangles.
 * It gives the z-orientation data as given by the gyroscope, but since the accelerometer
 * can't provide z-orientation, we don't use this data.
 * 
 */
 
import processing.serial.*;

Serial  myPort;
short   portIndex = 1;
int     lf = 10;       //ASCII linefeed
String  inString;      //String for testing serial communication
int     calibrating;
 
float   dt;
float   x_gyr;  //Gyroscope data
float   y_gyr;
float   z_gyr;
float   x_acc;  //Accelerometer data
float   y_acc;
float   z_acc;
float   x_fil;  //Filtered data
float   y_fil;
float   z_fil;
float   x_kal;  // Kalman Filter data
float   y_kal;
float   z_kal;
float   x_mag;  // Magnetometer data
float   y_mag;
float   z_mag;
int     c_tim;
int     k_tim;
int     del_t;

 
void setup()  { 
//  size(640, 360, P3D); 
  size(1400, 800, P3D);
  noStroke();
  colorMode(RGB, 256); 
 
//  println("in setup");
  //String portName = Serial.list()[portIndex];
  String portName = ("COM3");
//  println(Serial.list());
//  println(" Connecting to -> " + Serial.list()[portIndex]);
  myPort = new Serial(this, portName, 19200);
  myPort.clear();
  myPort.bufferUntil(lf);
} 

void draw_rect_rainbow() {
  scale(90);
  beginShape(QUADS);

  fill(0, 1, 0); vertex(-1,  1.5,  0.25);
  fill(1, 1, 1); vertex( 1,  1.5,  0.25);
  fill(1, 0, 1); vertex( 1, -1.5,  0.25);
  fill(0, 0, 1); vertex(-1, -1.5,  0.25);

  fill(1, 1, 1); vertex( 1,  1.5,  0.25);
  fill(1, 1, 0); vertex( 1,  1.5, -0.25);
  fill(1, 0, 0); vertex( 1, -1.5, -0.25);
  fill(1, 0, 1); vertex( 1, -1.5,  0.25);

  fill(1, 1, 0); vertex( 1,  1.5, -0.25);
  fill(0, 1, 0); vertex(-1,  1.5, -0.25);
  fill(0, 0, 0); vertex(-1, -1.5, -0.25);
  fill(1, 0, 0); vertex( 1, -1.5, -0.25);

  fill(0, 1, 0); vertex(-1,  1.5, -0.25);
  fill(0, 1, 1); vertex(-1,  1.5,  0.25);
  fill(0, 0, 1); vertex(-1, -1.5,  0.25);
  fill(0, 0, 0); vertex(-1, -1.5, -0.25);

  fill(0, 1, 0); vertex(-1,  1.5, -0.25);
  fill(1, 1, 0); vertex( 1,  1.5, -0.25);
  fill(1, 1, 1); vertex( 1,  1.5,  0.25);
  fill(0, 1, 1); vertex(-1,  1.5,  0.25);

  fill(0, 0, 0); vertex(-1, -1.5, -0.25);
  fill(1, 0, 0); vertex( 1, -1.5, -0.25);
  fill(1, 0, 1); vertex( 1, -1.5,  0.25);
  fill(0, 0, 1); vertex(-1, -1.5,  0.25);

  endShape();
  
  
}

void draw_rect(int r, int g, int b) {
  scale(90);
  beginShape(QUADS);
  
  fill(r, g, b);
  vertex(-1,  1.5,  0.25);
  vertex( 1,  1.5,  0.25);
  vertex( 1, -1.5,  0.25);
  vertex(-1, -1.5,  0.25);

  vertex( 1,  1.5,  0.25);
  vertex( 1,  1.5, -0.25);
  vertex( 1, -1.5, -0.25);
  vertex( 1, -1.5,  0.25);

  vertex( 1,  1.5, -0.25);
  vertex(-1,  1.5, -0.25);
  vertex(-1, -1.5, -0.25);
  vertex( 1, -1.5, -0.25);

  vertex(-1,  1.5, -0.25);
  vertex(-1,  1.5,  0.25);
  vertex(-1, -1.5,  0.25);
  vertex(-1, -1.5, -0.25);

  vertex(-1,  1.5, -0.25);
  vertex( 1,  1.5, -0.25);
  vertex( 1,  1.5,  0.25);
  vertex(-1,  1.5,  0.25);

  vertex(-1, -1.5, -0.25);
  vertex( 1, -1.5, -0.25);
  vertex( 1, -1.5,  0.25);
  vertex(-1, -1.5,  0.25);

  endShape();
  
  
}

void draw()  { 
  
  background(50);
  lights();
    
  // Tweak the view of the rectangles
  //int distance = 50;
  int x_rotation = 90;
  
  //Show gyro data
  pushMatrix(); 
  translate(1*width/8, height/2, -50); 
  rotateX(radians(-x_gyr - x_rotation));
  rotateY(radians(-y_gyr));
  //rotateZ(radians(z_gyr));
  draw_rect(249, 250, 50);
  popMatrix(); 

  //Show accel data
  pushMatrix();
  translate(3*width/8, height/2, -50);
  rotateX(radians(-x_acc - x_rotation));
  rotateY(radians(-y_acc));
  draw_rect(56, 140, 206);
  popMatrix();  
  
  //Show magnetometer data
  pushMatrix(); 
  translate(5*width/8, height/2, -50); 
  rotateX(radians((-x_mag - x_rotation)));
  rotateY(radians(-y_mag/2));
  //rotateZ(radians(z_mag/2));
  draw_rect(125, 125, 125);
  popMatrix(); 
  
  //Show complementary filter data
  pushMatrix();
  translate(7*width/8, height/2, -50);
  rotateX(radians(-x_fil - x_rotation));
  rotateY(radians(-y_fil));
  //rotateZ(radians(z_fil));
  draw_rect(93, 175, 83);
  popMatrix();
    
  //Show Kalman filter data
  pushMatrix();
  translate(7*width/8, height/2, -50);
  rotateX(radians(-x_kal - x_rotation));
  rotateY(radians(-y_kal));
  //rotateZ(radians(z_kal));
  draw_rect(255, 0, 0);
  popMatrix();
 
  textSize(24);
  String accStr = "(" + (int) x_acc + ", " + (int) y_acc + ")";
  String gyrStr = "(" + (int) x_gyr + ", " + (int) y_gyr + ", " + (int) z_gyr + ")";
  String magStr = "(" + (int) x_mag + ", " + (int) y_mag + ", " + (int) z_mag + ")";
  String filStr = "(" + (int) x_fil + ", " + (int) y_fil + ", " + (int) z_fil + ")";
  String kalStr = "(" + (int) x_kal + ", " + (int) y_kal + ", " + (int) z_fil + ")";
  //String timStr = "(" + (int) c_tim + ", " + (int) k_tim + ", " + (int) (k_tim/(c_tim+1)) + ")";


  fill(249, 250, 50);
  text("Gyroscope", (int) (1.0*width/8.0) - 60, 25);
  text(gyrStr, (int) (1.0*width/8.0) - 40, 50);

  fill(56, 140, 206);
  text("Accelerometer", (int) (3.0*width/8.0) - 50, 25);
  text(accStr, (int) (3.0*width/8.0) - 30, 50); 
  
  fill(125, 125, 125);
  text("Magnetometer", (int) (5.0*width/8.0) - 50, 25);
  text(magStr, (int) (5.0*width/8.0) - 30, 50); 
  
  fill(83, 175, 93);
  text("Complementary", (int) (7.0*width/8.0) - 40, 25);
  text(filStr, (int) (7.0*width/8.0) - 20, 50);
  
  fill(255, 0, 0);
  text("Kalman", (int) (7.0*width/8.0) - 40, 100);
  text(kalStr, (int) (7.0*width/8.0) - 20, 125);

  //fill(127, 0, 127);
  //text("Timing", (int) (7.0*width/8.0) - 40, 150);
  //text(timStr, (int) (7.0*width/8.0) - 20, 175);
  
} 

void serialEvent(Serial p) {

  inString = (myPort.readString());
  
  try {
    // Parse the data
    String[] dataStrings = split(inString, '#');
    for (int i = 0; i < dataStrings.length; i++) {
      String type = dataStrings[i].substring(0, 4);
      String dataval = dataStrings[i].substring(4);
    if (type.equals("DEL:")) {
        dt = float(dataval);
        /*
        print("Dt:");
        println(dt);
        */
        
      } else if (type.equals("ACC:")) {
        String data[] = split(dataval, ',');
        x_acc = float(data[0]);
        y_acc = float(data[1]);
        z_acc = float(data[2]);
        /*
        print("Acc:");
        print(x_acc);
        print(",");
        print(y_acc);
        print(",");
        println(z_acc);
        */
      } else if (type.equals("GYR:")) {
        String data[] = split(dataval, ',');
        x_gyr = float(data[0]);
        y_gyr = float(data[1]);
        z_gyr = float(data[2]);
      } else if (type.equals("MAG:")) {
        String data[] = split(dataval, ',');
        x_mag = float(data[0]);
        y_mag = float(data[1]);
        z_mag = float(data[2]);
      } else if (type.equals("FIL:")) {
        String data[] = split(dataval, ',');
        x_fil = float(data[0]);
        y_fil = float(data[1]);
        z_fil = float(data[2]);
      } else if (type.equals("KAL:")) {
        String data[] = split(dataval, ',');
        x_kal = float(data[0]);
        y_kal = float(data[1]);
        z_kal = float(data[2]);
      //} else if (type.equals("TIM:")) {
      //  String data[] = split(dataval, ',');
      //  c_tim = int(data[0]);
      //  k_tim = int(data[1]);
      //  del_t = int(data[2]);
      }
    }
  } catch (Exception e) {
      println("Caught Exception");
  }
}
