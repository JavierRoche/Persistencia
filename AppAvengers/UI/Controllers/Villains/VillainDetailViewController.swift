//
//  VillainDetailViewController.swift
//  AppAvengers
//
//  Created by APPLE on 25/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

/// Protocolo de comunicacion con la ventana principal de lista de heroes
protocol VillainDetailViewControllerDelegate: class {
    func reloadVillainsTable()
}

class VillainDetailViewController: UIViewController {
    @IBOutlet weak var villainAvatar: UIImageView!
    @IBOutlet weak var villainPower: UIImageView!
    @IBOutlet weak var editPower: UIButton!
    
    private var villain: Villains?
    /// El delegado para poder llamar al protocolo y que se actualizen las ventanas
    weak var delegate: VillainDetailViewControllerDelegate?
    
    convenience init(villain: Villains) {
        self.init(nibName: String(describing: VillainDetailViewController.self), bundle: nil)
        self.villain = villain
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = villain?.name
        self.villainAvatar.image = UIImage(named: villain?.avatar ?? "AppIcon")
        self.villainPower.image = UIImage(named: "Stars\(villain?.power ?? 0)Icon")
    }
    

    // MARK: IBActions
    
    @IBAction func editPower(_ sender: Any) {
        let editPowerView: PowerChangeViewController = PowerChangeViewController.init(character: self.villain)
        /// SIempre hay que indicarle quien sera delegado de los eventos
        editPowerView.delegate = self
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(editPowerView, animated: true, completion: nil)
    }
}


// MARK: Delegate

extension VillainDetailViewController: PowerChangeViewControllerDelegate {
    /// Funcion delegada del protocolo de la ventana de detalle para que recarguemos la lista tras un cambio de poder
    func powerChanged(power: Int16) {
        self.villainPower.image = UIImage(named: "Stars\(power)Icon")
        delegate?.reloadVillainsTable()
    }
}
