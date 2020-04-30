//
//  UserDefaultsProvider.swift
//  AppAvengers
//
//  Created by APPLE on 26/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

/// User Defaults permanece en el movil como parte del sandbox hasta la desinstalacion
class UserDefaultsProvider {
    private let keyFirstRun = "keyFirstRun"
    private let keyUserView = "keyUserView"
    private let keyBattleNumber = "keyBattleNumber"

    // MARK: Last User View Visited
    
    /// Para guardar el valor para la clave de ultima vista visitada
    func saveUserView(view: String) {
        UserDefaults.standard.set(view, forKey: keyUserView)
    }
    
    /// Para recuperar el valor para la clave de ultima vista visitada
    func loadUserView() -> String? {
        /// Podemos comprobar si la clave existe antes de intentar leerla
        if UserDefaults.standard.dictionaryRepresentation().keys.contains(keyUserView) {
            /// Si conocemos el valor esperado podemos usar el tipo despues de standard, porque .value devuelve Any
            print(UserDefaults.standard.dictionaryRepresentation().keys.debugDescription)
            return UserDefaults.standard.string(forKey: keyUserView)
            
        } else {
            print("La clave no existe")
            return String(describing: HeroesViewController.self)
        }
    }
    
    
    // MARK: Battle Counter
    
    /// Para guardar el valor del numero de batalla incremental
    func saveBattleNumber(number: Int) {
        UserDefaults.standard.set(number, forKey: keyBattleNumber)
    }
    
    /// Para recuperar un valor para una clave
    func loadBattleNumber() -> Int? {
        /// Podemos comprobar si la clave existe antes de intentar leerla
        if UserDefaults.standard.dictionaryRepresentation().keys.contains(keyBattleNumber) {
            /// Si conocemos el valor esperado podemos usar el tipo despues de standard, porque .value devuelve Any
            return UserDefaults.standard.integer(forKey: keyBattleNumber)
            
        } else {
            print("La clave no existe")
            return 1
        }
    }
    
    
    // MARK: First Execution
    
    /// Para guardar el valor del numero de batalla incremental
    func saveFirstRun(firstRun: Bool) {
        UserDefaults.standard.set(firstRun, forKey: keyFirstRun)
    }
    
    /// Para recuperar un valor para una clave
    func loadFirstRun() -> Bool? {
        /// Podemos comprobar si la clave existe antes de intentar leerla
        if UserDefaults.standard.dictionaryRepresentation().keys.contains(keyFirstRun) {
            /// Si conocemos el valor esperado podemos usar el tipo despues de standard, porque .value devuelve Any
            return UserDefaults.standard.bool(forKey: keyFirstRun)
            
        } else {
            print("La clave no existe")
            return true
        }
    }
}


// MARK: UIViewController Personal Utilities

extension UIViewController {
    /// Funcion para la generacion de mensajes de alerta
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
