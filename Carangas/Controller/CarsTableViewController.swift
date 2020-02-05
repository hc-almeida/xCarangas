//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {
    
    var carros: [Carro] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Rest.carregaCarros(onComplete: { (carrosAPI) in
            self.carros = carrosAPI
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue" {
            let vc = segue.destination as! CarViewController
            vc.car = carros[tableView.indexPathForSelectedRow!.row]
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carros.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let carro = carros[indexPath.row]
        cell.textLabel?.text = carro.name
        cell.detailTextLabel?.text = carro.brand
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let car = carros[indexPath.row]
            
            Rest.delete(carro: car) { (sucesso) in
                if sucesso {
                    self.carros.remove(at: indexPath.row)
                    DispatchQueue.main.sync {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}
