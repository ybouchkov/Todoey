//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    // MARK: - IBOutlets & Properties
    private var itemsArray = [Item]()
    private let reuseIdentifier = "ToDoItemCell"
    private let rowHeight: CGFloat = 50.0
    
    // MARK: - User Defaults
    private let defaults = UserDefaults.standard
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    private let kTodoItemListArray = "TodoItemListArray_v1"
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreItemsArray() 
    }

    // MARK: - Private:
    private func restoreItemsArray() {
        if let dataFilePath = dataFilePath, let data = try? Data(contentsOf: dataFilePath) {
            let decoder = PropertyListDecoder()
            do {
                itemsArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error in decoding data: \(error)")
            }
        }
    }
    
    // MARK: - Private: IBActions
    @IBAction
    private func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField.init()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] action in
            guard let strongSelf = self else {
                return
            }
            guard let text = textField.text, !text.isEmpty else {
                print("No item added!")
                return
            }
            let newItem = Item(title: text)
            strongSelf.itemsArray.append(newItem)
            strongSelf.saveItems(items: strongSelf.itemsArray)
        }
        alert.addTextField { alertTextFieled in
            alertTextFieled.placeholder = "Create new item"
            textField = alertTextFieled
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveItems(items: [Item]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            if let dataFilePath = dataFilePath {
                try data.write(to: dataFilePath)
            }
        } catch {
            print("Error encoding item array!, \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: - TableView Methods
extension TodoListViewController {    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        saveItems(items: itemsArray)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
