//
//  Database.swift
//  AppAvengers
//
//  Created by APPLE on 23/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import CoreData

/// Las funciones acceden a la BBDD directamente con el contexto y crean o reciben [NSManagedObject] que son objetos de BBDD. Pero la clase de abstraccion DataProvider no sabe de contextos ni de BBDD, solo pide y recibe una respuesta
class Database {
    /// Definimos todas las entidades, campos o relaciones que vayamos a usar
    private var entityHeroes = "Heroes"
    private var entityHeroesHeroID = "heroID"
    private var entityHeroesName = "name"
    private var entityHeroesAvatar = "avatar"
    private var entityHeroesPower = "power"
    private var entityHeroesDesc = "desc"
    private var entityVillains = "Villains"
    private var entityVillainsVillainID = "villainID"
    private var entityVillainsName = "name"
    private var entityVillainsAvatar = "avatar"
    private var entityVillainsPower = "power"
    private var entityVillainsDesc = "desc"
    private var entityBattles = "Battles"
    private var entityBattlesBattleID = "battleID"
    private var entityBattlesHeroID = "heroID"
    private var entityBattlesVillainID = "villainID"
    private var entityBattlesWinnerID = "winnerID"
    private var entityBattlesHero = "hero"
    private var entityBattlesVillain = "villain"
    
    /// Cargamos el AppDelegate para tener acceso al Persistent Containter desde nuestra clase
    private var managedObjectContext: NSManagedObjectContext? {
        //return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    
    // MARK: DataBase Methods
    
    /// func loadHeroes(heroID: Int16?) -> [Heroes] {
    ///    guard let heroes: [Heroes] = database?.fetchHeroes(heroID: heroID) as? [Heroes] else {
    ///        return []
    ///    }
    ///    return heroes
    /// }
    func fetchHeroes(heroID: Int16?) -> [NSManagedObject]? {
        /// Definimos los parametros de busqueda con una NSFetchRequest y nos devolvera una lista de NSManagedObject
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityHeroes)
        
        /// Si han pedido un heroe en concreto
        if let id: Int16 = heroID {
            let predicate: NSPredicate = NSPredicate(format: "\(entityHeroesHeroID) = %i", id)
            request.predicate = predicate
        }
        
        /// Incluimos un orden de los datos devueltos en el NSFetchRequest
        let sort: NSSortDescriptor = NSSortDescriptor.init(key: entityHeroesHeroID, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let heroes: [NSManagedObject]? = try managedObjectContext?.fetch(request) as? [NSManagedObject]
//            print("Heroes devueltos por BBDD")
            return heroes
            
        } catch {
//            print("No se han podido recuperar los Heroes")
            return []
        }
    }
    
    
    /// func loadVillains(villainID: Int16?) -> [Villains] {
    ///    guard let villains: [Villains] = database?.fetchVillains(villainID: villainID) as? [Villains] else {
    ///        return []
    ///    }
    ///    return villains
    /// }
    func fetchVillains(villainID: Int16?) -> [NSManagedObject]? {
        /// Definimos los parametros de busqueda con una NSFetchRequest y nos devolvera una lista de NSManagedObject
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityVillains)
        
        /// Si han pedido un villano en concreto
        if let id: Int16 = villainID {
            let predicate: NSPredicate = NSPredicate(format: "\(entityVillainsVillainID) = %i", id)
            request.predicate = predicate
        }
        
        /// Incluimos un orden de los datos devueltos en el NSFetchRequest
        let sort: NSSortDescriptor = NSSortDescriptor.init(key: entityVillainsVillainID, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let villains: [NSManagedObject]? = try managedObjectContext?.fetch(request) as? [NSManagedObject]
//            print("Villanos devueltos por BBDD")
            return villains
            
        } catch {
//            print("No se han podido recuperar los Villanos")
            return []
        }
    }
    
    
    /// func loadBattles(characterID: Int16?) -> [Battles] {
    ///    guard let battles: [Battles] = database?.fetchBattles(characterID: characterID) as? [Battles] else {
    ///        return []
    ///    }
    ///    return battles
    /// }
    func fetchBattles(characterID: Int16?) -> [NSManagedObject]? {
        /// Definimos los parametros de busqueda con una NSFetchRequest y nos devolvera una lista de NSManagedObject
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityBattles)
        
        /// Si han pedido las batallas de un character en concreto
        if let id: Int16 = characterID {
            let predicate: NSPredicate = NSPredicate(format: "\(entityBattlesHeroID) = %i OR \(entityBattlesVillainID) = %i", id, id)
            request.predicate = predicate
        }
        
        /// Incluimos un orden de los datos devueltos en el NSFetchRequest
        let sort: NSSortDescriptor = NSSortDescriptor.init(key: entityBattlesBattleID, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let battles: [NSManagedObject]? = try managedObjectContext?.fetch(request) as? [NSManagedObject]
//            print("Batallas devueltas por BBDD")
            return battles
            
        } catch {
//            print("No se han podido recuperar las Batallas")
            return[]
        }
    }

    
    /// func createBattle() -> Battles {
    ///    return database?.insertBattle() as? Battles
    /// }
    func insertBattle() -> NSManagedObject? {
        /// Nos aseguramos de tener un contexto para la entidad
        guard let context = managedObjectContext, let entity = NSEntityDescription.entity(forEntityName: entityBattles, in: context) else {
            return nil
        }
        /// En este momento se transforma el NSManagedObject en objeto del modelo Battles
        return Battles(entity: entity, insertInto: context)
    }
        
    
    /// func deleteBattles(battles: [Battles]) {
    ///    database?.deleteObjects(objects: battles)
    /// }
    func deleteObjects(objects: [NSManagedObject]) {
        /// Recorremos la lista de objetos a borrar
        objects.forEach {
            managedObjectContext?.delete($0)
        }
        
        /// Si no salvamos los datos no se persisten despues del delete
        persistData()
    }
    
    
    /// func saveData() {
    ///    dataProvider.persistData()
    /// }
    func persistData() {
        /// Para que los datos persistan del Managed Object al CoreData
        do {
            try managedObjectContext?.save()
//            print("Commit de BBDD")
            
        } catch {
//            print("Error en Commit de BBDD")
        }
    }
    
    
    // MARK: Initial Migration
    
    func dataMigration() {
        /// Sino podemos cargar las entidades no podemos continuar
        guard let context = managedObjectContext,
              let entityHeroes = NSEntityDescription.entity(forEntityName: entityHeroes, in: context),
              let entityVillains = NSEntityDescription.entity(forEntityName: entityVillains, in: context),
              let entityBattles = NSEntityDescription.entity(forEntityName: entityBattles, in: context) else {
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
        hero1.setValue("Steven Grant Rogers was born in Brooklyn, New York on July 4th, 1918 to Sarah and Joseph Rogers. His father was an Army soldier who fought and died in the First World War. ... Years later during an art...", forKey: entityHeroesDesc)
        let hero2: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero2.setValue(2, forKey: entityHeroesHeroID)
        hero2.setValue("Black Panter", forKey: entityHeroesName)
        hero2.setValue("PanterAvatar", forKey: entityHeroesAvatar)
        hero2.setValue(0, forKey: entityHeroesPower)
        hero2.setValue("The Black Panther is the ceremonial title given to the chief of the Panther Tribe of the advanced African nation of Wakanda. In addition to ruling the country, he is also paramount chief of its...", forKey: entityHeroesDesc)
        let hero3: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero3.setValue(3, forKey: entityHeroesHeroID)
        hero3.setValue("Black Widow", forKey: entityHeroesName)
        hero3.setValue("WidowAvatar", forKey: entityHeroesAvatar)
        hero3.setValue(0, forKey: entityHeroesPower)
        hero3.setValue("Natasha was born in Stalingrad (now Volgograd), Russia, USSR. The first and best-known Black Widow is a Russian agent trained as a spy, martial artist, and sniper, and outfitted with an arsenal of...", forKey: entityHeroesDesc)
        let hero4: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero4.setValue(4, forKey: entityHeroesHeroID)
        hero4.setValue("Dr. Strange", forKey: entityHeroesName)
        hero4.setValue("StrangeAvatar", forKey: entityHeroesAvatar)
        hero4.setValue(0, forKey: entityHeroesPower)
        hero4.setValue("Stephen Strange is a greedy and self-centered doctor specializing in neurosurgery, who only cares about the wealth of his career, until in an accident he suffered a nervous illness in his hands...", forKey: entityHeroesDesc)
        let hero5: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero5.setValue(5, forKey: entityHeroesHeroID)
        hero5.setValue("Gamora", forKey: entityHeroesName)
        hero5.setValue("GamoraAvatar", forKey: entityHeroesAvatar)
        hero5.setValue(0, forKey: entityHeroesPower)
        hero5.setValue("Gamora is a former Zehoberei assassin and a former member of the Guardians of the Galaxy. She became the adopted daughter of Thanos and adopted sister of Nebula after he killed half of her race...", forKey: entityHeroesDesc)
        let hero6: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero6.setValue(6, forKey: entityHeroesHeroID)
        hero6.setValue("Hulk", forKey: entityHeroesName)
        hero6.setValue("HulkAvatar", forKey: entityHeroesAvatar)
        hero6.setValue(0, forKey: entityHeroesPower)
        hero6.setValue("In his comic book appearances, the character is both the Hulk, a green-skinned, hulking and muscular humanoid possessing a vast degree of physical strength, and his alter ego Dr.", forKey: entityHeroesDesc)
        let hero7: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero7.setValue(7, forKey: entityHeroesHeroID)
        hero7.setValue("Ironman", forKey: entityHeroesName)
        hero7.setValue("IronmanAvatar", forKey: entityHeroesAvatar)
        hero7.setValue(0, forKey: entityHeroesPower)
        hero7.setValue("Iron Man Biography, History. ... Iron Man, like knights of old, is identified by the armor he wears. The best-dressed of the Marvel heroes, he has changed his look frequently since his debut in 1963...", forKey: entityHeroesDesc)
        let hero8: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero8.setValue(8, forKey: entityHeroesHeroID)
        hero8.setValue("Marvel Captain", forKey: entityHeroesName)
        hero8.setValue("MarvelAvatar", forKey: entityHeroesAvatar)
        hero8.setValue(0, forKey: entityHeroesPower)
        hero8.setValue("Carol Susan Jane Danvers began her career in the United States Air Force and rose to the post of Chief of Security for Cape Canaveral. There she was related to Captain Marvel, a Kree soldier who...", forKey: entityHeroesDesc)
        let hero9: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero9.setValue(9, forKey: entityHeroesHeroID)
        hero9.setValue("Spiderman", forKey: entityHeroesName)
        hero9.setValue("SpidermanAvatar", forKey: entityHeroesAvatar)
        hero9.setValue(0, forKey: entityHeroesPower)
        hero9.setValue("Peter Parker was an orphaned teenage boy who lived in Queens, New York with his Aunt May and Uncle Ben. ... At the science museum, Peter was bitten by a radioactive spider. The spider bite gave Peter...", forKey: entityHeroesDesc)
        let hero10: NSManagedObject = NSManagedObject(entity: entityHeroes, insertInto: context)
        hero10.setValue(10, forKey: entityHeroesHeroID)
        hero10.setValue("Thor", forKey: entityHeroesName)
        hero10.setValue("ThorAvatar", forKey: entityHeroesAvatar)
        hero10.setValue(0, forKey: entityHeroesPower)
        hero10.setValue("Born on August 11, 1983, Australian heartthrob Chris Hemsworth has made quite a name for himself by swinging his hammer as Marvel comic book character Thor, starring in several films under that title...", forKey: entityHeroesDesc)
        
        /// Creamos un objeto NSManagedObject (registro) de la entidad que contendra la informacion de ese objeto (registro)
        /// Se debe indicar el nombre de la entidad y el contexto del Managed Object
        let villain1: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        /// Informamos sus campos, como si de un registro de BD se tratase
        villain1.setValue(11, forKey: entityVillainsVillainID)
        villain1.setValue("Yon Rogg", forKey: entityVillainsName)
        villain1.setValue("YonRoggAvatar", forKey: entityVillainsAvatar)
        villain1.setValue(0, forKey: entityVillainsPower)
        villain1.setValue("Yon-Rogg is a Kree military officer who is the commander of the Helion, a Kree spaceship that was sent to Earth by the Supreme Intelligence. Yon-Rogg had a deep hatred towards Mar-Vell due to his...", forKey: entityVillainsDesc)
        let villain2: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain2.setValue(12, forKey: entityVillainsVillainID)
        villain2.setValue("Dormammu", forKey: entityVillainsName)
        villain2.setValue("DormammuAvatar", forKey: entityVillainsAvatar)
        villain2.setValue(0, forKey: entityVillainsPower)
        villain2.setValue("Born untold thousands or even millions of years ago in the dimension of the vastly powerful energy-entities called the Faltine, Dormammu and his sibling Umar gathered matter to themselves...", forKey: entityVillainsDesc)
        let villain3: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain3.setValue(13, forKey: entityVillainsVillainID)
        villain3.setValue("Ego", forKey: entityVillainsName)
        villain3.setValue("EgoAvatar", forKey: entityVillainsAvatar)
        villain3.setValue(0, forKey: entityVillainsPower)
        villain3.setValue("Ego was a Celestial, a primordial and powerful being, and the biological father of Peter Quill. A living planet with a humanoid extension of himself", forKey: entityVillainsDesc)
        let villain4: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain4.setValue(14, forKey: entityVillainsVillainID)
        villain4.setValue("Hela", forKey: entityVillainsName)
        villain4.setValue("HelaAvatar", forKey: entityVillainsAvatar)
        villain4.setValue(0, forKey: entityVillainsPower)
        villain4.setValue("Hela was born in Jotunheim, the land of the giants. She is the child of Loki (albeit a different incarnation[1] who died during a previous Asgardian Ragnarok) and the giantess Angrboða", forKey: entityVillainsDesc)
        let villain5: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain5.setValue(15, forKey: entityVillainsVillainID)
        villain5.setValue("Ivan Vanko", forKey: entityVillainsName)
        villain5.setValue("VankoAvatar", forKey: entityVillainsAvatar)
        villain5.setValue(0, forKey: entityVillainsPower)
        villain5.setValue("Ivan Vanko was born on February 15, 1968. He was the son of Anton Vanko, a Russian physicist who helped Howard Stark design the Arc Reactor, but was deported from the United States when Howard...", forKey: entityVillainsDesc)
        let villain6: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain6.setValue(16, forKey: entityVillainsVillainID)
        villain6.setValue("Johann Schmidt", forKey: entityVillainsName)
        villain6.setValue("SchmidtAvatar", forKey: entityVillainsAvatar)
        villain6.setValue(0, forKey: entityVillainsPower)
        villain6.setValue("Johann Schmidt was born in a village in Germany to Hermann Schmidt and Martha Schmidt. His mother died in childbirth, and his father blamed Johann for her death... ", forKey: entityVillainsDesc)
        let villain7: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain7.setValue(17, forKey: entityVillainsVillainID)
        villain7.setValue("Malekith", forKey: entityVillainsName)
        villain7.setValue("MalekithAvatar", forKey: entityVillainsAvatar)
        villain7.setValue(0, forKey: entityVillainsPower)
        villain7.setValue("Malekith is the son of the legendary Aenarion and his second wife Morathi. He was born and raised in Nagarythe, and many believe that his childhood traumatised him as his father's court was a bitter...", forKey: entityVillainsDesc)
        let villain8: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain8.setValue(18, forKey: entityVillainsVillainID)
        villain8.setValue("Ronan The Accuser", forKey: entityVillainsName)
        villain8.setValue("RonanAvatar", forKey: entityVillainsAvatar)
        villain8.setValue(0, forKey: entityVillainsPower)
        villain8.setValue("Ronan was born on the planet Hala, the capital of the Kree Empire in the Greater Magellanic Cloud", forKey: entityVillainsDesc)
        let villain9: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain9.setValue(19, forKey: entityVillainsVillainID)
        villain9.setValue("Thanos", forKey: entityVillainsName)
        villain9.setValue("ThanosAvatar", forKey: entityVillainsAvatar)
        villain9.setValue(0, forKey: entityVillainsPower)
        villain9.setValue("Thanos debuted in Iron Man #55, in February of 1973. Born Dione on Saturn's moon of Titan, Thanos grew up in a peace-loving family", forKey: entityVillainsDesc)
        let villain10: NSManagedObject = NSManagedObject(entity: entityVillains, insertInto: context)
        villain10.setValue(20, forKey: entityVillainsVillainID)
        villain10.setValue("Ultron", forKey: entityVillainsName)
        villain10.setValue("UltronAvatar", forKey: entityVillainsAvatar)
        villain10.setValue(0, forKey: entityVillainsPower)
        villain10.setValue("Although Ultron first appears in Avengers #54 (1968), the character is disguised for the majority of the issue as the Crimson Cowl, with his face only revealed on the last page of the issue...", forKey: entityVillainsDesc)
        
        /// Creamos un objeto NSManagedObject (registro) de la entidad que contendra la informacion de ese objeto (registro)
        /// Se debe indicar el nombre de la entidad y el contexto del Managed Object
        let battle1: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        /// Informamos sus campos, como si de un registro de BD se tratase
        battle1.setValue(1, forKey: entityBattlesBattleID)
        battle1.setValue(1, forKey: entityBattlesHeroID)
        battle1.setValue(11, forKey: entityBattlesVillainID)
        battle1.setValue(1, forKey: entityBattlesWinnerID)
        battle1.setValue(hero1, forKey: entityBattlesHero)
        battle1.setValue(villain1, forKey: entityBattlesVillain)
        let battle2: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle2.setValue(2, forKey: entityBattlesBattleID)
        battle2.setValue(1, forKey: entityBattlesHeroID)
        battle2.setValue(11, forKey: entityBattlesVillainID)
        battle2.setValue(11, forKey: entityBattlesWinnerID)
        battle2.setValue(hero1, forKey: entityBattlesHero)
        battle2.setValue(villain1, forKey: entityBattlesVillain)
        let battle3: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle3.setValue(3, forKey: entityBattlesBattleID)
        battle3.setValue(2, forKey: entityBattlesHeroID)
        battle3.setValue(12, forKey: entityBattlesVillainID)
        battle3.setValue(2, forKey: entityBattlesWinnerID)
        battle3.setValue(hero2, forKey: entityBattlesHero)
        battle3.setValue(villain2, forKey: entityBattlesVillain)
        let battle4: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle4.setValue(4, forKey: entityBattlesBattleID)
        battle4.setValue(2, forKey: entityBattlesHeroID)
        battle4.setValue(12, forKey: entityBattlesVillainID)
        battle4.setValue(12, forKey: entityBattlesWinnerID)
        battle4.setValue(hero2, forKey: entityBattlesHero)
        battle4.setValue(villain2, forKey: entityBattlesVillain)
        let battle5: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle5.setValue(5, forKey: entityBattlesBattleID)
        battle5.setValue(3, forKey: entityBattlesHeroID)
        battle5.setValue(13, forKey: entityBattlesVillainID)
        battle5.setValue(3, forKey: entityBattlesWinnerID)
        battle5.setValue(hero3, forKey: entityBattlesHero)
        battle5.setValue(villain3, forKey: entityBattlesVillain)
        let battle6: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle6.setValue(6, forKey: entityBattlesBattleID)
        battle6.setValue(3, forKey: entityBattlesHeroID)
        battle6.setValue(13, forKey: entityBattlesVillainID)
        battle6.setValue(13, forKey: entityBattlesWinnerID)
        battle6.setValue(hero3, forKey: entityBattlesHero)
        battle6.setValue(villain3, forKey: entityBattlesVillain)
        let battle7: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle7.setValue(7, forKey: entityBattlesBattleID)
        battle7.setValue(4, forKey: entityBattlesHeroID)
        battle7.setValue(14, forKey: entityBattlesVillainID)
        battle7.setValue(4, forKey: entityBattlesWinnerID)
        battle7.setValue(hero4, forKey: entityBattlesHero)
        battle7.setValue(villain4, forKey: entityBattlesVillain)
        let battle8: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle8.setValue(8, forKey: entityBattlesBattleID)
        battle8.setValue(4, forKey: entityBattlesHeroID)
        battle8.setValue(14, forKey: entityBattlesVillainID)
        battle8.setValue(14, forKey: entityBattlesWinnerID)
        battle8.setValue(hero4, forKey: entityBattlesHero)
        battle8.setValue(villain4, forKey: entityBattlesVillain)
        let battle9: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle9.setValue(9, forKey: entityBattlesBattleID)
        battle9.setValue(5, forKey: entityBattlesHeroID)
        battle9.setValue(15, forKey: entityBattlesVillainID)
        battle9.setValue(5, forKey: entityBattlesWinnerID)
        battle9.setValue(hero5, forKey: entityBattlesHero)
        battle9.setValue(villain5, forKey: entityBattlesVillain)
        let battle10: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle10.setValue(10, forKey: entityBattlesBattleID)
        battle10.setValue(5, forKey: entityBattlesHeroID)
        battle10.setValue(15, forKey: entityBattlesVillainID)
        battle10.setValue(15, forKey: entityBattlesWinnerID)
        battle10.setValue(hero5, forKey: entityBattlesHero)
        battle10.setValue(villain5, forKey: entityBattlesVillain)
        let battle11: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle11.setValue(11, forKey: entityBattlesBattleID)
        battle11.setValue(6, forKey: entityBattlesHeroID)
        battle11.setValue(16, forKey: entityBattlesVillainID)
        battle11.setValue(6, forKey: entityBattlesWinnerID)
        battle11.setValue(hero6, forKey: entityBattlesHero)
        battle11.setValue(villain6, forKey: entityBattlesVillain)
        let battle12: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle12.setValue(12, forKey: entityBattlesBattleID)
        battle12.setValue(6, forKey: entityBattlesHeroID)
        battle12.setValue(16, forKey: entityBattlesVillainID)
        battle12.setValue(16, forKey: entityBattlesWinnerID)
        battle12.setValue(hero6, forKey: entityBattlesHero)
        battle12.setValue(villain6, forKey: entityBattlesVillain)
        let battle13: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle13.setValue(13, forKey: entityBattlesBattleID)
        battle13.setValue(7, forKey: entityBattlesHeroID)
        battle13.setValue(17, forKey: entityBattlesVillainID)
        battle13.setValue(7, forKey: entityBattlesWinnerID)
        battle13.setValue(hero7, forKey: entityBattlesHero)
        battle13.setValue(villain7, forKey: entityBattlesVillain)
        let battle14: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle14.setValue(14, forKey: entityBattlesBattleID)
        battle14.setValue(7, forKey: entityBattlesHeroID)
        battle14.setValue(17, forKey: entityBattlesVillainID)
        battle14.setValue(17, forKey: entityBattlesWinnerID)
        battle14.setValue(hero7, forKey: entityBattlesHero)
        battle14.setValue(villain7, forKey: entityBattlesVillain)
        let battle15: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle15.setValue(15, forKey: entityBattlesBattleID)
        battle15.setValue(8, forKey: entityBattlesHeroID)
        battle15.setValue(18, forKey: entityBattlesVillainID)
        battle15.setValue(8, forKey: entityBattlesWinnerID)
        battle15.setValue(hero8, forKey: entityBattlesHero)
        battle15.setValue(villain8, forKey: entityBattlesVillain)
        let battle16: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle16.setValue(16, forKey: entityBattlesBattleID)
        battle16.setValue(8, forKey: entityBattlesHeroID)
        battle16.setValue(18, forKey: entityBattlesVillainID)
        battle16.setValue(18, forKey: entityBattlesWinnerID)
        battle16.setValue(hero8, forKey: entityBattlesHero)
        battle16.setValue(villain8, forKey: entityBattlesVillain)
        let battle17: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle17.setValue(17, forKey: entityBattlesBattleID)
        battle17.setValue(9, forKey: entityBattlesHeroID)
        battle17.setValue(19, forKey: entityBattlesVillainID)
        battle17.setValue(9, forKey: entityBattlesWinnerID)
        battle17.setValue(hero9, forKey: entityBattlesHero)
        battle17.setValue(villain9, forKey: entityBattlesVillain)
        let battle18: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle18.setValue(18, forKey: entityBattlesBattleID)
        battle18.setValue(9, forKey: entityBattlesHeroID)
        battle18.setValue(19, forKey: entityBattlesVillainID)
        battle18.setValue(19, forKey: entityBattlesWinnerID)
        battle18.setValue(hero9, forKey: entityBattlesHero)
        battle18.setValue(villain9, forKey: entityBattlesVillain)
        let battle19: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle19.setValue(19, forKey: entityBattlesBattleID)
        battle19.setValue(10, forKey: entityBattlesHeroID)
        battle19.setValue(20, forKey: entityBattlesVillainID)
        battle19.setValue(10, forKey: entityBattlesWinnerID)
        battle19.setValue(hero10, forKey: entityBattlesHero)
        battle19.setValue(villain10, forKey: entityBattlesVillain)
        let battle20: NSManagedObject = NSManagedObject(entity: entityBattles, insertInto: context)
        battle20.setValue(20, forKey: entityBattlesBattleID)
        battle20.setValue(10, forKey: entityBattlesHeroID)
        battle20.setValue(20, forKey: entityBattlesVillainID)
        battle20.setValue(20, forKey: entityBattlesWinnerID)
        battle20.setValue(hero10, forKey: entityBattlesHero)
        battle20.setValue(villain10, forKey: entityBattlesVillain)
        
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
//            print("Error al borrar los Heroes")
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
//            print("Error al borrar los Villanos")
        }
        
        /// Definimos los parametros de busqueda con una NSFetchRequest y nos devolvera un NSManagedObject
        request = NSFetchRequest<NSFetchRequestResult>(entityName: entityBattles)
        /// Recuperamos y borramos todos las batallas
        do {
            let battles: [NSManagedObject]? = try managedObjectContext?.fetch(request) as? [NSManagedObject]
            /// Con forEach recorremos los registros recuperados eliminandolos
            battles?.forEach {
                context.delete($0)
            }
            
        } catch {
//            print("Error al borrar las Batallas")
        }
        
        /// Para que los datos persistan del Managed Object al CoreData
        persistData()
    }
    
    
    // MARK: Predicate Strings Arguments

    // %@ replace with argument String
    // %i replace with argument Integer
    // %d replace with argument Double
    // %f replace with argument Float
    // %ld replace with argument Long
}
