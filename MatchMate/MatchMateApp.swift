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
    let networkService = NetworkService.shared

    var body: some Scene {
        WindowGroup {
            ProfileCardList(
                networkService: networkService,
                viewContext: persistenceController.container.viewContext
            )
                
        }
    }
}
