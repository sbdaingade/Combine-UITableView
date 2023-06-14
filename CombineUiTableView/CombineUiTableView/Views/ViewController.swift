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
    private var arrayOfPets = [Pet]() {
        didSet {
            DispatchQueue.main.async {[unowned self] in
                self.petsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Test"
        self.bindData()
    }
    
    private func bindData() {
            viewModel.$arrayOfPets.map{$0}.assign(to: \.arrayOfPets, on: self).store(in: &cancallables)
    }
    
    @IBAction func buttonGetDataAction(_ sender: Any) {
        viewModel.input = .getPets
    }
    
    deinit {
        cancallables.forEach{$0.cancel()}
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfPets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = arrayOfPets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(newView, animated: true)
    }
}
