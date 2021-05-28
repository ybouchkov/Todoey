//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Yani Buchkov on 27.05.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    // MARK: - IBOutlets & Properties
    private var categories: Results<Category>?
    
    // MARK: - Realm
    private let realm = try! Realm()
    
    private let kCategoryCellReuseIdentifier = "CategoryCell"
    private let kSegueIdentifier = "goToItems"
    
    // MARK: - CategoryTableViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreCategories()
    }
    
    // MARK: - Private
    private func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error in saving Category: \(error)")
        }
        tableView.reloadData()
    }
    
    private func restoreCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    private func saveCategory(with name: String) {
        let newCategory = Category()
        newCategory.name = name
        save(category: newCategory)
    }
    
    // MARK: - Delete method from Swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let categoryToDelete = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("Error in deleting category: \(error)")
            }
        }
    }
    
    private func deleteCategory(_ category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error in deleting category: \(error)")
        }
//        tableView.reloadData()
    }
    
    // MARK: - IBActions: Private
    @IBAction
    private func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField.init()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category!", style: .default) { [weak self] action in
            guard let strongSelf = self else {
                return
            }
            guard let text = textField.text, !text.isEmpty else {
                print("No category added!")
                return
            }
            strongSelf.saveCategory(with: text)
        }
        alert.addTextField { alertTextFieled in
            alertTextFieled.placeholder = "Create new Category"
            textField = alertTextFieled
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TodoListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let categories = categories {
                    destinationVC.selectedCategory = categories[indexPath.row]
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource & Delegates
extension CategoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories found yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: kSegueIdentifier, sender: self)
    }    
}

