//
//  ProfileViewModel.swift
//  GitHub
//
//  Created by Admin on 4/10/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import Foundation
class ProfileViewModel {
    private var profile: Profile? {
        didSet {
            self.updateHandler?()
        }
    }
    private var service: Networking
    private let queue: DispatchQueue = .main
    private var updateHandler: (() -> Void)?
    init(){
        self.service = NetworkService()
    }
}

extension ProfileViewModel {
    
    fileprivate func setNetworkService(networkService:Networking) {
        self.service = networkService
    }
    
    func getLoginName() -> String {
        guard let login = profile?.login else {return ""}
        return login
    }
    
    func getPublicReposCount() -> Int {
        guard let publicRepos = profile?.publicRepos else {return 0}
           return publicRepos
    }
    
    func getFollowers() -> Int {
        guard let followers = profile?.followers else {return 0}
        return followers
    }
    
    func getFollowing() -> Int {
        guard let following = profile?.following else {return 0}
        return following
    }
    
    func getBio() -> String {
        guard let bio = profile?.bio else {return ""}
        return bio
    }
    
    func getLocation() -> String {
        guard let location = profile?.location else {return ""}
        return location
    }
    
    func getEmail() -> String {
        guard let email = profile?.email else {return ""}
        return email
    }
    
    func getCreatedAt() -> String {
        guard let createdAt = profile?.createdAt else {return ""}
        return createdAt
    }
    
    func bind(_ updateHandler: @escaping () -> Void) {
           self.updateHandler = updateHandler
       }
       
    func unbind() {
       self.updateHandler = nil
    }
    
    func fetchProfiele(login:String,_ completion: @escaping (Error?) -> Void)  {
        service.fetchProfile (userLogin: login) { (result) in
            switch result {
                case .success(let profile):
                    self.profile = profile
                    completion(nil)
                case .failure(let err):
                    self.profile = nil
                    completion(err)
                    print(err)
            }
        }
    }
   
}

class TestProfileViewModel: ProfileViewModel {
    func setMockNetworkServise(networkService:Networking){
        self.setNetworkService(networkService:networkService)
    }
}
