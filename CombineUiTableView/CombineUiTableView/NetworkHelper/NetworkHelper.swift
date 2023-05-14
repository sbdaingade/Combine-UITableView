//
//  NetworkHelper.swift
//  CombineUiTableView
//
//  Created by Sachin Daingade on 14/05/23.
//

import Foundation
protocol PetsNetworkProtocol {
    static func getAllPetsList(Complition: @escaping(Result<PetsModel,Error>) -> Void)
}


struct PetNetworkHelper: PetsNetworkProtocol {
    static func getAllPetsList(Complition: @escaping (Result<PetsModel, Error>) -> Void) {
        let urlReq = URL(string: "https://api.npoint.io/89bc67a9845e640ae6ce")
        var mainRequest = URLRequest(url: urlReq!)

        let defaultConfiguration = URLSessionConfiguration.default
        defaultConfiguration.waitsForConnectivity = true
        defaultConfiguration.timeoutIntervalForRequest = 300
        let sharedSession = URLSession(configuration: defaultConfiguration)
        mainRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        mainRequest.httpMethod = "GET"
        
        sharedSession.dataTask(with: mainRequest) { rData, response, error in
            
            guard let httpStatus = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(httpStatus) else {
                
                if let httpStatus = (response as? HTTPURLResponse)?.statusCode , httpStatus == 404 {
                    Complition(.failure(CustomError.unknownError))
                    return
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(PetsModel.self, from: rData!)
                Complition(.success(result))
            }  catch let error {
                Complition(.failure(error))
            }
        }.resume()
    }
}
