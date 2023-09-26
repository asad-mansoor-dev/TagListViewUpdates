//
//  AppDelegate.swift
//  TagsListViewComparison
//
//  Created by Dev on 9/26/23.
//

import UIKit

var kApplicationWindow = getAppDelegate()!.window
func getAppDelegate() -> AppDelegate? {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    return appDelegate
}
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let splashController = FilterViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [splashController]
        navigationController.navigationBar.isHidden = true
        kApplicationWindow = UIWindow(frame: UIScreen.main.bounds)
        kApplicationWindow?.rootViewController = navigationController
        kApplicationWindow?.makeKeyAndVisible()
        
        
        return true
    }

}

