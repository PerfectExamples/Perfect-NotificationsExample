# Perfect Notifications Example

<p align="center">
    <a href="http://perfect.org/get-involved.html" target="_blank">
        <img src="http://perfect.org/assets/github/perfect_github_2_0_0.jpg" alt="Get Involed with Perfect!" width="854" />
    </a>
</p>

<p align="center">
    <a href="https://github.com/PerfectlySoft/Perfect" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg" alt="Star Perfect On Github" />
    </a>  
    <a href="http://stackoverflow.com/questions/tagged/perfect" target="_blank">
        <img src="http://www.perfect.org/github/perfect_gh_button_2_SO.jpg" alt="Stack Overflow" />
    </a>  
    <a href="https://twitter.com/perfectlysoft" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg" alt="Follow Perfect on Twitter" />
    </a>  
    <a href="http://perfect.ly" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg" alt="Join the Perfect Slack" />
    </a>
</p>

<p align="center">
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift 3.0">
    </a>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms OS X | Linux">
    </a>
    <a href="http://perfect.org/licensing.html" target="_blank">
        <img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
    </a>
    <a href="http://twitter.com/PerfectlySoft" target="_blank">
        <img src="https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat" alt="PerfectlySoft Twitter">
    </a>
    <a href="http://perfect.ly" target="_blank">
        <img src="http://perfect.ly/badge.svg" alt="Slack Status">
    </a>
</p>

## Perfect Notifications Example

This example shows how to use the [Perfect Notifications](https://github.com/PerfectlySoft/Perfect-Notifications) package to send remote notifications to an iOS device. The example consists of a simple iOS app and a Perfect HTTP server combination which illustrate the following concepts:

* Registering for notifications in iOS
* Sending obtained device id to the server
* Configuring the server to send notifications
* Creating an API endpoint to receive device ids
* Creating an API endpoint to trigger notifications to all known devices

## Compatibility with Swift

This project builds with **Xcode 8.2**. The server itself can be built on macOS or with the **Swift 3.0.2** toolchain on Ubuntu.

## Building & Running

Both the client and server project can be opened through the "NotificationsExample.xcworkspace" file. First, however, the server project must be generated.

In a terminal, cd to the location where you cloned this project and enter:

```
swift package generate-xcodeproj
```

This will generate the server project. Now open the "NotificationsExample.xcworkspace" Xcode workspace. This workspace contains both the client and the server projects. The client is named "NotificationsTestApp" and the server is "Perfect-NotificationsExample".

### Configuration

Before you can build and run either app you must obtain an "APNs Auth Key" from Apple as described here: [Obtain APNs Auth Key](https://github.com/PerfectlySoft/Perfect-Notifications/blob/master/README.md#obtain-apns-auth-key). Once you have your private key file, the key id, team id and your app id you can use these properties to configure the example.

It's important to note that APNs notifications do not work when running apps in the device simulator. You must run the app on a physical device.

You **must** configure the client project with the following:

1. Bundle Identifier
	* This id must be obtained through Apple's developer portal.
2. Team
	* You must select the team.
3. The IP address where the server is running.
	* You will find the place to enter this address in `AppDelegate.swift`.
	* This will generally be your local network Mac IP address. An address such as 127.0.0.1 or 0.0.0.0 will **not** work.

In the server project's `main.swift` file, you will need to enter your app id, team id, key id and the name of the private key file. By default the key files are named "APNSAuthKey_\(apnsKeyIdentifier).p8", where `apnsKeyIdentifier` is the key id value.

After configuring these values the server and client projects should each compile.

This example assumes that your "p8" private key file is located in your project directory. Use a full complete path to this file if it is located at any other path or if you do not want to set your Xcode debug working directory as described below.

### Running

Before running either app you should set the Xcode debug working directory to the location of your project. This allows the server to properly locate your "p8" private key file and any other files which are in the project directory. Ensure the server target is selected in the Xcode targets popup and press shift-cmd-comma. This will bring up the Xcode scheme editor. With the "Run" and "Options" tabs selected, click "Use custom working directory" and select the path to your project folder.

Switch the Xcode target to the iOS client app. Build and load the app onto your test iOS device. You shuld see a "Test Notification" button the the center view (you may also get an error message if you server is not yet running, which can be ignored).

Now switch back to the server target and click run in Xcode. This will launch the server in the debugger. You can view server output in the Xcode debugger output view.

## Testing Functionality

With the client iOS app properly configured and running in a physical device and the server configured and running on your Mac, press the iOS app's "Test Notifications" button. You should see your app register with the server and then trigger a notification. The notification should appear on the device and the server will output the responses from APNs.

For extra bonus points load the app on multiple devices and have them spam each other with notifications.

## Issues

We are transitioning to using JIRA for all bugs and support related issues, therefore the GitHub issues has been disabled.

If you find a mistake, bug, or any other helpful suggestion you'd like to make on the docs please head over to [http://jira.perfect.org:8080/servicedesk/customer/portal/1](http://jira.perfect.org:8080/servicedesk/customer/portal/1) and raise it.

A comprehensive list of open issues can be found at [http://jira.perfect.org:8080/projects/ISS/issues](http://jira.perfect.org:8080/projects/ISS/issues)



## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
