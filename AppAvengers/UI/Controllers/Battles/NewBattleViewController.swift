//
//  NewBattleViewController.swift
//  AppAvengers
//
//  Created by APPLE on 27/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class NewBattleViewController: UIViewController {
    @IBOutlet weak var battleName: UILabel!
    @IBOutlet weak var heroAvatar: UIImageView!
    @IBOutlet weak var villainAvatar: UIImageView!
    
    /// Los participantes del combate
    private var hero: Heroes?
    private var villain: Villains?
    private let caBattle: String = "Battle"
    /// El DataProvider para acceder a la clase que abstrae de la BBDD
    private var dataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: IBActions
    
    @IBAction func runBattleTapped(_ sender: Any) {
        /// Creamos la nueva batalla en BBDD
        let battle: Battles? = dataProvider.createBattle()
        
        /// Accedemos a UserDefaults a por el numero de batalla y obtenemos el vencedor
        let userDefaults: UserDefaultsProvider = UserDefaultsProvider()
        guard let battleID = userDefaults.loadBattleNumber(),
              let heroID = hero?.heroID,
              let villainID = villain?.villainID,
              let winnerID = computeCombat() else {
            self.showAlert(title: "Warning", message: "Select figthers")
            return
        }
        
        /// Asignamos los valores obtenidos para la batalla
        battle?.battleID = Int16(battleID)
        battle?.heroID = heroID
        battle?.villainID = villainID
        battle?.winnerID = winnerID
        battle?.hero = hero
        battle?.villain = villain
        
        /// Persistimos los datos en BBDD
        dataProvider.saveData()
        
        /// Aumentamos en 1 el contador de batalla
        userDefaults.saveBattleNumber(number: battleID + 1)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func heroImageTapped(_ sender: UITapGestureRecognizer) {
        /// Abrimos la UIView de listado de heroes para seleccionar uno para el combate
        let selectCharaterView: HeroesViewController = HeroesViewController.init(selection: true)
        selectCharaterView.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: selectCharaterView)
        navigationController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        print("heroImageTapped")
    }
    
    @objc private func villainImageTapped(_ sender: UITapGestureRecognizer) {
        /// Abrimos la UIView de listado de villanos para seleccionar uno para el combate
        let selectCharaterView: VillainsViewController = VillainsViewController.init(selection: true)
        selectCharaterView.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: selectCharaterView)
        navigationController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        print("villainImageTapped")
    }
    
    @objc private func closeViewTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Functions
    
    func configureUI() {
        /// Creacion del boton de la barra de navegacion para ir hacia atras
        let closeView: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(closeViewTapped))
        closeView.tintColor = .blue
        navigationItem.rightBarButtonItem = closeView
        
        /// Creacion de la respuesta gestual al tapped en una UIImage
        heroAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(heroImageTapped)))
        villainAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(villainImageTapped)))
        
        /// Damos formato a las UIImageViews
        heroAvatar.layer.masksToBounds = true
        heroAvatar.layer.borderWidth = 3
        heroAvatar.layer.borderColor = UIColor.blue.cgColor
        heroAvatar.layer.cornerRadius = 16.0
        villainAvatar.layer.masksToBounds = true
        villainAvatar.layer.borderWidth = 3
        villainAvatar.layer.borderColor = UIColor.red.cgColor
        villainAvatar.layer.cornerRadius = 16.0
        battleName.text = caBattle
    }
    
    /// Decidimos el ganador del combate y devolvemos su ID
    func computeCombat() -> Int16? {
        /// Se mantienen los WARNING para controlar que no haya seleccionado heroe o villano
        guard let heroRandom = Int16("\(arc4random_uniform(10))"),
              let heroPower = hero?.power,
              let villainRandom = Int16("\(arc4random_uniform(10))"),
              let villainPower = villain?.power else {
            return nil
        }
        /// Si hay empate gana el Avenger, que para eso son los buenos
        return (villainRandom + villainPower) <= (heroRandom + heroPower) ? hero?.heroID : villain?.villainID
    }
}


// MARK: Delegate

extension NewBattleViewController: CharacterForBattleDelegate {
    /// Transformamos el Any heroe o villano a su tipo para configurar la UI
    func characterForBattleSelected(character: Any) {
        switch character {
        case let hero as Heroes:
            self.hero = hero
            heroAvatar.image = UIImage(named: hero.avatar ?? "AppIcon")
            heroAvatar.alpha = 1
            heroAvatar.contentMode = .scaleAspectFill
            
        case let villain as Villains:
            self.villain = villain
            villainAvatar.image = UIImage(named: villain.avatar ?? "AppIcon")
            villainAvatar.alpha = 1
            villainAvatar.contentMode = .scaleAspectFill
        
        default:
            break
        }
    }
}
