//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Yani Buchkov on 27.05.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    // MARK: - IBOutlets & Properties
    private var categories = [Category]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let kCategoryCellReuseIdentifier = "CategoryCell"
    
    // MARK: - CategoryTableViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreCategories()
    }
    
    // MARK: - Private
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error in saving Category: \(error)")
        }
        tableView.reloadData()
    }
    
    private func restoreCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching Categories from CoreData: \(error)")
        }
        tableView.reloadData()
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
            let newCategory = Category(context: strongSelf.context)
            newCategory.name = text
            strongSelf.categories.append(newCategory)
            strongSelf.saveCategories()
        }
        alert.addTextField { alertTextFieled in
            alertTextFieled.placeholder = "Create new Category"
            textField = alertTextFieled
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource & Delegates
extension CategoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCategoryCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
