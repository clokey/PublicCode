#Virtual Serial Port Pair on Mac OS X

Do you want to test your next Mac OS X-to-Arduino project without always having the Arduino available? Do you want to test you cool Processing application when your mate hasn't finished writing the Arduino sketch? Do you want to do test driven development of your Mac OS X based application without dependency on your microcontroller? If the answer to any of these questions is yes, then VirtualSerialPortApp is for you!

![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/CreatePair.png)


For the impatient, check out the *[http://code.google.com/p/macosxvirtualserialport/wiki/Features Features]* and see if it is right for you! - Current binary is built for Snow Leopard.

##Developing Serial apps on Mac OS X

_Note: device is synonymous with an Arduino, mbed, Propeller etc. & App is synonymous with a Processing Sketch, Mac OS X Cocoa application, Python script etc._

On Mac OS X when you connect an Arduino, mbed etc. to your machine via the USB cable, a device driver (the FTDI driver in the case of the Arduino) is loaded and creates an entry in the /dev directory that looks like a standard (old school?) serial port. What the device driver is doing is handling the complexity of the USB protocol and presenting a straight forward, and well understood, model to you the developer.

Inside of your code resident on the computer (be it a Processing sketch, Cococa application, Python etc.) you connect to the Arduino/mbed etc. like it was a straight forward serial port and use the simple communication model that this provides to interact both reading and writing data.

![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/VirtualSerialPortDocumentation.png)
http://macosxvirtualserialport.googlecode.com/files/VirtualSerialPortDocumentation.png

==Creating more robust solutions==

In the majority of cases people follow a simple approach when writing code that interacts between an App and a device:


  # Write a little code for the device
  # build and deploy to device
  # test that data is being sent and received
  # write a little code for the app
  # build and run the app on computer
  # connect to the device
  # test by interacting with the app
  # go back to step 1 and write the next bit of the app

In simple cases this approach works well but becomes annoying if:
  * The code for the device has bugs
  * The code for the device isn't finished
  * The app becomes complex
  * It becomes difficult to setup the conditions on the device to get a certain reaction from the app

VirtualSerialPortApp is a Mac OS X application that creates a virtual serial port pair that allows an app to be developed and tested without requiring the device to be connected. <p>
VirtualSerialPortApp (using the socat utility) utilises Mac OS X's underlying BSD pseudo tty's to create a 'pair' of serial ports such that any data written to one will appear on the other and vice versa. Furthermore, once the pair has been created, one of the pair can be connected to and interacted with, both displaying data received and allowing you to write data back. Alternatively, any app that can interact over a serial port can be connected and used as a substitute for the device.
![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/VSP-socat.png)
http://macosxvirtualserialport.googlecode.com/files/VSP-socat.png
