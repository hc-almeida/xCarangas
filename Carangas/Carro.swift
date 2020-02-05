//
//  Carro.swift
//  Carangas
//
//  Created by Hellen Caroline on 04/02/20.
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import Foundation

class Carro: Codable {
    
    var _id: String?
    var brand: String = ""
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0.0
    var gas: String {
        
        switch gasType {
        case 0:
            return "flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}
