//
//  MockNetworking.swift
//  GitHubTests
//
//  Created by Admin on 5/1/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import Foundation
@testable import GitHub

class MockNetworking: Networking {
    
    var searchUsers: SearchUsers?
    var searchUser: SearchUser?
    var publicRepository: PublicRepository?
    var profile: Profile?
    var data: Data?
    var error: Error?

    init(searchUsers: SearchUsers?, searchUser: SearchUser?, publicRepositories: PublicRepository?, profile: Profile?, data: Data?, error: Error?  ) {
        self.searchUsers = searchUsers
        self.searchUser = searchUser
        self.publicRepository = publicRepositories
        self.profile = profile
        self.data = data
        self.error = error
    }
       
    func fetchProfile(userLogin: String, _ completion: @escaping (Result<Profile, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            guard let profile = profile else {
                return
            }
            completion(.success(profile))
        }
    }
    
    func fetchSearchUsers(searchString: String, _ completion: @escaping (Result<SearchUsers, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            guard let searchUsers = searchUsers else {
                return
            }
            completion(.success(searchUsers))
        }
    }
    
    func fetchImage(_ urlString: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            guard let data = data else {
                return
            }
            completion(.success(data))
        }
    }
    
    func fetchPublicRepositories(userLogin: String, _ completion: @escaping (Result<[PublicRepository], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            guard let publicRepository = publicRepository else {
                return
            }
            completion(.success([publicRepository]))
        }
    }
}
