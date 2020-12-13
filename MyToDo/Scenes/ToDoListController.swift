//
//  ToDoListController.swift
//  MyToDo
//
//  Created by MacBook on 12/13/20.
//  Copyright © 2020 Lazar Popovic. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListController: UITableViewController {

  private var items: Results<ToDoItem>?
  private var itemsToken: NotificationToken?

  // MARK: - ViewController life-cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.items = ToDoItem.all()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.itemsToken = items?.observe({ [ weak tableView] changes in
      guard let tableView = tableView else { return }
      
      switch changes {
      case .initial:
        tableView.reloadData()
        
      case .update(_ ,  let deletions, let insertions, let updates):
        tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
        
      case .error:
        break
      }
    })

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    self.itemsToken?.invalidate()
  }

  // MARK: - Actions

  @IBAction func addItem() {
    userInputAlert("Add Todo Item") { (text) in
      ToDoItem.add(text: text)
    }
  }
  
  func toggleItem(_ item: ToDoItem) {
    item.toggleCompleted()
  }
  
  func deleteItem(_ item: ToDoItem) {
    if item.isCompleted == true {
      item.delete()
    } else {
      userAlert("Task is not completed!")
    }
    
  }
  
  func editTextItem(_ item: ToDoItem) {
    userInputAlert("Edit Todo Item Text") { (text) in
      item.editText(text)
    }
  }
  
}

// MARK: - Table View Data Source

extension ToDoListController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ToDoTableViewCell,
          let item = items?[indexPath.row] else {
        return ToDoTableViewCell(frame: .zero)
    }

    cell.configureWith(item) { [weak self] item in
      self?.toggleItem(item)
    }
    
    return cell
  }
}

// MARK: - Table View Delegate

extension ToDoListController {
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard let item = items?[indexPath.row],
          editingStyle == .delete else { return }
    self.deleteItem(item)

  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let item = items?[indexPath.row] else { return }
    self.editTextItem(item)
    
  }
}
