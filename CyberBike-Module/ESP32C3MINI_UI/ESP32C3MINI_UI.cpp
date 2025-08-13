#include <WiFi.h>
#include <WebServer.h>
#include <WebSocketsServer.h>

// Wi-Fi credentials for the ESP32 access point
const char* ssid = "CyberBike";
const char* password = "12345678";

// Create instances
WebServer server(80);
WebSocketsServer webSocket = WebSocketsServer(81);

// Dashboard variables
int currentSpeed = 0;
String currentGear = "N";
bool speedIncreasing = true;
unsigned long lastSpeedUpdate = 0;
unsigned long lastGearUpdate = 0;

// HTML content for the UI
const char* htmlContent = R"rawliteral(
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CyberBike Dashboard</title>
  <style>
    body {
      background-color: #0a0a0a;
      color: #00b7ff;
      font-family: 'Orbitron', sans-serif;
      height: 100vh;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;
      position: relative;
    }
    
    .grid {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: 
        linear-gradient(rgba(0, 183, 255, 0.1) 1px, transparent 1px),
        linear-gradient(90deg, rgba(0, 183, 255, 0.1) 1px, transparent 1px);
      background-size: 40px 40px;
      z-index: 1;
      pointer-events: none;
    }
    
    .scanline {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 10px;
      background: linear-gradient(to bottom, rgba(0, 183, 255, 0.3), transparent);
      animation: scan 4s linear infinite;
      z-index: 2;
      pointer-events: none;
    }
    
    @keyframes scan {
      0% { top: -10px; }
      100% { top: 100%; }
    }
    
    .glow {
      position: absolute;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      background: radial-gradient(circle at center, rgba(0, 183, 255, 0.1), transparent 70%);
      z-index: 0;
      pointer-events: none;
    }
    
    .hud {
      display: flex;
      align-items: center;
      justify-content: space-between;
      width: 100%;
      max-width: 1000px;
      background: rgba(0, 0, 0, 0.85);
      border: 2px solid #00b7ff;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 0 20px rgba(0, 183, 255, 0.3);
      z-index: 10;
    }
    
    .speed {
      font-size: 100px;
      font-weight: bold;
      text-shadow: 0 0 15px rgba(0, 183, 255, 0.7);
    }
    
    .label {
      font-size: 24px;
      background: #3bffd7;
      color: black;
      padding: 4px 8px;
      border-radius: 4px;
      margin-top: 5px;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    
    .rpm-bars {
      display: flex;
      gap: 5px;
    }
    
    .bar {
      width: 10px;
      height: 60px;
      background: #ff3b3b;
      animation: pulse 1s infinite ease-in-out;
    }
    
    @keyframes pulse {
      0%, 100% { opacity: 0.4; }
      50% { opacity: 1; }
    }
    
    .fuel {
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    
    .fuel-bar {
      width: 20px;
      height: 40px;
      margin: 0 2px;
      background-color: #ff3b3b;
    }
    
    .rpm {
      rotate: 180deg;
    }
    
    .text-mode {
      font-size: 60px;
      font-weight: bold;
      color: #ff3b3b;
      text-align: center;
      animation: fadeBlink 3s infinite ease-in-out;
      text-transform: uppercase;
      letter-spacing: 2px;
    }
    
    @keyframes fadeBlink {
      0% { opacity: 1; }
      25% { opacity: 0.3; }
      50% { opacity: 0.8; }
      75% { opacity: 0.2; }
      100% { opacity: 1; }
    }
    
    .speed-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      min-width: 260px;
    }
    
    .gear {
      font-size: 100px;
      font-weight: bold;
      color: #ff3b3b;
      text-align: center;
      text-shadow: 0 0 15px rgba(255, 59, 59, 0.7);
    }
    
    .hidden {
      display: none;
    }
    
    .gear-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      min-width: 260px;
    }
    
    .status {
      position: absolute;
      top: 20px;
      left: 20px;
      background: rgba(0, 0, 0, 0.7);
      border: 1px solid #00b7ff;
      border-radius: 8px;
      padding: 10px 15px;
      font-size: 14px;
      z-index: 10;
    }
    
    @media (max-width: 768px) {
      .hud {
        flex-direction: column;
        gap: 30px;
      }
      
      .speed {
        font-size: 80px;
      }
      
      .gear {
        font-size: 80px;
      }
      
      .text-mode {
        font-size: 40px;
      }
    }
  </style>
  <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
</head>
<body>
  <div class="grid"></div>
  <div class="scanline"></div>
  <div class="glow"></div>
  
  <div class="status">Connected to ESP32 | CyberBike Dashboard</div>
  
  <div class="hud">
    <div class="speed-container">
      <span id="speed" class="speed">0</span>
      <span id="mphLabel" class="label">MPH</span>
    </div>

    <div class="rpm" id="rpmBlock">
      <div class="rpm-bars" id="rpmBars">
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
      </div>
    </div>

    <div class="text-mode hidden" id="textMode">ABSTENTION</div>

    <div class="fuel" id="fuelSection">
      <div id="fuelBars">
        <div class="fuel-bar"></div>
        <div class="fuel-bar"></div>
        <div class="fuel-bar"></div>
        <div class="fuel-bar"></div>
        <div class="fuel-bar"></div>
        <div class="fuel-bar"></div>
        <div class="fuel-bar"></div>
        <div class="fuel-bar"></div>
      </div>
      <span style="margin-top: 10px">FUEL</span>
    </div>

    <div class="gear-container" id="gearSection">
      <div id="gearNumber" class="gear">N</div>
      <span id="gearLabel" class="label">GEAR</span>
    </div>
  </div>
  
  <script>
    // Connect to WebSocket
    const socket = new WebSocket('ws://' + window.location.hostname + ':81/');
    
    socket.addEventListener('open', function (event) {
      console.log('WebSocket connection established');
    });
    
    socket.addEventListener('message', function (event) {
      const data = JSON.parse(event.data);
      
      if (data.speed !== undefined) {
        document.getElementById('speed').textContent = data.speed;
      }
      
      if (data.gear !== undefined) {
        document.getElementById('gearNumber').textContent = data.gear;
      }
    });
    
    // Handle connection errors
    socket.addEventListener('error', function (event) {
      console.error('WebSocket error:', event);
    });
    
    socket.addEventListener('close', function (event) {
      console.log('WebSocket connection closed');
      // Attempt to reconnect every 3 seconds
      setTimeout(function() {
        location.reload();
      }, 3000);
    });
  </script>
</body>
</html>
)rawliteral";

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
  switch(type) {
    case WStype_DISCONNECTED:
      Serial.printf("[%u] Disconnected!\n", num);
      break;
    case WStype_CONNECTED:
      {
        IPAddress ip = webSocket.remoteIP(num);
        Serial.printf("[%u] Connected from %d.%d.%d.%d\n", num, ip[0], ip[1], ip[2], ip[3]);
      }
      break;
    case WStype_TEXT:
      // Handle incoming messages if needed
      break;
  }
}

void handleRoot() {
  server.send(200, "text/html", htmlContent);
}

void setup() {
  Serial.begin(115200);
  
  // Set up Wi-Fi access point
  WiFi.softAP(ssid, password);
  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);

  // Start web server
  server.on("/", handleRoot);
  server.begin();

  // Start WebSocket server
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
}

void loop() {
  server.handleClient();
  webSocket.loop();
  
  unsigned long currentMillis = millis();
  
  // Update speed every 500ms
  if (currentMillis - lastSpeedUpdate >= 500) {
    lastSpeedUpdate = currentMillis;
    
    if (speedIncreasing) {
      currentSpeed++;
      if (currentSpeed >= 120) {
        speedIncreasing = false;
      }
    } else {
      currentSpeed--;
      if (currentSpeed <= 0) {
        speedIncreasing = true;
      }
    }
    
    // Create JSON data for speed
    String speedData = "{\"speed\":" + String(currentSpeed) + "}";
    webSocket.broadcastTXT(speedData);
  }
  
  // Update gear every 2 seconds
  if (currentMillis - lastGearUpdate >= 2000) {
    lastGearUpdate = currentMillis;
    
    if (currentGear == "N") {
      currentGear = "1";
    } else if (currentGear == "1") {
      currentGear = "2";
    } else if (currentGear == "2") {
      currentGear = "3";
    } else if (currentGear == "3") {
      currentGear = "4";
    } else if (currentGear == "4") {
      currentGear = "5";
    } else {
      currentGear = "N";
    }
    
    // Create JSON data for gear
    String gearData = "{\"gear\":\"" + currentGear + "\"}";
    webSocket.broadcastTXT(gearData);
  }
}