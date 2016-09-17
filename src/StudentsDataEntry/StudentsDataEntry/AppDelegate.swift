//
//  AppDelegate.swift
//  StudentsDataEntry
//
//  Created by Conker Group on 17/09/2016.
//  Copyright © 2016 Christopher Lord. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var dataSource : PersistentDataSource?;


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		do {
			// Connect to the main data source
			let model = "StudentsDataEntry";
			let url = self.persistentStoreURL();
			self.dataSource = try PersistentDataSource(url: url, modelName: model);
		} catch let error as NSError {
			#if DEBUG
				let path = self.persistentStoreURL().path;
				try! FileManager.default.removeItem(atPath: path);
			#endif
			
			// This indicates that the persistent source could not
			// be created/used for some reason. This is either bad 
			// management of model versions or a bad setup.
			print("Aborting. Error caught during database init: \(error.localizedDescription)");
			abort();
		}

		// Override point for customization after application launch.
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		//self.saveContext()
	}
	
	// MARK: - Path Helpers
	
	
	// @return URL pointing to the user document directory.
	public func persistentStoreURL() -> URL {
		// This is a generic apple-provided segment for getting the home directory
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[urls.count - 1].appendingPathComponent("data.sqlite");
	}
}

