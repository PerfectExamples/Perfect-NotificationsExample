//
//  main.swift
//  Perfect-NotificationsExample
//
//  Created by Kyle Jessup on 2017-02-01.
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

import PerfectNotifications
import PerfectHTTPServer
import PerfectHTTP

// This is the App id, the APNS topic and we use it as the NotificationPusher configuration key
let notificationsTestId = "your.app.id"

let apnsTeamIdentifier = "YOUR TEAM ID"
let apnsKeyIdentifier = "YOUR KEY ID"
let apnsPrivateKey = "APNSAuthKey_\(apnsKeyIdentifier).p8"

NotificationPusher.addConfigurationAPNS(name: notificationsTestId,
                                        production: false,
                                        keyId: apnsKeyIdentifier,
                                        teamId: apnsTeamIdentifier,
                                        privateKeyPath: apnsPrivateKey)

class NotificationsExample {
	var deviceIds = [String]()
	
	func receiveDeviceId(request: HTTPRequest, response: HTTPResponse) {
		guard let deviceId = request.urlVariables["deviceid"] else {
			response.status = .badRequest
			return response.completed()
		}
		print("Adding device id:\(deviceId)")
		if !deviceIds.contains(deviceId) {
			deviceIds.append(deviceId)
		}
		try? response.setBody(json: [:]).completed()
	}
	
	func listDeviceIds(request: HTTPRequest, response: HTTPResponse) {
		try? response.setBody(json: ["deviceIds":self.deviceIds]).completed()
	}
	
	func notifyDevices(request: HTTPRequest, response: HTTPResponse) {
		print("Sending notification to all devices: \(deviceIds)")
		NotificationPusher(apnsTopic: notificationsTestId)
			.pushAPNS(configurationName: notificationsTestId,
			          deviceTokens: deviceIds,
			          notificationItems: [
						.alertBody("Hello!"),
						.sound("default")]) {
			responses in
			print("\(responses)")
			response.completed()
		}
	}
}

var example = NotificationsExample()

let routes = [
	Route(method: .post, uri: "/id/add/{deviceid}", handler: example.receiveDeviceId),
	Route(method: .post, uri: "/id/notify", handler: example.notifyDevices),
	Route(method: .get, uri: "/id/list", handler: example.listDeviceIds)
]

do {
	// Launch the HTTP server
	try HTTPServer.launch(name: "localhost", port: 8181, routes: routes)
} catch {
	print("Unknown error thrown: \(error)")
}
