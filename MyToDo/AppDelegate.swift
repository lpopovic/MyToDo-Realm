//
//  AppDelegate.swift
//  MyToDo
//
//  Created by MacBook on 12/13/20.
//  Copyright © 2020 Lazar Popovic. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    SyncManager.shared.logLevel = .off
    initializeRealm()
    
    return true
  }

  private func initializeRealm() {
    let realm = try! Realm()
    guard realm.isEmpty else { return }
    
    try! realm.write {
      realm.add(ToDoItem("Buy Milk"))
      realm.add(ToDoItem("Finish Book"))
      
    }
  }
}
