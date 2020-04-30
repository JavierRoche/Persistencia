//
//  BattleTableViewCell.swift
//  AppAvengers
//
//  Created by APPLE on 27/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class BattleTableViewCell: UITableViewCell {
    @IBOutlet weak var battleName: UILabel!
    @IBOutlet weak var heroAvatar: UIImageView!
    @IBOutlet weak var villainAvatar: UIImageView!
    
    private let caBattle: String = "Battle"
    
    // MARK: - Lifecycle methods
    
    /// Se llama solo la primera vez que se crean las celdas
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Añadimos un borde a la celda
        self.layer.cornerRadius = 4.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.2
    }
    
    /// Limpia los datos de una celda antes de llamar al dequeue para su reuso. Evita errores visuales
    override func prepareForReuse() {
        battleName.text = nil
        heroAvatar.image = nil
        villainAvatar.image = nil
    }
    
    /// Configuracion grafica de la celda
    func configureCell(battle: Battles) {
        battleName.text = "\(caBattle) \(battle.battleID)"
        heroAvatar.image = UIImage(named: battle.hero?.avatar ?? "AppIcon")
        villainAvatar.image = UIImage(named: battle.villain?.avatar ?? "AppIcon")
        heroAvatar.layer.masksToBounds = true
        heroAvatar.layer.borderWidth = 4
        heroAvatar.layer.cornerRadius = 16.0
        villainAvatar.layer.masksToBounds = true
        villainAvatar.layer.borderWidth = 4
        villainAvatar.layer.cornerRadius = 16.0
        
        /// Bordeamos el avatar de azul o rojo segun el ganador o perdedor
        switch battle.winnerID {
        case battle.hero?.heroID:
            heroAvatar.layer.borderColor = UIColor.blue.cgColor
            villainAvatar.layer.borderColor = UIColor.red.cgColor
            
        case battle.villain?.villainID:
            heroAvatar.layer.borderColor = UIColor.red.cgColor
            villainAvatar.layer.borderColor = UIColor.blue.cgColor
            
        default:
            break
        }
    }
}
