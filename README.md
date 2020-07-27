# basket_app

This is simple flutter image upload project that you can select your images from your mobile phone 
and upload to a remote database. 

It allows you to select multiple images. 

When you open this application you can view your images which already uploaded to database.

<h3>Install Dependencies</h3>
  
```flutter pub get```
  
<h3>Run Tests</h3>

```flutter test```

<h3>Run</h3>
  
  If you have flutter installed in your computer. Open project then start simulator android or ios. 
  Then click to run.
  

<h3>Flutter install</h3>
  <h4>MacOS</h4>
   
   clone flutter git repository to your ~/ folder
  ```
   git clone https://github.com/flutter/flutter.git 
   ```
Then add your flutter binary to PATH add following lines to your .zshrc file:

```
export JAVA_HOME=/Library/Java/JavaVirtualMachines/-your java version-/Contents/Home
export ANDROID_HOME=~/Library/Android/sdk
export FLUTTER_BIN=~/flutter/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools/:$ANDROID_HOME/tools/:$ANDROID_HOME/tools/bin:$FLUTTER_BIN:$JAVA_HOME
```

Note: If you already have PATH variable defined in .zshrc instead of overriding it, just add export statements and add exported variables to end of PATH variable as shown above. 

Write below to terminal to check your flutter version

 ```flutter doctor -v```
 
 <h3>iOS setup</h3>
  
<h4>Install Xcode</h4>
  
To develop Flutter apps for iOS, you need a Mac with Xcode installed.

Install the latest stable version of Xcode (using <a href=https://developer.apple.com/xcode>web download</a> or <a href=https://itunes.apple.com/us/app/xcode/id497799835>the Mac App Store</a>).

<h3>Set up the iOS simulator</h3>
  
To prepare to run and test your Flutter app on the iOS simulator, follow these steps:

On your Mac, find the Simulator via Spotlight or by using the following command:

 ```open -a Simulator```

Make sure your simulator is using a 64-bit device (iPhone 5s or later) by checking the settings in the simulator’s Hardware > Device menu.
Depending on your development machine’s screen size, simulated high-screen-density iOS devices might overflow your screen. Set the device scale under the Window > Scale menu in the simulator.

<h3>Set up your Android device</h3>

To prepare to run and test your Flutter app on an Android device, you need an Android device running Android 4.1 (API level 16) or higher.

Enable Developer options and USB debugging on your device. Detailed instructions are available in the Android documentation.
Windows-only: Install the Google USB Driver.
Using a USB cable, plug your phone into your computer. If prompted on your device, authorize your computer to access your device.
In the terminal, run the flutter devices command to verify that Flutter recognizes your connected Android device. By default, Flutter uses the version of the Android SDK where your adb tool is based. If you want Flutter to use a different installation of the Android SDK, you must set the ANDROID_SDK_ROOT environment variable to that installation directory.

<h3>Set up the Android emulator</h3>

To prepare to run and test your Flutter app on the Android emulator, follow these steps:

Enable VM acceleration on your machine.
Launch Android Studio > Tools > Android > AVD Manager and select Create Virtual Device. (The Android submenu is only present when inside an Android project.)
Choose a device definition and select Next.
Select one or more system images for the Android versions you want to emulate, and select Next. An x86 or x86_64 image is recommended.
Under Emulated Performance, select Hardware - GLES 2.0 to enable hardware acceleration.
Verify the AVD configuration is correct, and select Finish.

For details on the above steps, see Managing AVDs.

In Android Virtual Device Manager, click Run in the toolbar. The emulator starts up and displays the default canvas for your selected OS version and device.

If you use IntelliJ IDEA install these plugins

Flutter, Dart, Android
