/*
  6-8-10
  Aaron Weiss
  SparkFun Electronics
  
  Example GPS Parser based off of arduiniana.org TinyGPS examples.
  
  Parses NMEA sentences from an EM406 running at 4800bps into readable 
  values for latitude, longitude, elevation, date, time, course, and 
  speed. 
  
  For the SparkFun GPS Shield. Make sure the switch is set to DLINE.
  
  Once you get your longitude and latitude you can paste your 
  coordinates from the terminal window into Google Maps. Here is the 
  link for SparkFun's location.  
  http://maps.google.com/maps?q=40.06477,+-105.20997
  
  Uses the NewSoftSerial library for serial communication with your GPS, 
  so connect your GPS TX and RX pin to any digital pin on the Arduino, 
  just be sure to define which pins you are using on the Arduino to 
  communicate with the GPS module. 
*/ 

// In order for this sketch to work, you will need to download 
// NewSoftSerial and TinyGPS libraries from arduiniana.org and put them 
// into the hardware->libraries folder in your ardiuno directory.
// Here are the lines of code that point to those libraries.
#include <NewSoftSerial.h>
#include <TinyGPS.h>

// Define which pins you will use on the Arduino to communicate with your 
// GPS. In this case, the GPS module's TX pin will connect to the 
// Arduino's RXPIN which is pin 3.
#define RXPIN 3
#define TXPIN 2
//Set this value equal to the baud rate of your GPS
#define GPSBAUD 4800

// Create an instance of the TinyGPS object
TinyGPS gps;
// Initialize the NewSoftSerial library to the pins you defined above
NewSoftSerial uart_gps(RXPIN, TXPIN);

// This is where you declare prototypes for the functions that will be 
// using the TinyGPS library.
void getgps(TinyGPS &gps);

// In the setup function, you need to initialize two serial ports; the 
// standard hardware serial port (Serial()) to communicate with your 
// terminal program an another serial port (NewSoftSerial()) for your 
// GPS.
void setup()
{
  // This is the serial rate for your terminal program. It must be this 
  // fast because we need to print everything before a new sentence 
  // comes in. If you slow it down, the messages might not be valid and 
  // you will likely get checksum errors.
  Serial.begin(115200);
  //Sets baud rate of your GPS
  uart_gps.begin(GPSBAUD);
  
  Serial.println("");
  Serial.println("Kubrick!");
  Serial.println("       ...waiting for lock...           ");
  Serial.println("");
}

// This is the main loop of the code. All it does is check for data on 
// the RX pin of the ardiuno, makes sure the data is valid NMEA sentences, 
// then jumps to the getgps() function.
void loop()
{
  while(uart_gps.available())     // While there is data on the RX pin...
  {
      int c = uart_gps.read();    // load the data into a variable...
      if(gps.encode(c))      // if there is a new valid sentence...
      {
        getgps(gps);         // then grab the data.
      }
  }
}

// The getgps function will get and print the values we want.
void getgps(TinyGPS &gps)
{
  // To get all of the data into varialbes that you can use in your code, 
  // all you need to do is define variables and query the object for the 
  // data. To see the complete list of functions see keywords.txt file in 
  // the TinyGPS and NewSoftSerial libs.
  
  // Define the variables that will be used
  float latitude, longitude;
  // Then call this function
  gps.f_get_position(&latitude, &longitude);
  
  Serial.print(latitude, 5);
  Serial.print(",");
  Serial.print(longitude, 5);
  Serial.print(",");
  
  // Same goes for date and time
  int year;
  byte month, day, hour, minute, second, hundredths;
  gps.crack_datetime(&year,&month,&day,&hour,&minute,&second,&hundredths);

  unsigned long date, time;

  gps.get_datetime(&date, &time);
  
  // Print data and time
  Serial.print(year);
  Serial.print(month, DEC);
  Serial.print(day, DEC);
  Serial.print(",");
  Serial.print(time);
  Serial.print(",");

  Serial.print(gps.f_altitude());  
  Serial.print(",");
  Serial.print(gps.f_course()); 
  Serial.print(",");
  Serial.print(gps.f_speed_kmph());
  Serial.println();
  
  // Here you can print statistics on the sentences.
  unsigned long chars;
  unsigned short sentences, failed_checksum;
  gps.stats(&chars, &sentences, &failed_checksum);
  //Serial.print("Failed Checksums: ");Serial.print(failed_checksum);
  //Serial.println(); Serial.println();
}