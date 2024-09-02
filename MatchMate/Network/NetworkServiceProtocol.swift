//
//  NetworkServiceProtocol.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    var isNetworkAvailable: Bool { get }
    func getRequest(url: String, parameters: [String: Any]?, completion: @escaping (Result<Data?, AFError>) -> Void)
}

