//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    // MARK: - IBOutlets & Properties
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let realm = try! Realm()
    
    private var todoItems: Results<Item>?
    private let reuseIdentifier = "Cell"
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }

    // MARK: - Private:
    private func setupNavigationController() {
        if let colorHex = selectedCategory?.hexColor, let bigTitleName = selectedCategory?.name {
            title = bigTitleName
            guard let navBar = navigationController?.navigationBar else { return }
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.backgroundColor = navBarColor
                navBar.tintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                searchBar.barTintColor = navBarColor
            }
        }
    }
    
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
                    newItem.dateCreated = Date()
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
    
    // MARK: - Delete method from Swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let itemToDelete = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Error in deleting item: \(error)")
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row], let selectedCategory = selectedCategory {
            cell.textLabel?.text = item.title
            if let totalItems = todoItems?.count,  let color = UIColor(hexString: selectedCategory.hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(totalItems)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate States Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, !text.isEmpty {
            todoItems = todoItems?.filter("title CONTAINS %@", text).sorted(byKeyPath: "dateCreated", ascending: true)
        } else {
            restoreItemsArray()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        tableView.reloadData()
    }
}
