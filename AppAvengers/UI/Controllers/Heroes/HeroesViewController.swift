//
//  HeroesViewController.swift
//  AppAvengers
//
//  Created by APPLE on 23/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

/// Protocolo de comunicacion para informar la seleccion de heroe y villano para un combate
protocol CharacterForBattleDelegate: class {
    func characterForBattleSelected(character: Any)
}

class HeroesViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    /// Nuestra lista de heroes que se recuperan de BBDD
    private var heroes: [Heroes] = []
    /// El uso de la vista para seleccion de personaje para batallas
    private var useOfView: Bool = false
    private let caAvengers: String = "Avengers"
    /// El delegado para poder llamar al protocolo y que se actualizen las ventanas
    weak var delegate: CharacterForBattleDelegate?
    /// El DataProvider para acceder a la clase que abstrae de la BBDD
    private var dataProvider: DataProvider = DataProvider()
    
    convenience init(selection: Bool?) {
        self.init(nibName: String(describing: HeroesViewController.self), bundle: nil)
        /// Configuramos el uso de la vista
        guard let selectionTable: Bool = selection else {
            useOfView = false
            return
        }
        useOfView = selectionTable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = caAvengers
        table.delegate = self
        table.dataSource = self
        
        /// Registramos en nuestra tabla el tipo de celda que acepta
        let nib = UINib.init(nibName: String(describing: CharacterTableViewCell.self), bundle: nil)
        table.register(nib, forCellReuseIdentifier: String(describing: CharacterTableViewCell.self))
       
        /// Cargamos nuestra [Heroes] mediante nuestra clase DataProvider
        heroes = dataProvider.loadHeroes(heroID: nil)
    }
}


// MARK: UITableView Delegate

extension HeroesViewController: UITableViewDelegate, CharacterDetailViewControllerDelegate {
    /// Funcion delegada del protocolo de la ventana de detalle para que recarguemos la lista tras un cambio de poder
    func reloadCharactersTable() {
        table.reloadData()
    }
    
    /// Funcion delegada de UITableViewDelegate para altura de celda
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }

    /// Funcion delegada de UITableViewDelegate para seleccion de celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if useOfView {
            /// Cuando se usa el UIView para seleccionar un personaje para batalla avisamos a la vista llamante del seleccionado
            delegate?.characterForBattleSelected(character: heroes[indexPath.row])
            dismiss(animated: true, completion: nil)
            
        } else {
            /// Cuando se usa el UIView para acceder al detalle de un personaje lanzamos la vista de detalle
            let hero: CharacterDetailViewController = CharacterDetailViewController.init(character: heroes[indexPath.row])
            hero.delegate = self
            self.navigationController?.pushViewController(hero, animated: true)
            table.deselectRow(at: indexPath, animated: true)
        }
    }
}


// MARK: UITableView DataSource

extension HeroesViewController: UITableViewDataSource {
    /// La tabla tiene tantas filas como heroes cargados tengamos
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    /// Configuracion de cada celda creada pasandole cada heroe de nuestra lista
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath) as? CharacterTableViewCell {
            cell.configureCell(character: heroes[indexPath.row])
            return cell
        }
        fatalError("Cells couldn't be created")
    }
}
