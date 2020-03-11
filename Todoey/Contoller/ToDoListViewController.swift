//
//  ViewController.swift
//  Todoey
//
//  Created by MAHMOUD on 3/5/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipTableViewController{
    var itemList:Results<Item>?
    var realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
           title=selectedCategory?.name
            guard let colorhex=selectedCategory?.colour else{ fatalError()}
        
           updateNavBar(withHexcode: colorhex)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexcode: "1D9Bf6")
    }
    // MARK: - Nav Bar setup color
    func updateNavBar(withHexcode colorHexcode:String) {
        guard let navBar = navigationController?.navigationBar else{fatalError()}
        guard let navBarColor=UIColor(hexString: colorHexcode) else{fatalError()}
        navBar.barTintColor = navBarColor
        searchBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return itemList?.count ?? 1
       
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemList?[indexPath.row]{
        cell.textLabel?.text=itemList?[indexPath.row].title
            if let colour=UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat( itemList!.count)){
                cell.backgroundColor = colour
                //chanage color of cell text so we can read it
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
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
    // MARK - Delete Item
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = itemList?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(itemForDeletion)
                    print("item deleted")
                }
            }
            catch{
                
            }
        }
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
