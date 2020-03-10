//
//  ViewController.swift
//  Todoey
//
//  Created by MAHMOUD on 3/5/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import UIKit
import  CoreData

class ToDoListViewController: UITableViewController{
    var itemList = [Item]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          //loadData()
        
       
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
        
         saveItem()
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
            
            let newItem = Item(context:self.context)
            newItem.title=textField.text!
            newItem.done = false
            newItem.parentCategory_relation = self.selectedCategory
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
       
        do{
             try context.save()
        }
        catch{
            print("error saving contetx:\(error)")
        }
        
        
        //tableView.reloadData()
        
        
    }
    //note // Item.fetchRequest() after equalsign here is default parameter that if we call loadData() as in veiwdidload without pass parameter Item.fetchRequest() will be parameter
    func loadData(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate?=nil) {
         let CategoryPredicate = NSPredicate(format: "parentCategory_relation.name MATCHES %@", selectedCategory!.name!)
        if let searchPredicate = predicate{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate,searchPredicate])
            request.predicate = compoundPredicate
        }
        else{
            request.predicate = CategoryPredicate
        }
        do{
             itemList = try context.fetch(request)
        }
        catch{
            print("Error while Fetching data :\(error)")
        }
        tableView.reloadData()
    }
}

extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        //the query in predicate
         request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // to sort result using NSdortdiscriptor
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request)
        //tableView.reloadData()
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
