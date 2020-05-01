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
        
        /// Recuperamos de UserDefaults la vista en la que salio el user
        let userDefaults: UserDefaultsProvider = UserDefaultsProvider()
        let viewIndex: Int = userDefaults.loadUserView()
        /// Configuramos nuestra navegacion iniciando en la vista de ultima visita
        let tabBar: TabBarProvider = TabBarProvider.init(viewIndex: viewIndex)
        
        /// Le pondemos algo de diseño a la barra de navegacion
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 97/255.0, green: 122/255.0, blue: 176/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26)]
        
        /// Al iniciarse la aplicacion, la ventana carga un controlador de vista en ella (rootViewController) que sera el tabBar
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        /// Instanciamos la ventana usando el inicializador frame que le damos mediante el CGRect de nuestra windowScene
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBar.activeTab()
        window?.makeKeyAndVisible()
    }

    // MARK: Functions
    
    /// Acceso al User Defaults a recuperar la ultima vista visitada y la primera ejecucion
    func configureAppData() {
        let userDefaults: UserDefaultsProvider = UserDefaultsProvider()
        /// La 1ª vez que se ejecuta se cargan los personajes y se inicializa el contador de batalla
        if userDefaults.loadFirstRun() == true {  /// Cambiar a false para reiniciar la app/Parar/Dejar en true
            userDefaults.saveBattleNumber(number: 21)
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

