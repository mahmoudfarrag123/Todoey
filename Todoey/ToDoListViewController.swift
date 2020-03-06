//
//  ViewController.swift
//  Todoey
//
//  Created by MAHMOUD on 3/5/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
  var itemList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text=itemList[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // to make color of cell flash back of white after selected instead of gray
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    // MARK - Add new Item

    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        var  textField=UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
         
            self.itemList.append(textField.text!)
            self.tableView.reloadData()
            
            
           
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Item Name"
             textField=alertTextField
        }
        
        alert.addAction(alertAction)
        
        
        present(alert,animated: true,completion: nil)
    }
    
}

