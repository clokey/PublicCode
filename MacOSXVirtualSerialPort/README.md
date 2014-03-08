#IMPORTANT NOTE

This software has not worked since Mac OS X 10.7. It relied upon an Interface Builder plugin and a mode of authentication that is no longer supported in newer versions of Mac OS X. The code has been moved here to create a longer term archive of my open source code. The original Google code project has been removed.

This application was always a wrapper around the socat command line tool. Therefore to achieve the same from the command line, download version 1.7.2 or newer of socat from [here](http://www.dest-unreach.org/)

    sudo socat -d -d -d -d -lf /tmp/socat pty,link=/dev/master,raw,echo=0,user=matt,group=staff pty,link=/dev/slave,raw,echo=0,user=matt,group=staff

Where /tmp/socat is the log file to write to, /dev/master and /dev/slave are the two ends of the virtual serial port pair and matt and staff are the user and group to use for the set up of either end of the pipe.


##Virtual Serial Port Pair on Mac OS X

Do you want to test your next Mac OS X-to-Arduino project without always having the Arduino available? Do you want to test you cool Processing application when your mate hasn't finished writing the Arduino sketch? Do you want to do test driven development of your Mac OS X based application without dependency on your microcontroller? If the answer to any of these questions is yes, then VirtualSerialPortApp is for you!

![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/CreatePair.png)


###Developing Serial apps on Mac OS X

_Note: device is synonymous with an Arduino, mbed, Propeller etc. & App is synonymous with a Processing Sketch, Mac OS X Cocoa application, Python script etc._

On Mac OS X when you connect an Arduino, mbed etc. to your machine via the USB cable, a device driver (the FTDI driver in the case of the Arduino) is loaded and creates an entry in the /dev directory that looks like a standard (old school?) serial port. What the device driver is doing is handling the complexity of the USB protocol and presenting a straight forward, and well understood, model to you the developer.

Inside of your code resident on the computer (be it a Processing sketch, Cococa application, Python etc.) you connect to the Arduino/mbed etc. like it was a straight forward serial port and use the simple communication model that this provides to interact both reading and writing data.

![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/VirtualSerialPortDocumentation.png)

###Creating more robust solutions

In the majority of cases people follow a simple approach when writing code that interacts between an App and a device:


  * Write a little code for the device
  * build and deploy to device
  * test that data is being sent and received
  * write a little code for the app
  * build and run the app on computer
  * connect to the device
  * test by interacting with the app
  * go back to step 1 and write the next bit of the app

In simple cases this approach works well but becomes annoying if:
  * The code for the device has bugs
  * The code for the device isn't finished
  * The app becomes complex
  * It becomes difficult to setup the conditions on the device to get a certain reaction from the app

VirtualSerialPortApp is a Mac OS X application that creates a virtual serial port pair that allows an app to be developed and tested without requiring the device to be connected.

VirtualSerialPortApp (using the socat utility) utilises Mac OS X's underlying BSD pseudo tty's to create a 'pair' of serial ports such that any data written to one will appear on the other and vice versa. Furthermore, once the pair has been created, one of the pair can be connected to and interacted with, both displaying data received and allowing you to write data back. Alternatively, any app that can interact over a serial port can be connected and used as a substitute for the device.
![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/VSP-socat.png)


#Features

###1. Creating a pair

When you launch VirtualSerialPortApp you have the option to name the two ends of the virtual serial port pair (both of which will reside in the system protected /dev directory). It is also possible to set the baud rate at which the pair will communicate.
![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/CreatePair.png)

Once you are happy with parameters select the Create Pair Button. You will then be prompted for your password, this is necessary as the /dev directory is a 'root' owned directory and to create the pair (e.g. write new files) it is necessary to invoke the underlying socat tool as root.

![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/SecurityPrompt.png)

Having created the pair, the interface changes such that you cannot amend the names of the two end points or change the baud rate. You can now either monitor one of the end points or break the pair.

*Whilst the underlying Pseudo TTY's are told to operate at the specified speed the actual transfer speed is currently ignored by the OS when data is communicated between the pair.*

###2. Monitoring a port

Having created a virtual serial port pair you have the ability to monitor one of the end points you have created. To open the monitor window click on the eye icon against the corresponding end point.

![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/MonitorMaster.png)

When you open the monitor window you are not actually connected to the end point (perhaps you want to send and receive some data prior to your interaction) and therefore you need to select Connect to be able to send and view data for that end point. When you select Connect (and a successful connection is made) the interface changes to allow data to be sent and for files to be opened.


###3. Sending data

Having made a connection to one of the end points any data received on the end point is displayed in output window. To send data, arbitrarily long text can be typed into the textfield and sent by selecting the Send button.

![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/MonitorConnectedSend.png)

Alternatively, and to avoid always having to re-type test data, you can open a file. Having selected a file, it is transmitted in its raw (byte) form to the paired end point.

![ScreenShot](https://raw.github.com/clokey/PublicCode/master/MacOSXVirtualSerialPort/Documentation/img/SendFile.png)

###4. Breaking a pair

When you have finished with your virtual serial port pair, you can break the pair and clean up the underlying /dev directory. To enable this, simple select the Break Pair button on the main window. You will be prompted for your password again (as with creating the pair, it is a privileged operation removing the underlying files).
