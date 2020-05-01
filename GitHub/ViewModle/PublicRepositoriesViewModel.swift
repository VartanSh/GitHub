//
//  PublicRepositories.swift
//  GitHub
//
//  Created by Admin on 4/30/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import Foundation
class PublicRepositoriesViewModel {
    private var filterdPublicRepositories: [PublicRepository]? {
        didSet {
            self.updateHandler?()
        }
    }
    private var publicRepositories: [PublicRepository]?  {
       didSet {
           filterdPublicRepositories = publicRepositories
       }
    }
    
    
    private var service: Networking
    private let queue: DispatchQueue = .main
    private var updateHandler: (() -> Void)?
    init(){
        self.service = NetworkService()
    }
}

extension PublicRepositoriesViewModel {
    
    func setFilterString(filterString: String){
        if filterString.isEmpty {
            filterdPublicRepositories = publicRepositories
        } else {
            let filterS = filterString.lowercased()
            filterdPublicRepositories = publicRepositories?.filter {
                ($0.name?.lowercased().contains(filterS) ?? false)
            }
            
        }
    }
    
    fileprivate func setNetworkService(networkService:Networking) {
        self.service = networkService
    }
    
    var numberOfRows: Int {
        guard let count = filterdPublicRepositories?.count else {return 0}
        return count
    }
    
    func getName(for index: Int) -> String? {
        guard let name = filterdPublicRepositories?[index].name else {return ""}
        return name
    }
    
    func getRepoURL(for index: Int) -> String? {
        guard let url = filterdPublicRepositories?[index].gitURL else {return ""}
        return url
    }
    
    func getNumberOfForks(for index: Int) -> Int {
        guard let forksCount = filterdPublicRepositories?[index].forksCount else {return 0}
        return forksCount
    }
    
    func getNumberOfStrars(for index: Int) -> Int {
        guard let targazersCount = filterdPublicRepositories?[index].stargazersCount else {return 0}
        return targazersCount
    }

    func bind(_ updateHandler: @escaping () -> Void) {
           self.updateHandler = updateHandler
       }
       
    func unbind() {
       self.updateHandler = nil
    }
    
    func fetchPublicRepositories(login:String,_ completion: @escaping (Error?) -> Void)  {
        service.fetchPublicRepositories (userLogin: login) { (result) in
            switch result {
                case .success(let publicRepositories):
                    self.publicRepositories = publicRepositories
                    completion(nil)
                case .failure(let err):
                    self.filterdPublicRepositories = nil
                    completion(err)
                    print(err)
            }
        }
    }
}

class TestPublicRepositoriesViewModel: PublicRepositoriesViewModel {
    func setMockNetworkServise(networkService:Networking){
        self.setNetworkService(networkService:networkService)
    }
}
