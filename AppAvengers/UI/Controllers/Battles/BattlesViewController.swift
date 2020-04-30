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
    private let caBattles: String = "Battles"
    /// El DataProvider para acceder a la clase que abstrae de la BBDD
    private var dataProvider: DataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = caBattles
        table.delegate = self
        table.dataSource = self
        
        /// Registramos en nuestra tabla el tipo de celda que acepta
        let nib = UINib.init(nibName: String(describing: BattleTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: String(describing: BattleTableViewCell.self))
        
        /// Cargamos nuestra [Battles] mediante nuestra clase DataProvider
        battles = dataProvider.loadBattles(characterID: nil)
    }
    
    
    // MARK: IBActions
    
    @IBAction func addBattleTapped(_ sender: Any) {
        /// Inicializacmos un UINavigationController con la UIView que se va a mostrar y se presenta
        let newBattle: NewBattleViewController = NewBattleViewController()
        newBattle.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: newBattle)
        navigationController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}


// MARK: UITableView Delegate

extension BattlesViewController: UITableViewDelegate, NewBattleViewControllerDelegate {
    /// Funcion delegada del protocolo de la ventana de nueva batalla para recargar la tabla
    func reloadBattlesTable() {
        /// Cargamos nuestras [Battles] mediante nuestra clase DataProvider tras añadir la nueva
        battles = dataProvider.loadBattles(characterID: nil)
        table.reloadData()
    }
    
    /// Funcion delegada de UITableViewDelegate para altura de celda
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    /// Funcion delegada de UITableViewDelegate para seleccion de celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// TODO
    }
}


// MARK: UITableView DataSource

extension BattlesViewController: UITableViewDataSource {
    /// La tabla tiene tantas filas como batallas cargadas tengamos
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return battles.count
    }
    
    /// Configuracion de cada celda creada pasandole cada batalla de nuestra lista
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: String(describing: BattleTableViewCell.self), for: indexPath) as? BattleTableViewCell {
            cell.configureCell(battle: battles[indexPath.row])
            return cell
        }
        fatalError("Cells couldn't be created")
    }
}
