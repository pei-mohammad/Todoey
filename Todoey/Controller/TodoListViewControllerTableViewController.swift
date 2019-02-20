//
//  TodoListViewControllerTableViewController.swift
//  Todoey
//
//  Created by Mohammad Peighami on 11/30/1397 AP.
//  Copyright © 1397 Mohammad Peighami. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewControllerTableViewController: UITableViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemsArray =  [Item]()
    var selectedCategory: Category? {
        didSet {
            itemsArray = (selectedCategory?.items?.allObjects as! [Item])
            navigationItem.title = selectedCategory?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let view = UIView(frame: CGRect(x: 0, y: searchBar.frame.height, width: tableView.frame.width, height: 5))
        view.backgroundColor = navigationController?.navigationBar.barTintColor
        searchBar.addSubview(view)
        
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let item = itemsArray[indexPath.row]

        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemsArray[indexPath.row])
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        
        saveItemsToFile()

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let newItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = (alertTextField?.text)!
            item.done = false
            self.selectedCategory?.addToItems(item)
            self.itemsArray.append(item)
            
            self.saveItemsToFile()
            
            let indexPath = IndexPath(row: self.itemsArray.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Your New Item..."
            alertTextField = textfield
        }
        alert.addAction(cancelAction)
        alert.addAction(newItemAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data and File Storage Handlers
    
    func saveItemsToFile() {
        do {
            try context.save()
        }
        catch {
            print("Error Saving Context: \(error)")
        }
    }
    
    func loadItemsFromFile(for request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name!)!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemsArray = try context.fetch(request)
        }
        catch {
            print("Error Fetching Items from Context: \(error)")
        }
    }
}




extension TodoListViewControllerTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItemsFromFile(for: request, predicate: titlePredicate)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItemsFromFile()
            tableView.reloadData()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        UIView.animate(withDuration: 0.2) {
            searchBar.frame.size.height += 2
        }
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2) {
            searchBar.frame.size.height -= 2
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        loadItemsFromFile()
        tableView.reloadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
