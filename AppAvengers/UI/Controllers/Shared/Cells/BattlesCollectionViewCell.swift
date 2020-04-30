//
//  BattlesCollectionViewCell.swift
//  AppAvengers
//
//  Created by APPLE on 29/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class BattlesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var battleLabel: UILabel!
    
    private let caBattle: String = "Battle"
    
    // MARK: - Lifecycle methods
    
    /// Se llama solo la primera vez que se crean las celdas
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Añadimos un borde a la celda
        self.layer.cornerRadius = 6.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.7
    }
    
    func configureCell(battle: Battles, characterID: Int16) {
        battleLabel.text = "\(caBattle) \(battle.battleID)"
        if battle.winnerID == characterID {
            battleLabel.backgroundColor = UIColor.init(red: 153/255.0, green: 175/255.0, blue: 246/255.0, alpha: 1.0)
        } else {
            battleLabel.backgroundColor = UIColor.init(red: 246/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        }
    }
}

