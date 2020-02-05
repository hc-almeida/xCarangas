//
//  Rest.swift
//  Carangas
//
//  Created by Hellen Caroline on 04/02/20.
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import Foundation

enum ErroCarro {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidoJson
}
enum RestOperacao {
    case save
    case update
    case delete
}

class Rest {
    
    private static let caminhoAPI = "https://carangas.herokuapp.com/cars"
    
    private static let configuracao: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    private static let sessao = URLSession(configuration: configuracao)
    
    class func carregaCarros(onComplete: @escaping ([Carro]) -> Void, onError: @escaping (ErroCarro) -> Void) {
        guard let url = URL(string: caminhoAPI) else {
            onError(.url)
            return
        }
        
        let dataTask = sessao.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                
                if response.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    do {
                        let carros = try JSONDecoder().decode([Carro].self, from: data)
                        onComplete(carros)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidoJson)
                    }
                    
                } else {
                    print("algum status inválido pelo servidor!")
                    onError(.responseStatusCode(code: response.statusCode))
                }
                
            } else {
                onError(.taskError(error: error!))
            }
        }
        dataTask.resume()
    }
    
    class func save(carro: Carro, onComplete: @escaping (Bool) -> Void) {
        aplicaOperacao(carro: carro, operacao: .save, onComplete: onComplete)
    }
    
    class func update(carro: Carro, onComplete: @escaping (Bool) -> Void) {
        aplicaOperacao(carro: carro, operacao: .update, onComplete: onComplete)
    }
    
    class func delete(carro: Carro, onComplete: @escaping (Bool) -> Void) {
        aplicaOperacao(carro: carro, operacao: .delete, onComplete: onComplete)
    }
    
    private class func aplicaOperacao(carro: Carro, operacao: RestOperacao, onComplete: @escaping (Bool) -> Void) {
        let urlString = caminhoAPI + "/" + (carro._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        
        var httpMethod = ""
        var request = URLRequest(url: url)
        
        switch operacao {
            case .save:
                httpMethod = "POST"
            case .update:
                httpMethod = "PUT"
            case .delete:
                httpMethod = "DELETE"
        }
        
        request.httpMethod = httpMethod
        guard let json = try? JSONEncoder().encode(carro) else {
            onComplete(false)
            return
        }
        request.httpBody = json
        
        let dataTask = sessao.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
            } else {
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
