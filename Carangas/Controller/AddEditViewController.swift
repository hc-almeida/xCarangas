//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var carro: Carro!

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
    }
    
    func update() {
        if carro != nil {
            tfBrand.text = carro.brand
            tfName.text = carro.name
            tfPrice.text = "\(carro.price)"
            scGasType.selectedSegmentIndex = carro.gasType
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        if carro == nil { //criando carro novo
            carro = Carro()
        }
        
        guard let nome = tfName.text else {
            return
        }
        
        guard let marca = tfBrand.text else {
            return
        }
        
        carro.name = nome
        carro.brand = marca
        
        if tfPrice.text!.isEmpty {
            tfPrice.text = "0"
        }
        carro.price = Double(tfPrice.text!)!
        carro.gasType = scGasType.selectedSegmentIndex
        
        if carro._id == nil {
            Rest.save(carro: carro) { (sucess) in
                self.goBack()
            }
        } else {
            Rest.update(carro: carro) { (sucess) in
                self.goBack()
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
