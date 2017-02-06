//
//  ViewController.swift
//  notificationstest
//
//  Created by Kyle Jessup on 2017-01-26.
//  Copyright © 2017 PerfectlySoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction
	func sendNotification(_ sender: AnyObject?) {
		_ = AppDelegate.myself?.sendNotification()
	}
}

