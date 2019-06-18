//
//  AppDelegate.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let movieService = MovieService()
        let viewModel = MovieViewModel(movies: [], movieService: movieService)
        let vc = MovieVC(viewModel: viewModel, query: "Avenger")
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.barTintColor = .black
        navController.navigationBar.barStyle = .black

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navController
        
        return true
    }
    

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIInterfaceOrientationMask.all
        }
        return [.portrait, .portraitUpsideDown]
    }
    
}

