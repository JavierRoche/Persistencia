//
//  BattleTableViewCell.swift
//  AppAvengers
//
//  Created by APPLE on 27/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class BattleTableViewCell: UITableViewCell {
    
    
    
    
    
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
//        charAvatar.image = nil
//        charName.text = nil
//        charPower.image = nil
    }
}
