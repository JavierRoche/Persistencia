//
//  PowerChangeViewController.swift
//  AppAvengers
//
//  Created by APPLE on 26/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

/// Protocolo de comunicacion con la ventana de detalle
protocol PowerChangeViewControllerDelegate: class {
    func powerChanged(power: Int16)
}

class PowerChangeViewController: UIViewController {
    @IBOutlet weak var sizedView: UIView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    /// Nos permite tener siempre guardado el poder modificado
    private var powerToSave: Int16 = 0
    /// La reutilizacion de la vista nos obliga a recibir Any
    private var character: Any?
    private var hero: Heroes?
    private var villain: Villains?
    /// El DataProvider para acceder a la clase que abstrae de la BBDD
    private var dataProvider = DataProvider()
    /// El delegado para poder llamar al protocolo y que se actualize la ventana de detalle y se recargue la lista
    weak var delegate: PowerChangeViewControllerDelegate?
    
    convenience init(character: Any?) {
        self.init(nibName: String(describing: PowerChangeViewController.self), bundle: nil)
        self.character = character
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Añadimos un borde a la celda
        sizedView.layer.cornerRadius = 8.0
        sizedView.layer.shadowColor = UIColor.gray.cgColor
        sizedView.layer.shadowOffset = CGSize.zero
        sizedView.layer.shadowRadius = 8.0
        sizedView.layer.shadowOpacity = 0.6
    }
    
    
    // MARK: IBActions
    
    @IBAction func star1Tapped(_ sender: Any) {
        powerToSave = 1
        star1.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star2.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        star3.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        star4.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        star5.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func star2Tapped(_ sender: Any) {
        powerToSave = 2
        star1.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star2.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star3.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        star4.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        star5.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func star3Tapped(_ sender: Any) {
        powerToSave = 3
        star1.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star2.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star3.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star4.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        star5.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func star4Tapped(_ sender: Any) {
        powerToSave = 4
        star1.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star2.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star3.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star4.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star5.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func star5Tapped(_ sender: Any) {
        powerToSave = 5
        star1.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star2.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star3.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star4.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        star5.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    /// Cerramos la ventana
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        /// Cerramos la ventana y actualizamos el objeto en BBDD
        dismiss(animated: true, completion: nil)
        
        /// Primero recuperamos el objeto Heroes/Villano que necesitamos modificar
        switch character {
        case let hero as Heroes:
            self.hero = dataProvider.loadHeroes(heroID: hero.heroID).first
            /// Modificamos el valor del power
            self.hero?.power = powerToSave
            
        case let villain as Villains:
            self.villain = dataProvider.loadVillains(villainID: villain.villainID).first
            /// Modificamos el valor del power
            self.villain?.power = powerToSave
            
        default:
            break
        }
        
        /// Persistimos los cambios
        dataProvider.saveData()
        /// Informamos a la ventana de detalle para que repinte. Ésta, a su vez, informara a la principal
        delegate?.powerChanged(power: powerToSave)
    }
}

