//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Yani Buchkov on 28.05.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    // MARK: - Properties
    private let kCellReuseIdentifire = "Cell"
    private let rowHeight: CGFloat = 80.0

    // MARK: - SwipeTableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() // for empty
    }
    
    // MARK: - Public: Methods for overriding
    func updateModel(at indexPath: IndexPath) {
        // Update data model
        print("Model to delete in child class")
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateModel(at: indexPath)
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
    
    // MARK: - DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifire, for: indexPath) as? SwipeTableViewCell {
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
}
