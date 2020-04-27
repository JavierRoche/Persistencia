//
//  BattlesViewController.swift
//  AppAvengers
//
//  Created by APPLE on 23/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class BattlesViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    /// Nuestra lista de batallas que se recuperan de BBDD
    private var battles: [Battles] = []
    /// El DataProvider para acceder a la clase que abstrae de la BBDD
    private var dataProvider: DataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        /// Le indicamos que esteticamente no pinte las lineas entre celdas si no existen
        table.tableFooterView = UIView()
        
        /// Registramos en nuestra tabla el tipo de celda que acepta
        let nib = UINib.init(nibName: String(describing: BattleTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: String(describing: BattleTableViewCell.self))
    }
    
    
    // MARK: IBActions
    
    @IBAction func addBattleTapped(_ sender: Any) {
        /// Inicializacmos un UINavigationController con la UIView que se va a mostrar y se presenta
        let newBattle: NewBattleViewController = NewBattleViewController()
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: newBattle)
        navigationController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}


// MARK: Delegate

extension BattlesViewController: UITableViewDelegate {
    
}


// MARK: DataSource

extension BattlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return battles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
