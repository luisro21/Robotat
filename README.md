# Proyecto de graduación - Diseño de un robot hexapod con servos inteligentes para su implementación dentro del ecosistema Robotat

Este proyecto consiste en la implementación de una plataforma robótica (hexapod) en el sistema de captura de movimiento de la Universidad del Valle de Guatemala.

Se utilizaron los siguientes archivos:

## Matlab

Cinematica_Hex.m - Simulación y envio de datos. (Main)

esp32_connect.m - Conexión a ESP32. (Conexión TCP)

## ArduinoIDE

JSON_Matlab_Robotat.ino - Conexión con Matlab, Robotat y envío de datos a OpenCm 9.04. (ESP32)

Opencm.ino - Conexión UART con ESP32 y ejecución de los datos a los servos Dynamixel. (OpenCm 9.04)

### `ArduinoJson.h`

Se utilizó para serializar y deserealizar los datos de los servos y enviarlos con una comunicación TCP.

### `WiFi.h`

Se utilizó para crear un servidor y cliente en ESP32, servidor para conexión con MATLAB y cliente para conexión con Robotat.

### `DynamixelWorkbench.h`

Se utilizó para el control de los servos Dynamixel AX-12A y XL-320 en el microcontrolador OpenCm 9.04.

## Autor

Luis Roberto Salazar - 17337
