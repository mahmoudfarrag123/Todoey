//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MAHMOUD on 3/8/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {
  var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "go_items", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let distinationVC = segue.destination as! ToDoListViewController
        if  let selectedIndexPath = tableView.indexPathForSelectedRow{
            distinationVC.selectedCategory = categories[selectedIndexPath.row]
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
            let cat = Category(context: self.context)
            cat.name=textField.text!
            self.categories.append(cat)
            self.saveCategory()
        
          
        }
        alert.addAction(alertAction)
       
        present(alert,animated: true,completion: nil)
    }
    
    func saveCategory(){
        do{
             try context.save()
            print("save success")
        }
        catch{
            print("error:\(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(){
        let request:NSFetchRequest<Category>=Category.fetchRequest()
        do{
           try categories = context.fetch(request)
        }
        catch{
            print("error\(error)")
        }
        tableView.reloadData()
    }
    

}


