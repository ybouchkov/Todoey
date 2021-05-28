//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    // MARK: - IBOutlets & Properties
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var itemsArray = [Item]()
    private let reuseIdentifier = "ToDoItemCell"
    private let rowHeight: CGFloat = 55.0
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category? {
        didSet {
//            restoreItemsArray()
        }
    }
    
    // MARK: - User Defaults
    private let defaults = UserDefaults.standard
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    private let kTodoItemListArray = "TodoItemListArray_v1"
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        restoreItemsArray()
    }

    // MARK: - Private:
//    private func restoreItemsArray(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        if let selectedCategory = selectedCategory, let selectedCategoryName = selectedCategory.name {
//            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategoryName)
//            if let addiotionalPredicate = predicate {
//                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addiotionalPredicate])
//            } else {
//                request.predicate = categoryPredicate
//            }
//            do {
//                itemsArray = try context.fetch(request)
//            } catch {
//                print("Error fetching data from contex: \(context)")
//            }
//        }
//        tableView.reloadData()
//    }
    
//    private func makingInitialFetchRequest() {
//    }
    
//    private func createAndSaveItem(with title: String, done: Bool) {
//        let newItem = Item(context: context)
//        newItem.title = title
//        newItem.done = done
//        newItem.parentCategory = selectedCategory
//        itemsArray.append(newItem)
//        saveItems()
//    }
    
//    private func saveItems() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        }
//        tableView.reloadData()
//    }
    
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
//            strongSelf.createAndSaveItem(with: text, done: false)
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

//        context.delete(itemsArray[indexPath.row])
//        itemsArray.remove(at: indexPath.row)
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
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
