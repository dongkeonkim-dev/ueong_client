//
//  MVVM_UeongApp.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

@main
struct MVVM_UeongApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
