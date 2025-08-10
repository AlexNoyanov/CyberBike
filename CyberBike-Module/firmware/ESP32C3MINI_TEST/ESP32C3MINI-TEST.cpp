
#include <WiFi.h>
#include <WebServer.h>
#include <Preferences.h>

#define WIFI_SSID "YourNetwork"
#define WIFI_PASS "YourPassword"
#define SENSOR_PIN 2  // Pulse input
#define PULSES_PER_KM 486  // Adjust based on wheel size

volatile unsigned long lastPulseTime = 0;
float currentSpeed = 0;
Preferences prefs;
WebServer server(80);

// Exponential noise filter :cite[3]
float expFilter(float newVal, float lastVal, float weight = 20) {
  return (newVal * weight + lastVal * (100 - weight)) / 100;
}

void IRAM_ATTR pulseISR() {
  static unsigned long prevTime;
  prevTime = lastPulseTime;
  lastPulseTime = micros();
  if (prevTime > 0) {
    float pulsePeriod = (lastPulseTime - prevTime) / 1e6;
    float speedKmh = (3.6 * 100) / (PULSES_PER_KM * pulsePeriod); // Distance per pulse in km
    currentSpeed = expFilter(speedKmh, currentSpeed);
  }
}

void setup() {
  pinMode(SENSOR_PIN, INPUT);
  attachInterrupt(digitalPinToInterrupt(SENSOR_PIN), pulseISR, RISING);
  
  // Load saved odometer
  prefs.begin("bike-data");
  float totalKm = prefs.getFloat("odometer", 0);
  
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.status() != WL_CONNECTED) delay(250);
  
  server.on("/", []() {
    String html = R"(<html><body>
      <h1>Bike Telemetry</h1>
      <p>Speed: <span id="speed">0</span> km/h</p>
      <script>
        setInterval(() => fetch('/data').then(r => r.json())
          .then(d => document.getElementById('speed').innerText = d.speed), 500);
      </script></body></html>)";
    server.send(200, "text/html", html);
  });
  
  server.on("/data", []() {
    server.send(200, "application/json", "{\"speed\":" + String(currentSpeed, 1) + "}");
  });
  server.begin();
}

void loop() {
  server.handleClient();
  // Save odometer every 10 mins
  static unsigned long lastSave;
  if (millis() - lastSave > 600000) {
    prefs.putFloat("odometer", totalKm);
    lastSave = millis();
  }
}