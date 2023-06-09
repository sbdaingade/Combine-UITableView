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
    @Published var arrPets = CurrentValueSubject<[Pet], Never>([])

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
                self.getAllPets()
            }
        }.store(in: &cancallables)
    }
    
//    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
//      input.sink { [weak self] event in
//        switch event {
//        case .getPets:
//          self?.getAllPets()
//        }
//      }.store(in: &cancallables)
//      return output.eraseToAnyPublisher()
//    }
    
    
    private func getAllPets() -> Void {
        PetNetworkHelper.getAllPetsList {[unowned self] result in
            switch result {
            case .success(let allPets):
                DispatchQueue.main.async { [unowned self] in
                    self.output.send(.fetchApiDataDidSucceed(petsModel: allPets))
                    debugPrint("View Model Data Receievd: \(allPets.pets)")
                    arrPets.send(allPets.pets)
                }
            case .failure(let error):
                self.output.send(.fetchApiDataDidFail(error: error))
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    
    deinit {
        cancallables.forEach{$0.cancel()}
    }
}
