//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MAHMOUD on 3/8/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import UIKit

import RealmSwift
class CategoryTableViewController: UITableViewController {
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
         let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added"
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
    

}


