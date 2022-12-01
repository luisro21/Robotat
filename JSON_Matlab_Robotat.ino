#include <ArduinoJson.h>
#include <WiFi.h>

const char* ssid = "Robotat";
const char* password = "iemtbmcit116";

//const char* ssid = "SALAZAR_EXT";
//const char* password = "maldonado21";

//MATLAB
String pos = ""; //Buffer de MATLAB

//Robotat
const char* host = "192.168.50.200";
const int port = 1883;

const char* op = "105";

String msg = "";
char c ;
String ban = "";
int t1 = 0;
int ti = 60;
int t2 = 180;

double x = 0.0000000000000000000;
double y = 0.0000000000000000000;
double z = 0.0000000000000000000;
double n = 0.0000000000000000000;
double ex = 0.0000000000000000000;
double ey = 0.0000000000000000000;
double ez = 0.0000000000000000000;

//MATLAB
WiFiServer server; // Declara el objeto del servidor
//Robotat
WiFiClient client2;

int mo1 = 512;
int mo2 = 512;
int mo3 = 512;
int mo4 = 512;
int mo5 = 512;
int mo6 = 512;
int mo7 = 512;
int mo8 = 512;
int mo9 = 512;
int mo10 = 512;
int mo11 = 512;
int mo12 = 512;
int mo13 = 512;
int mo14 = 512;
int mo15 = 512;
int mo16 = 512;
int mo17 = 512;
int mo18 = 512;

//MATLAB
StaticJsonDocument<400> doc;

//Robotat
StaticJsonDocument<512> doc2;

void setup() {
  // put your setup code here, to run once:
    Serial.begin(115200);
    Serial2.begin(115200);
    Serial.println();

    WiFi.mode(WIFI_STA);
    WiFi.setSleep(false); // Desactiva la suspensión de wifi en modo STA para mejorar la velocidad de respuesta
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }

    //MATLAB
    Serial.println("Connected");
    Serial.print("IP Address:");
    Serial.println(WiFi.localIP());
    server.begin(80); // El servidor comienza a escuchar el puerto número 80

    //Robotat
    Serial.print("Connecting to ");
    Serial.println("Optitrack");
    if (client2.connect(host, port)) {
      Serial.println("Connected");
      while ( client2.available() ) {
          client2.read();
      }
      client2.write("105");
    }
    else{
      Serial.println("Connection failed");
      return;
    }
}

void loop() {
  
  //MATLAB
  WiFiClient client = server.available(); // Intenta crear un objeto de cliente
  if (client) // Si el cliente actual está disponible
  {
      Serial.println("[Client connected]");
      client.print("Enviando...");
      String readBuff;
      while (client.connected()) // Si el cliente está conectado
      {
          if (client.available()) // Si hay datos legibles
          {
              char c = client.read(); // Leer un byte
                                      // También puede utilizar otros métodos como readLine ()
              readBuff += c;
              if(c == '}') // Retorno de carro recibido
              {
                  //client.print("Received: " + readBuff); // Enviar al cliente
                  client.print("Enviado");
                  pos = readBuff;
                  Serial.println("Received: " + readBuff); // Imprimir desde el puerto serie
                  ser();
                  readBuff = "";
                  break; //Fuera de la lupa
              }
          }
      }
      client.stop(); // Finalizar la conexión actual:
      Serial.println("[Client disconnected]");
  }

  //Robotat
  if ( client2.available() ) {
    client2.write("105");
    while (t1 < t2) {
      c = client2.read();
      msg = msg + c;
      t1 = t1 + 1;
      if (c == '}') {
        t1 = t2;
        }
        
     }
     Serial.println(msg);
     jsonParse();
     msg = "";
     t1 = 0;
  }

}

void ser() {
  DeserializationError err = deserializeJson(doc, pos);
  if (err == DeserializationError::Ok) 
    {
      // Print the values
      // (we must use as<T>() to resolve the ambiguity)
      mo1 = doc["m1"].as<int>();
      mo2 = doc["m2"].as<int>();
      mo3 = doc["m3"].as<int>();
      mo4 = doc["m4"].as<int>();
      mo5 = doc["m5"].as<int>();
      mo6 = doc["m6"].as<int>();
      mo7 = doc["m7"].as<int>();
      mo8 = doc["m8"].as<int>();
      mo9 = doc["m9"].as<int>();
      mo10 = doc["m10"].as<int>();
      mo11 = doc["m11"].as<int>();
      mo12 = doc["m12"].as<int>();
      mo13 = doc["m13"].as<int>();
      mo14 = doc["m14"].as<int>();
      mo15 = doc["m15"].as<int>();
      mo16 = doc["m16"].as<int>();
      mo17 = doc["m17"].as<int>();
      mo18 = doc["m18"].as<int>();
    } 
    else 
    {
      // Print error to the "debug" serial port
      Serial.print("deserializeJson() returned ");
      Serial.println(err.c_str());
    }

    // Send the JSON document over the "link" serial port
    serializeJson(doc, Serial2);
    
}

void jsonParse() {
  DeserializationError err = deserializeJson(doc2, msg);
  if (err == DeserializationError::Ok) {
    
      // Print the values
      // (we must use as<T>() to resolve the ambiguity)
      x = doc2["data"][0].as<double>();
      y = doc2["data"][1].as<double>();
      z = doc2["data"][2].as<double>();
      n = doc2["data"][3].as<double>();
      ex = doc2["data"][4].as<double>();
      ey = doc2["data"][5].as<double>();
      ez = doc2["data"][6].as<double>();
      
      Serial.print("x = ");
      Serial.print(x);
      Serial.print(", y = ");
      Serial.print(y);
      Serial.print(", z = ");
      Serial.print(z);
      Serial.print(", n = ");
      Serial.print(n);
      Serial.print(", ex = ");
      Serial.print(ex);
      Serial.print(", ey = ");
      Serial.print(ey);
      Serial.print(", ez = ");
      Serial.println(ez);
      
    } 
    else 
    {
      // Print error to the "debug" serial port
      Serial.print("deserializeJson() returned ");
      Serial.println(err.c_str());

    }
}
