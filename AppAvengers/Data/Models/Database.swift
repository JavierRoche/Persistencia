//
//  Database.swift
//  AppAvengers
//
//  Created by APPLE on 23/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import CoreData

class Database {
    /// Definimos todas las entidades, campos o relaciones que vayamos a usar
    private var entityHeroes = "Heroes"
    private var entityHeroesHeroID = "heroID"
    private var entityHeroesName = "name"
    private var entityHeroesAvatar = "avatar"
    private var entityHeroesPower = "power"
    private var entityHeroesDesc = "desc"
    private var entityHeroesBattles = "battles"
    private var entityVillains = "Villains"
    private var entityVillainsVillainID = "villainID"
    private var entityVillainsName = "name"
    private var entityVillainsAvatar = "avatar"
    private var entityVillainsPower = "power"
    private var entityVillainsDesc = "desc"
    private var entityVillainsBattles = "battles"
    
    /// Cargamos el AppDelegate para tener acceso al Persistent Containter desde nuestra clase
    private var managedObjectContext: NSManagedObjectContext? {
        //return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    
    // MARK: DataBase Methods
    
    /// fetchHeroes() accede a la BBDD directamente con el contexto y devuelve [NSManagedObject] que son objetos de BBDD
    /// Pero la clase de abstraccion DataProvider no sabe de contextos ni de BBDD, solo sabe que se va a devolver una [NSManagedObject] como [Heroes]
    /*
     func loadHeroes(heroID: Int16?) -> [Heroes] {
         guard let heroes: [Heroes] = database?.fetchHeroes(heroID: heroID) as? [Heroes] else {
             return []
         }
         return heroes
     }
     */
    func fetchHeroes(heroID: Int16?) -> [NSManagedObject]? {
        /// Definimos los parametros de busqueda con una NSFetchRequest y nos devolvera una lista de NSManagedObject
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityHeroes)
        
        if let id: Int16 = heroID {
            let predicate: NSPredicate = NSPredicate(format: "\(entityHeroesHeroID) = %i", id)
            request.predicate = predicate
        }
        
        /// Incluimos un orden de los datos devueltos en el NSFetchRequest
        let sort: NSSortDescriptor = NSSortDescriptor.init(key: entityHeroesHeroID, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let heroes: [NSManagedObject]? = try managedObjectContext?.fetch(request) as? [NSManagedObject]
            print("Heroes devueltos por BBDD")
            return heroes
            
        } catch {
            print("No se han podido recuperar los Heroes")
            return []
        }
    }
    
    
    /// fetchVillains() accede a la BBDD directamente con el contexto y devuelve [NSManagedObject] que son objetos de BBDD
    /// Pero la clase de abstraccion DataProvider no sabe de contextos ni de BBDD, solo sabe que se va a devolver una [NSManagedObject] como [Villains]
    /*
     func loadVillains(villainID: Int16?) -> [Villains] {
         guard let villains: [Villains] = database?.fetchVillains(villainID: villainID) as? [Villains] else {
             return []
         }
         return villains
     }
     */
    func fetchVillains(villainID: Int16?) -> [NSManagedObject]? {
        /// Definimos los parametros de busqueda con una NSFetchRequest y nos devolvera una lista de NSManagedObject
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityVillains)
        
        if let id: Int16 = villainID { //!= nil {
            let predicate: NSPredicate = NSPredicate(format: "\(entityVillainsVillainID) = %i", id)
            request.predicate = predicate
        }
        
        /// Incluimos un orden de los datos devueltos en el NSFetchRequest
        let sort: NSSortDescriptor = NSSortDescriptor.init(key: entityVillainsVillainID, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let villains: [NSManagedObject]? = try managedObjectContext?.fetch(request) as? [NSManagedObject]
            print("Villanos devueltos por BBDD")
            return villains
            
        } catch {
            print("No se han podido recuperar los Villanos")
            return []
        }
    }
    
    /// persistData() accede a la BBDD directamente con el contexto y persiste los datos en BBDD
    /// Pero la clase de abstraccion DataProvider no sabe de contextos ni de BBDD, solo sabe que se los datos se han salvado
    /*
     func saveData() {
         dataProvider.persistData()
     }
     */
    func persistData() {
        /// Para que los datos persistan del Managed Object al CoreData
        do {
            try managedObjectContext?.save()
            print("Commit de BBDD")
            
        } catch {
            print("Error en Commit de BBDD")
        }
    }
    
    
    // MARK: Initial Migration
    
    func dataMigration() {
        /// Sino podemos cargar las entidades no podemos continuar
        guard let context = managedObjectContext,
              let entityHeroes = NSEntityDescription.entity(forEntityName: entityHeroes, in: context),
              let entityVillains = NSEntityDescription.entity(forEntityName: entityVillains, in: context) else {
            return
        }
        /// Creamos un objeto NSManagedObject (registro) de la entidad que contendra la informacion de ese objeto (registro)
        /// Se debe indicar el nombre de la entidad y el contexto del Managed Object
        let hero1: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        /// Informamos sus campos, como si de un registro de BD se tratase
        hero1.setValue(1, forKey: entityHeroesHeroID)
        hero1.setValue("America Captain", forKey: entityHeroesName)
        hero1.setValue("AmericaAvatar", forKey: entityHeroesAvatar)
        hero1.setValue(0, forKey: entityHeroesPower)
        hero1.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero2: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero2.setValue(2, forKey: entityHeroesHeroID)
        hero2.setValue("Black Panter", forKey: entityHeroesName)
        hero2.setValue("PanterAvatar", forKey: entityHeroesAvatar)
        hero2.setValue(0, forKey: entityHeroesPower)
        hero2.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero3: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero3.setValue(3, forKey: entityHeroesHeroID)
        hero3.setValue("Black Widow", forKey: entityHeroesName)
        hero3.setValue("WidowAvatar", forKey: entityHeroesAvatar)
        hero3.setValue(0, forKey: entityHeroesPower)
        hero3.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero4: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero4.setValue(4, forKey: entityHeroesHeroID)
        hero4.setValue("Dr. Strange", forKey: entityHeroesName)
        hero4.setValue("StrangeAvatar", forKey: entityHeroesAvatar)
        hero4.setValue(0, forKey: entityHeroesPower)
        hero4.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero5: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero5.setValue(5, forKey: entityHeroesHeroID)
        hero5.setValue("Gamora", forKey: entityHeroesName)
        hero5.setValue("GamoraAvatar", forKey: entityHeroesAvatar)
        hero5.setValue(0, forKey: entityHeroesPower)
        hero5.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero6: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero6.setValue(6, forKey: entityHeroesHeroID)
        hero6.setValue("Hulk", forKey: entityHeroesName)
        hero6.setValue("HulkAvatar", forKey: entityHeroesAvatar)
        hero6.setValue(0, forKey: entityHeroesPower)
        hero6.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero7: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero7.setValue(7, forKey: entityHeroesHeroID)
        hero7.setValue("Ironman", forKey: entityHeroesName)
        hero7.setValue("IronmanAvatar", forKey: entityHeroesAvatar)
        hero7.setValue(0, forKey: entityHeroesPower)
        hero7.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero8: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero8.setValue(8, forKey: entityHeroesHeroID)
        hero8.setValue("Marvel Captain", forKey: entityHeroesName)
        hero8.setValue("MarvelAvatar", forKey: entityHeroesAvatar)
        hero8.setValue(0, forKey: entityHeroesPower)
        hero8.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero9: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero9.setValue(9, forKey: entityHeroesHeroID)
        hero9.setValue("Spiderman", forKey: entityHeroesName)
        hero9.setValue("SpidermanAvatar", forKey: entityHeroesAvatar)
        hero9.setValue(0, forKey: entityHeroesPower)
        hero9.setValue("Descripcion", forKey: entityHeroesDesc)
        let hero10: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero10.setValue(10, forKey: entityHeroesHeroID)
        hero10.setValue("Thor", forKey: entityHeroesName)
        hero10.setValue("ThorAvatar", forKey: entityHeroesAvatar)
        hero10.setValue(0, forKey: entityHeroesPower)
        hero10.setValue("Descripcion", forKey: entityHeroesDesc)
        
        /// Creamos un objeto NSManagedObject (registro) de la entidad que contendra la informacion de ese objeto (registro)
        /// Se debe indicar el nombre de la entidad y el contexto del Managed Object
        let villain1: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        /// Informamos sus campos, como si de un registro de BD se tratase
        villain1.setValue(1, forKey: entityVillainsVillainID)
        villain1.setValue("Yon Rogg", forKey: entityVillainsName)
        villain1.setValue("YonRoggAvatar", forKey: entityVillainsAvatar)
        villain1.setValue(0, forKey: entityVillainsPower)
        villain1.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain2: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain2.setValue(2, forKey: entityVillainsVillainID)
        villain2.setValue("Dormammu", forKey: entityVillainsName)
        villain2.setValue("DormammuAvatar", forKey: entityVillainsAvatar)
        villain2.setValue(0, forKey: entityVillainsPower)
        villain2.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain3: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain3.setValue(3, forKey: entityVillainsVillainID)
        villain3.setValue("Ego", forKey: entityVillainsName)
        villain3.setValue("EgoAvatar", forKey: entityVillainsAvatar)
        villain3.setValue(0, forKey: entityVillainsPower)
        villain3.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain4: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain4.setValue(4, forKey: entityVillainsVillainID)
        villain4.setValue("Hela", forKey: entityVillainsName)
        villain4.setValue("HelaAvatar", forKey: entityVillainsAvatar)
        villain4.setValue(0, forKey: entityVillainsPower)
        villain4.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain5: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain5.setValue(5, forKey: entityVillainsVillainID)
        villain5.setValue("Ivan Vanko", forKey: entityVillainsName)
        villain5.setValue("VankoAvatar", forKey: entityVillainsAvatar)
        villain5.setValue(0, forKey: entityVillainsPower)
        villain5.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain6: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain6.setValue(6, forKey: entityVillainsVillainID)
        villain6.setValue("Johann Schmidt", forKey: entityVillainsName)
        villain6.setValue("SchmidtAvatar", forKey: entityVillainsAvatar)
        villain6.setValue(0, forKey: entityVillainsPower)
        villain6.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain7: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain7.setValue(7, forKey: entityVillainsVillainID)
        villain7.setValue("Malekith", forKey: entityVillainsName)
        villain7.setValue("MalekithAvatar", forKey: entityVillainsAvatar)
        villain7.setValue(0, forKey: entityVillainsPower)
        villain7.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain8: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain8.setValue(8, forKey: entityVillainsVillainID)
        villain8.setValue("Ronan The Accuser", forKey: entityVillainsName)
        villain8.setValue("RonanAvatar", forKey: entityVillainsAvatar)
        villain8.setValue(0, forKey: entityVillainsPower)
        villain8.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain9: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain9.setValue(9, forKey: entityVillainsVillainID)
        villain9.setValue("Thanos", forKey: entityVillainsName)
        villain9.setValue("ThanosAvatar", forKey: entityVillainsAvatar)
        villain9.setValue(0, forKey: entityVillainsPower)
        villain9.setValue("Descripcion", forKey: entityVillainsDesc)
        let villain10: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain10.setValue(10, forKey: entityVillainsVillainID)
        villain10.setValue("Ultron", forKey: entityVillainsName)
        villain10.setValue("UltronAvatar", forKey: entityVillainsAvatar)
        villain10.setValue(0, forKey: entityVillainsPower)
        villain10.setValue("Descripcion", forKey: entityVillainsDesc)
        
        /// Para que los datos persistan del Managed Object al CoreData
        persistData()
    }
    
    func deleteMigration() {
        /// Sino podemos recuperar en nuestra variable computada el Object Context no seguimos
        /// Sino podemos cargar la entidad no podemos continuar
        guard let context = managedObjectContext else {
            return
        }
        
        /// Definimos los parametros de busqueda con una NSFetchRequest y nos devolvera un NSManagedObject
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: entityHeroes)
        /// Recuperamos y borramos todos los heroes
        do {
            let heroes: [NSManagedObject]? = try managedObjectContext?.fetch(request) as? [NSManagedObject]
            /// Con forEach recorremos los registros recuperados eliminandolos
            heroes?.forEach {
                context.delete($0)
            }
            
        } catch {
            print("Error al borrar los Heroes")
        }
        
        /// Definimos los parametros de busqueda con una NSFetchRequest y nos devolvera un NSManagedObject
        request = NSFetchRequest<NSFetchRequestResult>(entityName: entityVillains)
        /// Recuperamos y borramos todos los villanos
        do {
            let villains: [NSManagedObject]? = try managedObjectContext?.fetch(request) as? [NSManagedObject]
            /// Con forEach recorremos los registros recuperados eliminandolos
            villains?.forEach {
                context.delete($0)
            }
            
        } catch {
            print("Error al borrar los Villanos")
        }
        
        /// Para que los datos persistan del Managed Object al CoreData
        persistData()
    }
    
    
    // MARK: - STRINGS ARGUMENTS -

    // %@ replace with argument String
    // %i replace with argument Integer
    // %d replace with argument Double
    // %f replace with argument Float
    // %ld replace with argument Long

}
