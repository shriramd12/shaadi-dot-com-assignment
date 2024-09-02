//
//  ProfileCardListViewModel.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import CoreData
import SwiftUI

class ProfileCardListViewModel: ObservableObject {
    @Published var profileCards: [ProfileCard] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var showToast: Bool = false


    let profileNetworkService: ProfileNetworkService
    let profileCoreDataService: ProfileCoreDataService

    init(networkService: NetworkServiceProtocol,
         viewContext: NSManagedObjectContext) {
        self.profileNetworkService = ProfileNetworkService(networkService: networkService)
        self.profileCoreDataService = ProfileCoreDataService(viewContext: viewContext)
    }

    func fetchProfiles() {
        profileCards = profileCoreDataService.fetchProfilesLocally()
        errorMessage = ""

        if profileCards.isEmpty {
            isLoading = true
        }

        profileNetworkService.fetchProfiles { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let profiles):
                    let oldProfileCards = weakSelf.profileCards
                    weakSelf.profileCards = profiles.map({ ProfileCard(
                        fullName: $0.fullName(),
                        address: $0.address(),
                        imageUrl: $0.picture.large,
                        isAccepted: nil,
                        email: $0.email
                    )})
                    weakSelf.profileCards.append(contentsOf: oldProfileCards)
                    weakSelf.profileCoreDataService.saveProfileCards(weakSelf.profileCards)
                case .failure(let error):
                    weakSelf.errorMessage = error.localizedDescription
                    self?.showToast = true  // Trigger the toast
                }
            }
        }
    }

    func update(isAccepted: Bool, for profile: ProfileCard) {
        if let indexOfProfile = profileCards.firstIndex(where: { $0 == profile }) {
            profileCards[indexOfProfile].isAccepted = isAccepted
            profileCoreDataService.saveProfileCards(profileCards)
        }
    }
}


