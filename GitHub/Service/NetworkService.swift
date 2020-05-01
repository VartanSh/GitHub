//
//  NetworkService.swift
//  GitHub
//
//  Created by Admin on 4/10/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import Foundation
enum GitErrorList: Error {
    case BadResponse
    case NoData
    case BadURL
    case NoConnection
}

protocol Networking {
    func fetchProfile(userLogin: String, _ completion: @escaping (Result<Profile, Error>) -> Void)
    
    func fetchSearchUsers(searchString: String, _ completion: @escaping (Result<SearchUsers, Error>) -> Void)
    
    func fetchImage(_ urlString : String,_ completion: @escaping (Result<Data, Error>) -> Void)
    func fetchPublicRepositories(userLogin: String, _ completion: @escaping (Result<[PublicRepository], Error>) -> Void) 
}

class NetworkService: Networking {
    
    let session = URLSession(configuration: .default)
    let decoder = JSONDecoder()
    

    func fetchSearchUsers(searchString: String, _ completion: @escaping (Result<SearchUsers, Error>) -> Void) {
        //API.GitHubAPI.apiURL + API.GitHubAPI.users
        guard let url = URL(string:"https://api.github.com/search/users?q=" + searchString ) else {
            completion(.failure(GitErrorList.BadURL as Error))
            return
        }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                let err = error as NSError
                if (err.code == -1009) {
                    completion(.failure(GitErrorList.NoConnection as Error))
                } else {
                    completion(.failure(error as Error))
                }
                return
            }
            guard let _ = response else {
                completion(.failure(GitErrorList.BadResponse as Error))
                return
            }
            guard let data = data else {
                completion(.failure(GitErrorList.NoData as Error))
                return
            }
            do {
                if let feed = try self?.decoder.decode(SearchUsers.self, from: data) {
                    completion(.success(feed))
                }
            } catch {
                completion(.failure(error as Error))
            }
        }
        task.resume()
    }
    
    func fetchProfile(userLogin: String, _ completion: @escaping (Result<Profile, Error>) -> Void) {
        //API.GitHubAPI.apiURL + API.GitHubAPI.users
        
        guard let url = URL(string:"https://api.github.com/users/" + userLogin ) else {
            completion(.failure(GitErrorList.BadURL as Error))
            return
        }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                let err = error as NSError
                if (err.code == -1009) {
                    completion(.failure(GitErrorList.NoConnection as Error))
                } else {
                    completion(.failure(error as Error))
                }
                return
            }
            guard let _ = response else {
                completion(.failure(GitErrorList.BadResponse as Error))
                return
            }
            guard let data = data else {
                completion(.failure(GitErrorList.NoData as Error))
                return
            }
            do {
                if let feed = try self?.decoder.decode(Profile.self, from: data) {
                    completion(.success(feed))
                }
            } catch {
                completion(.failure(error as Error))
            }
        }
        task.resume()
    }
    
    func fetchPublicRepositories(userLogin: String, _ completion: @escaping (Result<[PublicRepository], Error>) -> Void) {
        guard let url = URL(string:"https://api.github.com/users/" + userLogin + "/repos"  ) else {
            completion(.failure(GitErrorList.BadURL as Error))
            return
        }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                let err = error as NSError
                if (err.code == -1009) {
                    completion(.failure(GitErrorList.NoConnection))
                } else {
                    completion(.failure(error))
                }
                return
            }
            guard let _ = response else {
                completion(.failure(GitErrorList.BadResponse))
                return
            }
            guard let data = data else {
                completion(.failure(GitErrorList.NoData))
                return
            }
            do {
                if let feed = try self?.decoder.decode([PublicRepository].self, from: data) {
                    completion(.success(feed))
                }
            } catch {
                completion(.failure(error as Error))
            }
        }
        task.resume()
    }

    
    func fetchImage(_ urlString : String,_ completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(GitErrorList.BadURL as Error))
            return
        }
        let task = session.dataTask(with: url) {(data, response, error) in
            if let error = error {
                let err = error as NSError
                if (err.code == -1009) {
                    completion(.failure(GitErrorList.NoConnection))
                } else {
                    completion(.failure(error as Error))
                }
                return
            }
            guard let _ = response else {
                completion(.failure(GitErrorList.BadResponse))
                return
            }
            guard let data = data else {
                completion(.failure(GitErrorList.NoData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}


