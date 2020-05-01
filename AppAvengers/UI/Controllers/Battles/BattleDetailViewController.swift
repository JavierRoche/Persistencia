//
//  BattleDetailViewController.swift
//  AppAvengers
//
//  Created by APPLE on 30/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class BattleDetailViewController: UIViewController {
    @IBOutlet weak var battleName: UILabel!
    @IBOutlet weak var heroAvatar: UIImageView!
    @IBOutlet weak var villainAvatar: UIImageView!
    @IBOutlet weak var deleteBattleButton: UIButton!
    
    /// Nuestra lista de batallas que se recuperan de BBDD
    private var battle: Battles?
    private let caBattle: String = "Battle"
    /// El DataProvider para acceder a la clase que abstrae de la BBDD
    private var dataProvider: DataProvider = DataProvider()
    
    convenience init(battle: Battles) {
        self.init(nibName: String(describing: BattleDetailViewController.self), bundle: nil)
        self.battle = battle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: IBActions
    
    @IBAction func deleteBattleTapped(_ sender: Any) {
        guard let battle: Battles = self.battle else {
            return
        }
        dataProvider.deleteBattles(battles: [battle])
        
        deleteBattleButton.isEnabled = false
        deleteBattleButton.setBackgroundImage(UIImage.init(systemName: "trash.slash.fill"), for: .normal)
        showAlert(title: "Success", message: "Combat deleted")
    }
    
    
    // MARK: Functions
    
    func configureUI() {
        let hero: Heroes? = dataProvider.loadHeroes(heroID: battle?.heroID).first
        let villain: Villains? = dataProvider.loadVillains(villainID: battle?.villainID).first

        battleName.text = "\(caBattle) \(battle?.battleID ?? 0)"
        heroAvatar.image = UIImage(named: hero?.avatar ?? "AppIcon")
        villainAvatar.image = UIImage(named: villain?.avatar ?? "AppIcon")
        
        /// Damos formato a las UIImageViews
        heroAvatar.layer.masksToBounds = true
        heroAvatar.layer.borderWidth = 3
        heroAvatar.layer.cornerRadius = 16.0
        villainAvatar.layer.masksToBounds = true
        villainAvatar.layer.borderWidth = 3
        villainAvatar.layer.cornerRadius = 16.0
        view.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
        
        /// Bordeamos el avatar de azul o rojo segun el ganador o perdedor
        switch battle?.winnerID {
        case battle?.hero?.heroID:
            heroAvatar.layer.borderColor = UIColor.blue.cgColor
            villainAvatar.layer.borderColor = UIColor.red.cgColor
            
        case battle?.villain?.villainID:
            heroAvatar.layer.borderColor = UIColor.red.cgColor
            villainAvatar.layer.borderColor = UIColor.blue.cgColor
            
        default:
            break
        }
    }
}
