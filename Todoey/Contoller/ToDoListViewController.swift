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
    // create plist to save data in this path
     let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
          loadItemsFromPlist()
        
       
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
        // her we reflect changes on done property on array
        let item = itemList[indexPath.row]
        // so to reflects these changes to cerated items.plist
           saveItem()
     
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
            
          self.saveItem()
            
            
            //tableView.reloadData()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Item Name"
             textField=alertTextField
        }
        
        alert.addAction(alertAction)
        
        
        present(alert,animated: true,completion: nil)
       
        
    }
    // MARK - Model Manipulation Methods
    func saveItem()  {
        // first encode data : note ensure that data inhirit from Coadble [encodable,decodable]
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemList)
            // then write data that have encoded to specified path
            try data.write(to:filePath!)
        }
        catch{
            print("error:\(error)")
        }
        
        
        //tableView.reloadData()
        
        
    }
    func loadItemsFromPlist() {
        if let data =  try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            // fill array after decoding data
            do{
                itemList = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error\(error)")
            }
            
        }
    }
    
}

