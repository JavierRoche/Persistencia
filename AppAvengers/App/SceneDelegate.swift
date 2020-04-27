//
//  SceneDelegate.swift
//  AppAvengers
//
//  Created by APPLE on 23/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /// Acceso al User Defaults
        let userDefaultsScreen: UserDefaultsProvider = UserDefaultsProvider()
        let _: String? = userDefaultsScreen.load()
        
        /// Creamos ViewController para cada tab de la app
        let heroesViewController: HeroesViewController = HeroesViewController()
        let battlesViewController: BattlesViewController = BattlesViewController()
        let villainsViewController: VillainsViewController = VillainsViewController()
        
        /// Con la propiedad tabBarItem podemos fijar detalles de cada tab
        heroesViewController.tabBarItem = UITabBarItem.init(title: "Avengers", image: UIImage(named: "AvengersIcon"), tag: 0)
        battlesViewController.tabBarItem = UITabBarItem.init(title: "Battles", image: UIImage(named: "BattlesIcon"), tag: 0)
        villainsViewController.tabBarItem = UITabBarItem.init(title: "Villains", image: UIImage(named: "VillainsIcon"), tag: 0)
        
        /// Creamos los navigation para cada vista que queramos que tenga navegacion y titulo
        let heroesNavigationViewController: UINavigationController = UINavigationController.init(rootViewController: heroesViewController)
        let battlesNavigationViewController: UINavigationController = UINavigationController.init(rootViewController: battlesViewController)
        let villainsNavigationViewController: UINavigationController = UINavigationController.init(rootViewController: villainsViewController)
        
        /// Creamos la tabBar y la configuramos con los ViewController
        let tabBarController: UITabBarController = UITabBarController()
        tabBarController.viewControllers = [heroesNavigationViewController, battlesNavigationViewController, villainsNavigationViewController]
        tabBarController.tabBar.barStyle = .default
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = UIColor.init(red: 220/255.0, green: 146/255.0, blue: 40/255.0, alpha: 1.0)
        
        /// Al iniciarse la aplicacion, la ventana carga un controlador de vista en ella (rootViewController) que sera el tabBar
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        /// Instanciamos la ventana usando el inicializador frame que le damos mediante el CGRect de nuestra windowScene
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

