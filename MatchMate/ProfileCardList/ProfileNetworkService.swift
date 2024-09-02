//
//  ProfileNetworkService.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import Foundation
import Alamofire

class ProfileNetworkService {

    static let fetchProfilesUrl = "https://randomuser.me/api/?results=10"
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchProfiles(completion: @escaping (Result<[Profile], Error>) -> Void) {
        networkService.getRequest(url: ProfileNetworkService.fetchProfilesUrl, parameters: nil) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(ResponseWrapper.self, from: data)
                        completion(.success(decodedResponse.results))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
