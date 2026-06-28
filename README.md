# LED-Controller-Project
Application (coded in Flutter) and ESP32 code (for PlatformIO) to control an LED strip.

Hardware needed : An ESP32, an LED strip, 3 cables.
Software needed : VSCode with Platformio and Flutter extensions (for Flutter, refer to the Flutter's official website, it is well explained).

ESP32's code use : Receives a string with the following forms : 
  - "OFF" : Turns off the LED strip.
  - "RAINBOW" : Lights the LED strip into a rainbow.
  - "Delay,ARAINBOW" : Lights the LED strip into a moving rainbow, with a certain delay (the shorter the delay, the faster it moves).
  - "R,G,B" : Lights the LED strip at the chosen color.
  - "LED_number,R,G,B" : Lights the LED chosen at the chosen color.
  - "LED1-LED2,R,G,B" : Lights from LED1 to LED2 at the chosen color.
  - "LED1;LED2-LED3;...,R,G,B" Lights LED1 and LED2 to LED3 and ... at the chosen color.

Application use :
  - Music : Plays four songs on repeat. The controllers are at the bottom.
    ° Left button : short press = next; long press = previous.
    ° Right button : pause / play;
    
    ° Music continues playing until the app is closed.
    ° Songs are still to be defined.
    
  - Home Page : Scanning starts when the "Scan" button at the bottom is selected. Only connects to "LED Controller" (the ESP32). Then, it leads automatically to the first page (the detection require being fairly close to the ESP32).
  
  - First Page : You can switch between pages by swiping left or right.
    ° "Home" button : Disconnects from the ESP32 and leads to the Home page. At the bottom of the page. When disconnected, automatically sends "OFF".
    ° The color circle : Shows the last color sent to the LED strip. When pressed, sends "OFF".
    ° The first six buttons : Send the corresponding command, such as "255,0,0", "0,255,0", "0,0,255".
    ° "Rainbow Light" button : Sends "RAINBOW". The circle shows a rainbow icon.
    ° "Animated Rainbow" button : Short press = Sends "50,ARAINBOW"; long press = lets you write the delay you want, then sends "Delay,ARAINBOW". The circle shows a star icon.

  - Second Page :
      ° LED Matrix : Shows which LED is at which color. If "Rainbow Light" or "Animated Rainbow" button was last selected on the last page, every button will show the same color as the Color circle of page 1. When pressed, adds the LED number to the list (defined in the next bullet). When pressed twice, removes the LED from the list.
      ° "Enter LED" Text Field : Allows you to write the LEDs chosen with the formats "LED_number", "LED1-LED2" or "LED1;LED2-LED3;...". You can write after the pre-selection made if you already pressed on the LED matrix. If the list ends with a ";", it will be ignored.
         N.B.: If "Animated Rainbow" was last selected in page 1 and you send a command, the LED strip will stop at the last color it was displaying. The untouched LEDs will keep their color and their corresponding LED in the matrix will keep its color and icon, until the LEDs are modified.
      ° "Enter Color" Text Field : Allows you to choose an R,G,B color. When pressed, a pre-selected list will be enabled to save time (corresponding to the 6 buttons of the first page).
         N.B.: To send the command, both text fields need to be validated with the Enter key on the phone's keyboard. That will clear the "Enter LED" text field. When a color is chosen from the list, it is automatically validated.
      ° "OFF" button : Sends "OFF".
