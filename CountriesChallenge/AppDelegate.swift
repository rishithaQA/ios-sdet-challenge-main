//
//  AppDelegate.swift
//  CountriesChallenge
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = createNavigationViewController()
        window!.makeKeyAndVisible()
        return true
    }

    private func createNavigationViewController() -> UINavigationController {
        return UINavigationController(rootViewController: CountriesViewController())
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return orientationLock
        }
}
