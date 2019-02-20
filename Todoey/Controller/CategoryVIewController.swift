//
//  CategoryVIewController.swift
//  Todoey
//
//  Created by Mohammad Peighami on 12/1/1397 AP.
//  Copyright © 1397 Mohammad Peighami. All rights reserved.
//

import UIKit
import CoreData

class CategoryVIewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoriesArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        loadCategoriesFromFile()
        tableView.reloadData()
        
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let itemsVC = segue.destination as! TodoListViewControllerTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                itemsVC.selectedCategory = categoriesArray[indexPath.row]
            }
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add New Category", style: .default) { (action) in
            let cat = Category(context: self.context)
            cat.name = textField?.text
            
            self.saveCategoriesToFile()
            self.categoriesArray.append(cat)
            
            let indexPath = IndexPath(row: self.categoriesArray.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .left)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Category Name..."
            textField = textfield
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveCategoriesToFile() {
        do {
            try context.save()
        }
        catch {
            print("Error Saving Categories to File: \(error)")
        }
    }
    
    func loadCategoriesFromFile() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoriesArray = try context.fetch(request)
        }
        catch {
            print("Error Loading Categories from File: \(error)")
        }
    }
    
}
