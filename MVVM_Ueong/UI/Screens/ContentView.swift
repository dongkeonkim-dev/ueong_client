//
//  ContentView.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        
        
        
    }

   
}



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
