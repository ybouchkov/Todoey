//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    // MARK: - IBOutlets & Properties
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let realm = try! Realm()
    
    private var todoItems: Results<Item>?
    private let reuseIdentifier = "ToDoItemCell"
    private let rowHeight: CGFloat = 55.0
    
    var selectedCategory: Category? {
        didSet {
            restoreItemsArray()
        }
    }
    
    private let kTodoItemListArray = "TodoItemListArray_v1"
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        restoreItemsArray()
    }

    // MARK: - Private:
    private func restoreItemsArray() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    private func saveItem(title: String, done: Bool) {
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    let newItem = Item()
                    newItem.title = title
                    newItem.done = done
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("Error Saving new items: \(error)")
            }
        }
        tableView.reloadData()
    }
    
    private func save(item: Item) {
        do {
            try realm.write({
                realm.add(item)
            })
        } catch {
            print("Error in saving Category: \(error)")
        }
        tableView.reloadData()
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
            strongSelf.saveItem(title: text, done: false)
        }
        alert.addTextField { alertTextFieled in
            alertTextFieled.placeholder = "Create new item"
            textField = alertTextFieled
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView Methods
extension TodoListViewController {    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        context.delete(itemsArray[indexPath.row])
//        itemsArray.remove(at: indexPath.row)
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate States Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        if let text = searchBar.text, text.count > 0 {
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
//            // sorting
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            restoreItemsArray(with: request, predicate: predicate)
//        } else {
//            restoreItemsArray()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
    }
}
