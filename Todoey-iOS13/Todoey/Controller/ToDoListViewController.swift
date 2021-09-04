//
//  ViewController.swift
//  Todoey
//
//  Created by Aryan Gupta on 02/9/2021.

//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

     var itemArray = [Items]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
       loadItems()
    }

  // Mark: - TableViewDataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == false ? .none : .checkmark
        return cell
    }
    
 // Mark: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
     /* Delete Particular Selected Row....
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
      */
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
 // Mark: - Add Items Here
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
        let newItem = Items(context: self.context)
        newItem.title = textField.text!
        newItem.done = false
        self.itemArray.append(newItem)
        self.saveItems()
        print("*** Item Added")
     }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
 // Mark: - Saving and Loading Data
    func saveItems() {
        do {
            try context.save()
        }catch {
            print("*** Error is \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        }catch {
            print("*** Error in loading items \(error)")
        }
    }
    
  
}



