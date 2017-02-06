//
//  AppDelegate.swift
//  notificationstest
//
//  Created by Kyle Jessup on 2017-01-26.
//	Copyright (C) 2017 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2017 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import UIKit
import UserNotifications

let host = <This is an intentional compilation error. Replace this with your server IP address.>
let port = 8181 // adjust the port if desired. it must match the server listen port.
let apiAdd = "/id/add/" // + deviceID
let apiList = "/id/list"
let apiNotify = "/id/notify"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	static var myself: AppDelegate?
	
	var window: UIWindow?
	var deviceToken: Data?
	var urlTask: URLSessionDataTask?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		AppDelegate.myself = self
		
		let center = UNUserNotificationCenter.current()
		// ask to send notifications
		// you should answer YES on the test devices
		center.requestAuthorization(options: [.alert, .sound, .badge]) {
			granted, error in
			print("Requested permission for notifications: \(granted)")
			UIApplication.shared.registerForRemoteNotifications()
			center.delegate = self
		}
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		self.deviceToken = deviceToken
		// send your device id to the server
		sendAddDevice {
		}
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
		completionHandler(.alert)
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
		completionHandler()
	}
	
	// call the server endpoint which registers this device by its unique id
	func sendAddDevice(completion: @escaping () -> ()) {
		guard let deviceToken = deviceToken else {
			return
		}
		let hex = deviceToken.hexString
		let urlString = "http://\(host):\(port)\(apiAdd)\(hex)"
		guard let url = URL(string: urlString) else {
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = nil
		urlTask = URLSession.shared.dataTask(with: request) {
			response, data, error in
			guard nil == error else {
				print("Error registering device id: \(error)")
				DispatchQueue.main.async {
					let alert = UIAlertController(title: "Error", message: "Error registering device id: \(error?.localizedDescription ?? "no msg")", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "Bye!", style: .default, handler: { _ in exit(-1) }))
					self.window?.rootViewController?.present(alert, animated: true)
				}
				return
			}
			completion()
		}
		urlTask?.resume()
	}
	
	// call the server endpoint to trigger test notifications
	// a notification will be sent to all registered devices
	func sendNotification() -> Bool {
		sendAddDevice { // add our device again just to be sure at least one device is registered
		  guard let url = URL(string: "http://\(host):\(port)\(apiNotify)") else {
			  return
		  }
		  var request = URLRequest(url: url)
		  request.httpMethod = "POST"
		  request.httpBody = nil
		  self.urlTask = URLSession.shared.dataTask(with: request) {
			  response, data, error in
			  guard nil == error else {
				  print("Error requesting notification: \(error)")
				  return
			  }
		  }
		  self.urlTask?.resume()
		}
		return true
	}
}

// utility
extension UInt8 {
	var hexString: String {
		var s = ""
		let b = self >> 4
		s.append(String(UnicodeScalar(b > 9 ? b - 10 + 65 : b + 48)))
		let b2 = self & 0x0F
		s.append(String(UnicodeScalar(b2 > 9 ? b2 - 10 + 65 : b2 + 48)))
		return s
	}
}


extension Data {
	var hexString: String {
		guard count > 0 else {
			return ""
		}
		let deviceIdLen = count
		let deviceIdBytes = self.withUnsafeBytes {
			ptr in
			return UnsafeBufferPointer<UInt8>(start: ptr, count: self.count)
		}
		var hexStr = ""
		for n in 0..<deviceIdLen {
			let b = deviceIdBytes[n]
			hexStr.append(b.hexString)
		}
		return hexStr
	}
}

