//
//  TabBarProvider.swift
//  AppAvengers
//
//  Created by APPLE on 01/05/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class TabBarProvider {
    private var activeView: UITabBarController = UITabBarController()

    convenience init(viewIndex: Int) {
        self.init()
        
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
        
        /// Configuramos el tabBar de arranque
        activeView.viewControllers = [heroesNavigationViewController, battlesNavigationViewController, villainsNavigationViewController]
        activeView.tabBar.barStyle = .default
        activeView.tabBar.isTranslucent = false
        activeView.selectedIndex = viewIndex
        activeView.tabBar.tintColor = UIColor.init(red: 97/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        activeView.tabBar.barTintColor = UIColor.init(red: 219/255.0, green: 228/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    func activeTab() -> UITabBarController {
        return activeView
    }
}
