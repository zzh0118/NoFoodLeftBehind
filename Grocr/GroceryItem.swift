import Foundation
import Firebase

struct GroceryItem {
  
  let key: String
  let name: String
  let addedByUser: String
  let ref: DatabaseReference?
  let location: String
  var completed: Bool
  
  init(name: String, addedByUser: String, location: String, completed: Bool, key: String = "") {
    self.key = key
    self.name = name
    self.addedByUser = addedByUser
    self.location = location
    self.completed = completed
    self.ref = nil
  }
  
  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    name = snapshotValue["name"] as! String
    addedByUser = snapshotValue["addedByUser"] as! String
    location = snapshotValue["location"] as! String
    completed = snapshotValue["completed"] as! Bool
    ref = snapshot.ref
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
      "addedByUser": addedByUser,
      "location" : location,
      "completed": completed
    ]
  }
  
}
