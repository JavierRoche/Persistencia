//
//  UserDefaultsProvider.swift
//  AppAvengers
//
//  Created by APPLE on 26/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

/// User Defaults permanece en el movil como parte del sandbox hasta la desinstalacion
class UserDefaultsProvider {
    private let keyUserView = "keyUserView"

    /// Para guardar un valor para una clave
    func save(screen: String) {
        UserDefaults.standard.set(screen, forKey: keyUserView)
    }
    
    /// Para recuperar un valor para una clave
    func load() -> String? {
        /// Podemos comprobar si la clave existe antes de intentar leerla
        if UserDefaults.standard.dictionaryRepresentation().keys.contains(keyUserView) {
            /// Si conocemos el valor esperado podemos usar el tipo despues de standard
            /// Nos ahorramos el casteo ya que .value devuelve Any
            print(UserDefaults.standard.dictionaryRepresentation().keys.debugDescription)
            return UserDefaults.standard.string(forKey: keyUserView)
            
        } else {
            print("La clave no existe")
            return String(describing: HeroesViewController.self)
        }
    }
}
