//
//  Profile+.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import Foundation

extension Profile {

    func fullName() -> String {
        return name.title + " " + name.first + " " + name.last
    }

    func address() -> String {
        return location.city + ", " + location.state + ", " + location.country
    }
}
