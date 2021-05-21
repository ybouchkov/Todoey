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
    private var itemsArray = [String]()
    private let reuseIdentifier = "ToDoItemCell"
    private let rowHeight: CGFloat = 50.0
    
    // MARK: - User Defaults
    private let defaults = UserDefaults.standard
    private let kTodoItemListArray = "TodoItemListArray"
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreItemsArray()
    }

    // MARK: - Private:
    private func restoreItemsArray() {
        if let items = defaults.array(forKey: kTodoItemListArray) as? [String] {
            itemsArray = items
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

            strongSelf.itemsArray.append(text)
            strongSelf.saveItem(items: strongSelf.itemsArray)
            strongSelf.tableView.reloadData()
        }
        alert.addTextField { alertTextFieled in
            alertTextFieled.placeholder = "Create new item"
            textField = alertTextFieled
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveItem(items: [String]) {
        defaults.set(items, forKey: kTodoItemListArray)
    }
}

// MARK: - TableView Methods
extension TodoListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
