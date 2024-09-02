//
//  ProfileCoreDataService.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import Foundation
import CoreData

class ProfileCoreDataService {
    let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveProfileCards(_ profiles: [ProfileCard]) {
        for profile in profiles {
            if let existingUser = fetchProfiles(by: profile.email) {
                updateProfile(existingUser, with: profile)
            } else {
                let newProfile = CDProfileCard(context: viewContext)
                populateProfile(newProfile, with: profile)
            }
        }
         saveContext()
     }

    func fetchProfiles(by email: String) -> CDProfileCard? {
        let request: NSFetchRequest<CDProfileCard> = CDProfileCard.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        request.fetchLimit = 1

        do {
            let users = try viewContext.fetch(request)
            return users.first
        } catch {
            print("Failed to fetch user by email: \(error)")
            return nil
        }
    }

    func populateProfile(_ cdProfile: CDProfileCard, with profile: ProfileCard) {
        cdProfile.fullName = profile.fullName
        cdProfile.email = profile.email
        cdProfile.address = profile.address
        cdProfile.imageUrl = profile.imageUrl
        cdProfile.timestamp = .now
        if let isAccepted = profile.isAccepted {
            cdProfile.isAccepted = NSNumber(booleanLiteral: isAccepted)
        }
    }

     func fetchProfilesLocally() -> [ProfileCard] {
         let request: NSFetchRequest<CDProfileCard> = CDProfileCard.fetchRequest()
         do {
             let cdProdiles = try viewContext.fetch(request)
             return cdProdiles.sorted(by: { $0.timestamp?.timeIntervalSince1970 ?? 0 < $1.timestamp?.timeIntervalSince1970 ?? 0 }).map { cdProfile in
                 ProfileCard(fullName: cdProfile.fullName ?? "nil",
                             address: cdProfile.address ?? "nil",
                             imageUrl: cdProfile.imageUrl ?? "nil",
                             isAccepted: cdProfile.isAccepted?.boolValue,
                             email: cdProfile.email ?? "nil")
             }
         } catch {
             print("Failed to fetch users: \(error)")
             return []
         }
     }

    func updateProfile(_ cdProfile: CDProfileCard, with profile: ProfileCard) {
        populateProfile(cdProfile, with: profile)
    }

    func deleteAllProfiles() {
        let request: NSFetchRequest<NSFetchRequestResult> = CDProfileCard.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try viewContext.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete all users: \(error)")
        }
    }
}
