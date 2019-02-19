//
//  TodoListViewControllerTableViewController.swift
//  Todoey
//
//  Created by Mohammad Peighami on 11/30/1397 AP.
//  Copyright © 1397 Mohammad Peighami. All rights reserved.
//

import UIKit

class TodoListViewControllerTableViewController: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemsArray =  [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItemsFromFile()
        
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        self.tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let newItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item()
            item.title = (alertTextField?.text)!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error Encoding ItemsArray: \(error)")
        }
    }
    
    func loadItemsFromFile() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemsArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error Decoding ItemsArray: \(error)")
            }
        }
    }
    
}
