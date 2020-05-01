//
//  DataProvider.swift
//  AppAvengers
//
//  Created by APPLE on 23/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

/// Esta clase implementa un metodo de comunicacion a los metodos de almacenamiento de datos y abstrae de ellos a la App
/// En lugar de llamar directamente a CoreData o Realm llama a esta clase para abstraer la logica a nuestra aplicacion
class DataProvider {
    private var database: Database? = nil
    
    /// Cuando construyan un objeto inicializamos el objeto DataBase vacio
    init() {
        database = Database()
    }
    
    /// Nos aseguramos que al salir se elimina nuestro DataBase
    deinit {
        database = nil
    }
    
    /// Funcion que devuelve una lista de heroes de BBDD, acepta solo 1
    func loadHeroes(heroID: Int16?) -> [Heroes] {
        guard let heroes: [Heroes] = database?.fetchHeroes(heroID: heroID) as? [Heroes] else {
            return []
        }
        return heroes
    }
    
    /// Funcion que devuelve una lista de villanos de BBDD, acepta solo 1
    func loadVillains(villainID: Int16?) -> [Villains] {
        guard let villains: [Villains] = database?.fetchVillains(villainID: villainID) as? [Villains] else {
            return []
        }
        return villains
    }
    
    /// Funcion que devuelve una lista de batallas de BBDD, acepta solo 1
    func loadBattles(characterID: Int16?) -> [Battles] {
        guard let battles: [Battles] = database?.fetchBattles(characterID: characterID) as? [Battles] else {
            return []
        }
        return battles
    }
    
    /// Funcion que crea una nueva batalla en BBDD
    func createBattle() -> Battles? {
        return database?.insertBattle() as? Battles
    }
    
    /// Funcion que borra una lista de objetos en BBDD
    func deleteBattles(battles: [Battles]) {
        database?.deleteObjects(objects: battles)
    }

    /// Funcion que commitea los datos en la BBDD
    func saveData() {
        database?.persistData()
    }
}


// MARK: Initial Migration

extension DataProvider {
    func runDataMigration() {
        database?.dataMigration()
    }
    
    func runDeleteMigration() {
        database?.deleteMigration()
    }
}
