//
//  ViewController.swift
//  Todoey
//
//  Created by MAHMOUD on 3/5/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemList = [Item]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let n1=Item()
        n1.title="melk"
        n1.done=false
        itemList.append(n1)
        let n2=Item()
        n2.title="tea"
        n2.done=false
        
        itemList.append(n2)
        let n3=Item()
        n3.title="besc"
        n3.done=false
        itemList.append(n3)
        
       
        //if let items = defaults.array(forKey:"Todolist") as? [String]{
          //  itemList=items
        //}
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text=itemList[indexPath.row].title
         let  item = itemList[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
      
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let item = itemList[indexPath.row]
     
        item.done = !item.done
        //tableView.reloadData()
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

      // to make color of cell flash back of white after selected instead of gray
       tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK - Add new Item

    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        var  textField=UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title=textField.text!
            self.itemList.append(newItem)
            self.defaults.set(self.itemList, forKey: "Todolist")
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

