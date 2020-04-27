//
//  CharacterDetailViewController.swift
//  AppAvengers
//
//  Created by APPLE on 27/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

/// Protocolo de comunicacion con la ventana principal de lista de heroes
protocol CharacterDetailViewControllerDelegate: class {
    func reloadCharactersTable()
}

class CharacterDetailViewController: UIViewController {
    @IBOutlet weak var characterAvatar: UIImageView!
    @IBOutlet weak var characterPower: UIImageView!
    
    private var character: Any?
    /// El delegado para poder llamar al protocolo y que se actualizen las ventanas
    weak var delegate: CharacterDetailViewControllerDelegate?
    
    convenience init(character: Any) {
        self.init(nibName: String(describing: CharacterDetailViewController.self), bundle: nil)
        self.character = character
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch character {
        case let hero as Heroes:
            self.title = hero.name
            self.characterAvatar.image = UIImage(named: hero.avatar ?? "AppIcon")
            self.characterPower.image = UIImage(named: "Stars\(hero.power)Icon")
            
        case let villain as Villains:
            self.title = villain.name
            self.characterAvatar.image = UIImage(named: villain.avatar ?? "AppIcon")
            self.characterPower.image = UIImage(named: "Stars\(villain.power)Icon")
            
        default :
            print("Error")
        }
        
    }
    
    
    // MARK: IBActions
    
    @IBAction func editPower(_ sender: Any) {
        let editPowerView: PowerChangeViewController = PowerChangeViewController.init(character: self.character)
        /// SIempre hay que indicarle quien sera delegado de los eventos
        editPowerView.delegate = self
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(editPowerView, animated: true, completion: nil)
    }
}


// MARK: Delegate

extension CharacterDetailViewController: PowerChangeViewControllerDelegate {
    /// Funcion delegada del protocolo de la ventana de detalle para que recarguemos la lista tras un cambio de poder
    func powerChanged(power: Int16) {
        self.characterPower.image = UIImage(named: "Stars\(power)Icon")
        delegate?.reloadCharactersTable()
    }
}

