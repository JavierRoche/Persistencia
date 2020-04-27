//
//  VillainsViewController.swift
//  AppAvengers
//
//  Created by APPLE on 23/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class VillainsViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    /// Manejaremos el funcionamiento filtrando la lista de actuales, sea esta pra TODO o para DONE. En ALL pueden salir siempre todas
    private var villains: [Villains] = []
    /// El DataProvider para acceder a la clase que abstrae de la BBDD
    private var dataProvider: DataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        /// Le indicamos que esteticamente no pinte las lineas entre celdas si no existen
        table.tableFooterView = UIView()
        
        /// Registramos en nuestra tabla el tipo de celda que acepta
        let nib = UINib.init(nibName: String(describing: CharacterTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: String(describing: CharacterTableViewCell.self))
        
        /// Data Migration
//        dataProvider.runDataMigration()
//        dataProvider.runDeleteMigration()
        
        /// Cargamos nuestra [Heroes] mediante nuestra clase DataProvider
        villains = dataProvider.loadVillains(villainID: nil)
    }
}


// MARK: Delegate

extension VillainsViewController: UITableViewDelegate, CharacterDetailViewControllerDelegate {
    /// Funcion delegada del protocolo de la ventana de detalle para que recarguemos la lista tras un cambio de poder
    func reloadCharactersTable() {
        table.reloadData()
    }
    
    /// Funcion delegada de UITableViewDelegate para seleccion de celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let villainDetail: CharacterDetailViewController = CharacterDetailViewController.init(character: villains[indexPath.row])
        villainDetail.delegate = self
        self.navigationController?.pushViewController(villainDetail, animated: true)
        table.deselectRow(at: indexPath, animated: true)
    }
    
    /// Funcion delegada de UITableViewDelegate para altura de celda
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}


// MARK: DataSource

extension VillainsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return villains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath) as? CharacterTableViewCell {
            cell.configureCell(character: villains[indexPath.row])
            return cell
        }
        fatalError("Cells couldn't be created")
    }
}
