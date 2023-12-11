//
//  ViewController.swift
//  Reciplease
//
//  Created by Kyllian GUILLOT on 07/12/2023.
//

import UIKit
import Alamofire

final class SearchController: UIViewController {
    
    @IBOutlet weak var SearchBarTextField: UITextField!
    @IBOutlet weak var TableView: UITableView!
    
    let CellIdentifier = "IngredientCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TableView.dataSource = self
    }
    
    
    @IBAction func TapAdd(_ sender: Any) {
        guard let input = SearchBarTextField.text else { return }
        Ingredient.shared.add(ingredient: input)
        TableView.reloadData()
    }
    @IBAction func TapClear(_ sender: Any) {
        Ingredient.shared.ListOfIngredients = []
        TableView.reloadData()
    }
    
}

extension SearchController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Ingredient.shared.ListOfIngredients.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? IngredientViewCell else {
            return UITableViewCell()
        }
          
        let ingredient = Ingredient.shared.ListOfIngredients[indexPath.row]
        
        cell.IngredientNameLabel.text = "- " + ingredient

        return cell
    }
}

