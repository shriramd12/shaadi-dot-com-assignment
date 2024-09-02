//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import SwiftUI

@main
struct MatchMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ProfileCardList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
