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
    private let output: PassthroughSubject<Output, Never> = .init()
    //@Published var arrPets = CurrentValueSubject<[Pet], Never>([])
    @Published private(set) var arrayOfPets = [Pet]()
    
    public enum Input {
        case getPets
    }
    
    enum Output {
      case fetchApiDataDidFail(error: Error)
      case fetchApiDataDidSucceed(petsModel: PetsModel)
    }
    
    @Published public var input: Input?
    
    init() {
        $input.compactMap{$0}.sink{ [unowned self] action in
            switch action {
            case .getPets:
                do { self.getAllPets() }
            }
        }.store(in: &cancallables)
    }

    private func getAllPets() -> Void {
        PetNetworkHelper.getAllPetsList {[unowned self] result in
            switch result {
            case .success(let allPets):
                DispatchQueue.main.async { [unowned self] in
                    self.output.send(.fetchApiDataDidSucceed(petsModel: allPets))
                    debugPrint("View Model Data Receievd: \(allPets.pets)")
                   // arrPets.send(allPets.pets)
                    self.arrayOfPets = allPets.pets
                }
            case .failure(let error):
                self.output.send(.fetchApiDataDidFail(error: error))
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    
    deinit {
        debugPrint(" viewModel's deinit called")
        cancallables.forEach{$0.cancel()}
    }
}
