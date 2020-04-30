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
        
        /// Acceso al User Defaults a configurar el primer acceso
        configureAppData()
        
        /// Creamos ViewController para cada tab de la app
        let heroesViewController: HeroesViewController = HeroesViewController()
        let battlesViewController: BattlesViewController = BattlesViewController()
        let villainsViewController: VillainsViewController = VillainsViewController()
        
        /// Con la propiedad tabBarItem podemos fijar detalles de cada tab
        heroesViewController.tabBarItem = UITabBarItem.init(title: "Avengers", image: UIImage(named: "AvengersIcon"), tag: 0)
        battlesViewController.tabBarItem = UITabBarItem.init(title: "Battles", image: UIImage(named: "BattlesIcon"), tag: 1)
        villainsViewController.tabBarItem = UITabBarItem.init(title: "Villains", image: UIImage(named: "VillainsIcon"), tag: 2)
        
        /// Creamos los navigation para cada vista que queramos que tenga navegacion y titulo
        let heroesNavigationViewController: UINavigationController = UINavigationController.init(rootViewController: heroesViewController)
        let battlesNavigationViewController: UINavigationController = UINavigationController.init(rootViewController: battlesViewController)
        let villainsNavigationViewController: UINavigationController = UINavigationController.init(rootViewController: villainsViewController)
        
        /// Creamos la tabBar y la configuramos con los ViewController
        let tabBarController: UITabBarController = UITabBarController()
        tabBarController.viewControllers = [heroesNavigationViewController, battlesNavigationViewController, villainsNavigationViewController]
        tabBarController.tabBar.barStyle = .default
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = UIColor.init(red: 62/255.0, green: 104/255.0, blue: 243/255.0, alpha: 1.0)
        tabBarController.tabBar.barTintColor = UIColor.init(red: 219/255.0, green: 228/255.0, blue: 255/255.0, alpha: 1.0)
        
        /// Le pondemos algo de diseño a la barra de navegacion
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 137/255.0, green: 159/255.0, blue: 243/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26)]
        
        /// Al iniciarse la aplicacion, la ventana carga un controlador de vista en ella (rootViewController) que sera el tabBar
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        /// Instanciamos la ventana usando el inicializador frame que le damos mediante el CGRect de nuestra windowScene
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    // MARK: Functions
    
    /// Acceso al User Defaults a recuperar la ultima vista visitada y la primera ejecucion
    func configureAppData() {
        let userDefaults: UserDefaultsProvider = UserDefaultsProvider()
        let _: String? = userDefaults.loadUserView()
        
        /// La 1ª vez que se ejecuta se cargan los personajes y se inicializa el contador de batalla
        if userDefaults.loadFirstRun() == true {
            userDefaults.saveBattleNumber(number: 1)
            userDefaults.saveFirstRun(firstRun: false)
            /// Initial Data Migration
            initialDataMigration()
        }
    }
    
    func initialDataMigration() {
        /// El DataProvider para acceder a la clase que abstrae de la BBDD
        let dataProvider: DataProvider = DataProvider()
        dataProvider.runDeleteMigration()
        dataProvider.runDataMigration()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

