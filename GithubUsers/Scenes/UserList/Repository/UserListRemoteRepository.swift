//
//  UserListRemoteRepository.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

class UserListRemoteRepository: UserListService {
    private let urlSession = URLSession.shared
    
    private lazy var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }()
    
    func getListUser(completion: @escaping (Result<[GithubUser], Failure>) -> Void) {
        let url = URL(string: "https://api.github.com/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.noResponse))
                return
            }
            
            do {
                let users = try self.jsonDecoder.decode([GithubUser].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(.invalidResponse))
            }
        }
        task.resume()
    }
}
