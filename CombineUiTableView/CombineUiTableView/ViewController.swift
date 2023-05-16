//
//  ViewController.swift
//  CombineUiTableView
//
//  Created by Sachin Daingade on 14/05/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var cancallables = Set<AnyCancellable>()

    @IBOutlet weak var petsTableView: UITableView!
    
    private var viewModel = PetViewModel()
    private let input: PassthroughSubject<PetViewModel.Input, Never> = .init()
    private var arrOfPets = [Pet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Test"
        self.bind()
          
    }

    private func bind() {
      let output = viewModel.transform(input: input.eraseToAnyPublisher())
      output
        .receive(on: DispatchQueue.main)
        .sink { [weak self] event in
        switch event {
        case .fetchApiDataDidFail(error: let error):
            debugPrint(error.localizedDescription)
        case .fetchApiDataDidSucceed(petsModel: let petsModel):
            self?.arrOfPets = petsModel.pets
            DispatchQueue.main.async { [weak self] in
                self?.petsTableView.reloadData()
            }
        }
      }.store(in: &cancallables)
      
    }
  
    
    override func viewDidDisappear(_ animated: Bool) {
        cancallables.forEach{$0.cancel()}
    }
    
    @IBAction func buttonGetDataAction(_ sender: Any) {
        input.send(.getPets)
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfPets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = arrOfPets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = model.title
        
        return cell

    }
    
    
}
