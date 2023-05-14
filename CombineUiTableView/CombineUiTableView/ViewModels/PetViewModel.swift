//
//  PetViewModel.swift
//  CombineUiTableView
//
//  Created by Sachin Daingade on 14/05/23.
//

import Foundation
import Combine

class PetViewModel: ObservableObject {
    private var cancallables = Set<AnyCancellable>()
    @Published public private(set) var arrOfPets = PassthroughSubject<PetsModel, Never>()
    public enum Input {
        case getPets
    }
    @Published public var input: Input?

    init() {
        $input.compactMap{$0}.sink{ [unowned self] action in
            switch action {
            case .getPets:
                PetNetworkHelper.getAllPetsList {[unowned self] result in
                    switch result {
                    case .success(let allPets):
                        DispatchQueue.main.async { [unowned self] in
                            self.arrOfPets.send(allPets)
                            debugPrint("View Model Data Receievd: \(allPets.pets)")
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                }            }
        } .store(in: &cancallables)
    }
    
    
    
    
    deinit {
        cancallables.forEach{$0.cancel()}
    }
}
