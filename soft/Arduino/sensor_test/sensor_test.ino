

#include "dht11.h"
#include <Wire.h>
#include "LiquidCrystal.h"
#include "LPS331.h"
#include "LSM303.h"
#include "NewPing.h"

dht11 DHT11;
LPS331 ps;
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

#define DHT11PIN 22

LSM303 compass;
char report[80];

#define TRIGGER_PIN  30  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     31  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 200 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

void setup()
{
  Serial.begin(115200);
  lcd.begin(16, 2);
  Wire.begin();
  if (!ps.init())
  {
    Serial.println("Failed to autodetect pressure sensor!");
    lcd.print("Error: PS");
    while (1);
  }

  ps.enableDefault();
  compass.init();
  compass.enableDefault();
}

void loop()
{
  float pressure = ps.readPressureMillibars();
  float altitude = ps.pressureToAltitudeMeters(pressure);
  float temperature = ps.readTemperatureC();

  Serial.println("\n");

  int chk = DHT11.read(DHT11PIN);

//  Serial.print("Read sensor: ");
  switch (chk)
  {
    case DHTLIB_OK: 
		//Serial.println("OK"); 
		break;
    case DHTLIB_ERROR_CHECKSUM: 
		Serial.println("Checksum error"); 
		break;
    case DHTLIB_ERROR_TIMEOUT: 
		Serial.println("Time out error"); 
		break;
    default: 
		Serial.println("Unknown error"); 
		break;
  }

  Serial.print("H: ");
  Serial.print((float)DHT11.humidity, 1);
  Serial.print("% ");

  Serial.print("T: ");
  Serial.print((float)DHT11.temperature, 1);
  Serial.print("*C\r\n");

  Serial.print("p: ");
  Serial.print(pressure);
  Serial.print(" mbar\ta: ");

  compass.read();

  snprintf(report, sizeof(report), "A: %6d %6d %6d    M: %6d %6d %6d",
    compass.a.x, compass.a.y, compass.a.z,
    compass.m.x, compass.m.y, compass.m.z);
  Serial.println(report);

  unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
  Serial.print("Ping: ");
  Serial.print(uS / US_ROUNDTRIP_CM); // Convert ping time to distance in cm and print result (0 = outside set distance range)
  Serial.println("cm");

  lcd.clear();
  lcd.print("H: ");
  lcd.print(DHT11.humidity);
  lcd.print("% ");

  lcd.print("T: ");
  lcd.print(DHT11.temperature);
  lcd.print("*C");

  lcd.setCursor(0,1);
  lcd.print("p: ");
  lcd.print(pressure,0);
  lcd.print(" mbar");

  delay(300);
}


// dewPoint function NOAA
// reference (1) : http://wahiduddin.net/calc/density_algorithms.htm
// reference (2) : http://www.colorado.edu/geography/weather_station/Geog_site/about.htm
//
double dewPoint(double celsius, double humidity)
{
	// (1) Saturation Vapor Pressure = ESGG(T)
	double RATIO = 373.15 / (273.15 + celsius);
	double RHS = -7.90298 * (RATIO - 1);
	RHS += 5.02808 * log10(RATIO);
	RHS += -1.3816e-7 * (pow(10, (11.344 * (1 - 1/RATIO ))) - 1) ;
	RHS += 8.1328e-3 * (pow(10, (-3.49149 * (RATIO - 1))) - 1) ;
	RHS += log10(1013.246);

        // factor -3 is to adjust units - Vapor Pressure SVP * humidity
	double VP = pow(10, RHS - 3) * humidity;

        // (2) DEWPOINT = F(Vapor Pressure)
	double T = log(VP/0.61078);   // temp var
	return (241.88 * T) / (17.558 - T);
}


