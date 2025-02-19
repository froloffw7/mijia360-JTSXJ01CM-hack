# Mijia 360 1080p (JTSXJ01CM) Camera Hack

This is an indirect fork of [niclet/xiaomi_hack](https://github.com/niclet/xiaomi_hack) (big thanks!) for the first-gen Mijia 360 1080p IP camera (JTSXJ01CM), with additional features, some probably inspired from different Mi/Yi camera hacks, just to get this to work properly:

* Enable/disable cloud (Mi Home)
* SSH support
* FTP support
* RTSP support and mjpeg video translation over http
* Night vision (on/off/auto)
* Custom TZ and NTP server

TODO:
* Access to the camera files over ssh(scp)
* Motor control
* Audio translation
* Motion detection. Only some simple function, as it is difficult to implement all futures supported by the camera hardware even having Ambarella SDK.

## Recommended firmware

The firmware I'm currently using has version **3.3.2_2016123014**,  JMacalinao uses **3.3.10_2017121915** which he has got with OTA upgrade via Mi Home years ago. I can only recommend firmwares less than or equal to that. You might be able to downgrade your firmware (if you have a Windows machine) by  getting an older firmware and the flashing tool.This haven't been tested.

## Installation

0. Set up the camera with the Mi Home app. Make sure the WiFi credentials are correct. (Thanks to @Peter71131, [#3](https://github.com/JMacalinao/mijia360-1g-hack/issues/3#issuecomment-734204079)).
1. Copy all files to your SD card.
2. Edit config.ini.
3. Insert SD card to the camera.
4. Plug in the camera.

## Usage

* FTP server
  * Port 21
  * Login: root, no password
* SSH server
  * Port 22
  * Login: root, Password: MCH_ROOT_PASSWORD value in config.ini
* Telnet server
  * Port 23
  * Login: root, Password: MCH_ROOT_PASSWORD value in config.ini
* RTSP server
  * Stream 1 (1080p): rtsp://{IP}/stream1
  * Stream 2 (360p): rtsp://{IP}/stream2
  * Session length is limited to 60 seconds

## LED indicator on startup (Disabled Cloud mode)

Solid yellow - It's turned on. Hope and pray that it doesn't get stuck in this mode.

Flashing green - Setting up the camera's network configuration and connecting to Wi-Fi.

Solid red - Wi-Fi connection failed. Maybe the config is wrong?

Flashing blue - Connected to Wi-Fi, setting up the rest of the services (e.g. NTP, RSTP, etc.)

Solid blue (or off, if you disabled it) - Startup complete.

## Stuck in solid yellow LED?

Before pushing the reset button or getting a recovery image, try the following first:

1. Remove the SD card.
2. Plug in the camera.
3. Wait for 30 seconds.
4. If the LED is still solid yellow, unplug the camera.
5. Do #3 and #4 five to six times.

## License

I'm kinda lazy to get into jargon, but basically, everything is provided as-is, and I am not liable if using this code bricks your device, causes a nuclear holocaust, or anything in between.
