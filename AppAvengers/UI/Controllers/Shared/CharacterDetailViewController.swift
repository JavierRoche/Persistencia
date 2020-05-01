//
//  CharacterDetailViewController.swift
//  AppAvengers
//
//  Created by APPLE on 27/04/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

/// Protocolo de comunicacion con la ventana principal de lista de heroes
protocol CharacterPowerChangeDelegate: class {
    func reloadAfterPowerChange()
}

class CharacterDetailViewController: UIViewController {
    @IBOutlet weak var characterAvatar: UIImageView!
    @IBOutlet weak var characterPower: UIImageView!
    @IBOutlet weak var battlesCollection: UICollectionView!
    @IBOutlet weak var descLabel: UILabel!
    
    /// Puede llegar un heroe o un villano. Lo recibimos como Any
    private var character: Any?
    /// Nuestra lista de batallas que se recuperan de BBDD
    private var battles: [Battles] = []
    /// El DataProvider para acceder a la clase que abstrae de la BBDD
    private var dataProvider: DataProvider = DataProvider()
    /// El delegado para poder llamar al protocolo y que se actualizen las ventanas
    weak var delegate: CharacterPowerChangeDelegate?
    
    convenience init(character: Any) {
        self.init(nibName: String(describing: CharacterDetailViewController.self), bundle: nil)
        self.character = character
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        battlesCollection.delegate = self
        battlesCollection.dataSource = self
        
        /// Registramos en nuestro UIColectionView el tipo de celda que acepta
        let nib = UINib.init(nibName: String(describing: BattlesCollectionViewCell.self), bundle: nil)
        battlesCollection.register(nib, forCellWithReuseIdentifier: String(describing: BattlesCollectionViewCell.self))
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch character {
        case let hero as Heroes:
            battles = dataProvider.loadBattles(characterID: hero.heroID)
        case let villain as Villains:
            battles = dataProvider.loadBattles(characterID: villain.villainID)
        default :
            break
        }
        
        battlesCollection.reloadData()
    }
    
    
    // MARK: IBActions
    
    /// Recoge el evento de pulsado del boton de edicion del poder
    @IBAction func editPower(_ sender: Any) {
        let editPowerView: PowerChangeViewController = PowerChangeViewController.init(character: self.character)
        /// SIempre hay que indicarle quien sera delegado de los eventos
        editPowerView.delegate = self
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(editPowerView, animated: true, completion: nil)
    }
    
    
    // MARK: Functions
    
    /// Segun el tipo de personaje configuramos su UI, y recuperamos SUS batallas
    func configureUI() {
        switch character {
        case let hero as Heroes:
            self.title = hero.name
            characterAvatar.image = UIImage(named: hero.avatar ?? "AppIcon")
            characterPower.image = UIImage(named: "Stars\(hero.power)Icon")
            descLabel.text = hero.desc
            battlesCollection.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
            view.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
            
        case let villain as Villains:
            self.title = villain.name
            characterAvatar.image = UIImage(named: villain.avatar ?? "AppIcon")
            characterPower.image = UIImage(named: "Stars\(villain.power)Icon")
            descLabel.text = villain.desc
            battlesCollection.backgroundColor = UIColor.init(red: 255/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
            view.backgroundColor = UIColor.init(red: 255/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
            
        default :
            break
        }
    }
}


// MARK: UICollectionView Delegate

extension CharacterDetailViewController: UICollectionViewDelegate, PowerChangedDelegate {
    /// Funcion delegada del protocolo de la ventana de detalle para que recarguemos el detalle del power y avisar a la lista principal para que tambien repinte
    func powerChanged(power: Int16) {
        self.characterPower.image = UIImage(named: "Stars\(power)Icon")
        delegate?.reloadAfterPowerChange()
    }
    
    /// Seleccion de un item en el UICollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let battleDetail: BattleDetailViewController = BattleDetailViewController.init(battle: battles[indexPath.row])
        self.navigationController?.pushViewController(battleDetail, animated: true)
    }
}


// MARK: UICollectionView DataSource

extension CharacterDetailViewController: UICollectionViewDataSource {
    /// El UICollectionView tiene tantos items como batallas tenga el personaje del detalle
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return battles.count
    }
    
    /// Funcion delegada para el rellenado de las celdas
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = battlesCollection.dequeueReusableCell(withReuseIdentifier: String(describing: BattlesCollectionViewCell.self), for: indexPath) as? BattlesCollectionViewCell {
            /// Configuramos cada item del UICollectionView con las batallas del heroe o del villano
            switch character {
            case let hero as Heroes:
                if battles[indexPath.row].heroID == hero.heroID {
                    cell.configureCell(battle: battles[indexPath.row], characterID: hero.heroID)
                }
                
            case let villain as Villains:
                if battles[indexPath.row].villainID == villain.villainID {
                    cell.configureCell(battle: battles[indexPath.row], characterID: villain.villainID)
                }
                
            default :
                break
            }
            cell.setNeedsLayout()
            return cell
        }
        fatalError("Cells couldn't be created")
    }
}

