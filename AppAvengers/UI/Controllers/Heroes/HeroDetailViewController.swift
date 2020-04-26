//
//  HeroDetailViewController.swift
//  AppAvengers
//
//  Created by APPLE on 24/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

/// Protocolo de comunicacion con la ventana principal de lista de heroes
protocol HeroDetailViewControllerDelegate: class {
    func reloadHeroesTable()
}

class HeroDetailViewController: UIViewController {
    @IBOutlet weak var heroAvatar: UIImageView!
    @IBOutlet weak var heroPower: UIImageView!
    @IBOutlet weak var editPower: UIButton!
    
    private var hero: Heroes?
    /// El delegado para poder llamar al protocolo y que se actualizen las ventanas
    weak var delegate: HeroDetailViewControllerDelegate?
    
    convenience init(hero: Heroes) {
        self.init(nibName: String(describing: HeroDetailViewController.self), bundle: nil)
        self.hero = hero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = hero?.name
        self.heroAvatar.image = UIImage(named: hero?.avatar ?? "AppIcon")
        self.heroPower.image = UIImage(named: "Stars\(hero?.power ?? 0)Icon")
    }
    
    
    // MARK: IBActions
    
    @IBAction func editPower(_ sender: Any) {
        let editPowerView: PowerChangeViewController = PowerChangeViewController.init(character: self.hero)
        /// SIempre hay que indicarle quien sera delegado de los eventos
        editPowerView.delegate = self
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(editPowerView, animated: true, completion: nil)
    }
}


// MARK: Delegate

extension HeroDetailViewController: PowerChangeViewControllerDelegate {
    /// Funcion delegada del protocolo de la ventana de detalle para que recarguemos la lista tras un cambio de poder
    func powerChanged(power: Int16) {
        self.heroPower.image = UIImage(named: "Stars\(power)Icon")
        delegate?.reloadHeroesTable()
    }
}
