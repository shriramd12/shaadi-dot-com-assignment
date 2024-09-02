//
//  NetworkService.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import Foundation
import Alamofire

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private init() {}
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    var isNetworkAvailable: Bool {
        return reachabilityManager?.isReachable ?? false
    }

    func getRequest(url: String, parameters: [String: Any]? = nil, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(url, parameters: parameters).response { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
