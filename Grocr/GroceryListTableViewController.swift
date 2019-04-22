import UIKit
import Firebase

class GroceryListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties 
  var items: [GroceryItem] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  let groceryItemsReference = Database.database().reference(withPath: "grocery-items")
  
  // MARK: UIViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    userCountBarButtonItem = UIBarButtonItem(title: "1",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    user = User(uid: "FakeId", email: "zzh@gwu.edu")
    groceryItemsReference.observe(.value, with: {
    snapshot in
      print(snapshot)
    })
    
//    groceryItemsReference.child("pizza").observe(.value) {
//    snapshot in
//      let values = snapshot.value as! [String: AnyObject]
//      let name = values["name"] as! String
//      let addedBy = values["addedByUser"] as! String
//      let completed = values["completed"] as! Bool
//
//      print("name: \(name)")
//      print("added by: \(addedBy)")
//      print("completed: \(completed)")
//
//
//    }
    
    groceryItemsReference.observe(.value, with: {
      snapshot in
        var newItems: [GroceryItem] = []
        for item in snapshot.children {
          let groceryItem = GroceryItem(snapshot: item as! DataSnapshot)
          newItems.append(groceryItem)
        }
      self.items = newItems
      self.tableView.reloadData()
    })


    
    
    
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let groceryItem = items[indexPath.row]
    
    cell.textLabel?.text = groceryItem.name
    cell.detailTextLabel?.text = "added by: " + groceryItem.addedByUser + "       location: " + groceryItem.location
    toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let groceryItem = items[indexPath.row]
//      groceryItem.ref?.removeValue()
      groceryItem.ref?.setValue(nil)
      items.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    var groceryItem = items[indexPath.row]
    let toggledCompletion = !groceryItem.completed

    toggleClicked(cell, isCompleted: toggledCompletion, name: groceryItem.name, location: groceryItem.location)
    groceryItem.completed = toggledCompletion
    groceryItem.ref?.updateChildValues(["completed" : toggledCompletion])
    
    tableView.reloadData()
  }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = UIColor.black
      cell.detailTextLabel?.textColor = UIColor.black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = UIColor.gray
      cell.detailTextLabel?.textColor = UIColor.gray
    }
  }
  
  func toggleClicked(_ cell: UITableViewCell, isCompleted: Bool, name: String, location: String) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = UIColor.black
      cell.detailTextLabel?.textColor = UIColor.black
      let alert = UIAlertController(title: "Cancel a book", message: "You canceled your book \(name)", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "OK", style: .default)
      alert.addAction(okAction)
      
      present(alert, animated: true, completion: nil)
      
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = UIColor.gray
      cell.detailTextLabel?.textColor = UIColor.gray
      let alert = UIAlertController(title: "Book a food", message: "You successfully booked \(name),  please go to \(location) to pick it up", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "OK", style: .default)
      alert.addAction(okAction)
      
      present(alert, animated: true, completion: nil)
    }
  }
  
  // MARK: Add Item
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Grocery Item",
                                  message: "Add an Item",
                                  preferredStyle: .alert)
    alert.addTextField {
      (textField: UITextField!) -> Void in
      textField.placeholder = "Food's Name"
    }
    alert.addTextField {
      (textField: UITextField!) -> Void in
      textField.placeholder = "Food's Location"
    }
    let foodName = alert.textFields!.first!
    let foodLocation = alert.textFields!.last!
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
                                    let textField = alert.textFields![0]
                                    let groceryItem = GroceryItem(name: foodName.text!,
                                                                  addedByUser: self.user.email,
                                                                  location: foodLocation.text!,
                                                                  completed: false)
                                    self.items.append(groceryItem)
                                    self.tableView.reloadData()
                                    
                                    let groceryItemRef = self.groceryItemsReference.child(foodName.text ?? "Unknown")
                                    let values : [String: Any] = ["name" : textField.text!.lowercased(), "addedByUser": self.user.email, "location": foodLocation.text, "completed": false]
                                    groceryItemRef.setValue(values)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }

  
  @objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
  
}
