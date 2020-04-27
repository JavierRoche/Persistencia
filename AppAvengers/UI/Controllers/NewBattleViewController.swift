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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    
    // MARK: IBActions
    
    @IBAction func runBattleTapped(_ sender: Any) {
    }
    
    @objc private func heroImageTapped(_ sender: UITapGestureRecognizer) {
        print("heroImageTapped")
    }
    
    @objc private func villainImageTapped(_ sender: UITapGestureRecognizer) {
        print("villainImageTapped")
    }
    
    @objc private func closeViewTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
