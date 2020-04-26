//
//  HeroesTableViewCell.swift
//  AppAvengers
//
//  Created by APPLE on 23/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    /// Guarda el nombre exacto de la celda para evitar HARDCODE en el dequeue
    static let cellIdentifier: String = String(describing: CharacterTableViewCell.self)
    
    @IBOutlet weak var charAvatar: UIImageView!
    @IBOutlet weak var charName: UILabel!
    @IBOutlet weak var charPower: UIImageView!
    
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
        charAvatar.image = nil
        charName.text = nil
        charPower.image = nil
    }
    
    func configureCell(character: Any) {
        if let hero = character as? Heroes {
            charAvatar.image = UIImage(named: hero.avatar ?? "AppIcon")
            charName.text = hero.name
            charPower.image = UIImage(named: "Stars\(hero.power)Icon")
        } else {
            if let villain = character as? Villains {
                charAvatar.image = UIImage(named: villain.avatar ?? "AppIcon")
                charName.text = villain.name
                charPower.image = UIImage(named: "Stars\(villain.power)Icon")
            }
        }
    }
}
