/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
