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

    private var viewModel = PetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Test"
        
        self.viewModel.$arrOfPets.sink { status in
            debugPrint(status)
        } receiveValue: { result in
            debugPrint(result)
        }

          
    }

  
    
    override func viewDidDisappear(_ animated: Bool) {
        cancallables.forEach{$0.cancel()}

    }
    
    @IBAction func buttonGetDataAction(_ sender: Any) {
        viewModel.input = .getPets
        
    }
}



