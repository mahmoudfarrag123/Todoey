//
//  ViewController.swift
//  Todoey
//
//  Created by MAHMOUD on 3/5/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    var itemList:Results<Item>?
    var realm = try! Realm()
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return itemList?.count ?? 1
       
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if let item = itemList?[indexPath.row]{
        cell.textLabel?.text=itemList?[indexPath.row].title
        cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else{
            cell.textLabel?.text="no Items Added"
            
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemList?[indexPath.row]{
            do{
            try realm.write{
                //realm.delete(item)
                item.done = !item.done
            }
            }
            catch{
                print("Error\(error)")
            }
        }
         tableView.beginUpdates()
          tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

    }
    // MARK - Add new Item

    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        var  textField=UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
           
            if  let currentCategory = self.selectedCategory{
               
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title=textField.text!
                        newItem.dateCreated =  Date()
                        //here add this item to list realtion
                        currentCategory.item_relationShip.append(newItem)
                        self.realm.add(newItem)
                    }
                    
                }
                catch{
                    print("error\(error)")
                }
                
                
            }
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

    //note // Item.fetchRequest() after equalsign here is default parameter that if we call loadData() as in veiwdidload without pass parameter Item.fetchRequest() will be parameter
    func loadData(){
        itemList = selectedCategory?.item_relationShip.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}

extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemList = itemList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: false)
        tableView.reloadData()
//        let request:NSFetchRequest<Item>=Item.fetchRequest()
//        //the query in predicate
//         request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        // to sort result using NSdortdiscriptor
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadData(with: request)
//        //tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // tell searchbar not be firstResponder
            }

        }
    }
}
