#include <Wire.h> //I2C Arduino Library

#define addr 0x1E //I2C Address for The HMC5883

void setup(){
  
  Serial.begin(19200);
  Wire.begin();
  
  
  Wire.beginTransmission(addr); //start talking
  Wire.write(0x02); // Set the Register
  Wire.write(0x00); // Tell the HMC5883 to Continuously Measure
  Wire.endTransmission();
}


void loop(){
  
  int x_raw,y_raw,z_raw; //triple axis data
  float dt = 0.1;
  //Tell the HMC what regist to begin writing data into
  Wire.beginTransmission(addr);
  Wire.write(0x03); //start with register 3.
  Wire.endTransmission();
  
 
 //Read the data.. 2 bytes for each axis.. 6 total bytes
  Wire.requestFrom(addr, 6);
  if(6<=Wire.available()){
    x_raw = Wire.read()<<8; //MSB  x 
    x_raw |= Wire.read(); //LSB  x
    z_raw = Wire.read()<<8; //MSB  z
    z_raw |= Wire.read(); //LSB z
    y_raw = Wire.read()<<8; //MSB y
    y_raw |= Wire.read(); //LSB y
  }
  
  float x = (float) x_raw * 45.0 / 128.0;
  float y = (float) y_raw * 45.0 / 128.0;
  float z = (float) z_raw * 45.0 / 128.0;

 // MAG
  // X mag
  if (x < -180)
  {
    x += 360;
  }
  else if (x > 180)
  {
    x -= 360;
  }
  // Y mag
  if (y < -180)
  {
    y += 360;
  }
  else if (y > 180)
  {
    y -= 360;
  }
  // Z mag
  if (z < -180)
  {
    z += 360;
  }
  else if (z > 180)
  {
    z -= 360;
  }
  
  // Show Values
  Serial.print(F("DEL:"));              //Delta T
  Serial.print(dt, 2);
  Serial.print(F("#MAG:"));
  Serial.print(x);
  Serial.print(F(","));
  Serial.print(y);
  Serial.print(F(","));
  Serial.print(z);
  Serial.println(F(""));
  
  delay(100);
}
