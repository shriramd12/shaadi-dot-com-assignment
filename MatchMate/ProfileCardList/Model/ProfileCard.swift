//
//  ProfileCard.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import Foundation

struct ProfileCard: Equatable {
    let fullName: String
    let address: String
    let imageUrl: String
    var isAccepted: Bool?
    let email: String

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.email == rhs.email
    }

}
