//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Yani Buchkov on 27.05.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    // MARK: - IBOutlets & Properties
    private var categories: Results<Category>?
    
    // MARK: - Realm
    private let realm = try! Realm()
    
    private let kCategoryCellReuseIdentifier = "CategoryCell"
    private let kSegueIdentifier = "goToItems"
    
    private let rowHeight: CGFloat = 80.0
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: kCategoryCellReuseIdentifier, for: indexPath) as? SwipeTableViewCell {
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories found yet"
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: kSegueIdentifier, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
}

// MARK: - SwipeCellKit Implementaion
extension CategoryTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            guard let strongSelf = self else {
                return
            }
            // handle action by updating model with deletion
            if let category = strongSelf.categories?[indexPath.row] {
                strongSelf.deleteCategory(category)
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
