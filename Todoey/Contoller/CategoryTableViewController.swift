//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MAHMOUD on 3/8/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController:SwipTableViewController {
    var categories:Results<Category>?
    let realm = try! Realm()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
       
    

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if empty return 1
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let cat = categories?[indexPath.row]{
            cell.textLabel?.text = cat.name
            guard let catColor = UIColor(hexString: cat.colour) else {fatalError()}
            cell.backgroundColor = catColor
            cell.textLabel?.textColor = ContrastColorOf(catColor, returnFlat: true)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "go_items", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let distinationVC = segue.destination as! ToDoListViewController
        if  let selectedIndexPath = tableView.indexPathForSelectedRow{
           distinationVC.selectedCategory = categories?[selectedIndexPath.row]
        }
    }
   
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
         let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Category Name"
            textField=alertTextField
            
        }
       
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let cat = Category()
            cat.name=textField.text!
            cat.colour = UIColor.randomFlat.hexValue()
            self.saveCategory(cat: cat)
        
          
        }
        alert.addAction(alertAction)
       
        present(alert,animated: true,completion: nil)
    }
    
    func saveCategory(cat:Category){
        do{
            try realm.write{
                realm.add(cat)
                print("save Category sueccess")
                
            }
          
        }
        catch{
            print("error:\(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(){
       categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                    print("cat deleted")
                }
            }
            catch{
                print("error while deleting category:\(error)")
            }
        }
    }
    
    
    

}

// MARK: - swip cell delagte methods
