//
//  SearchUsersViewModel.swift
//  GitHub
//
//  Created by Admin on 4/11/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import Foundation
import UIKit
class SearchUsersViewModel {
    private var users: SearchUsers? {
        didSet {
            self.updateHandler?()
        }
    }
    private var service: Networking
    private let queue: DispatchQueue = .main
    private var updateHandler: (() -> Void)?
    private let imageCache = NSCache<NSString, UIImage>()
    private let repoCountCache = NSCache<NSString, NSNumber>()
    init(){
        self.service = NetworkService()
    }
}

extension SearchUsersViewModel {
    fileprivate func setNetworkService(networkService:Networking) {
        self.service = networkService
    }
    
    var numberOfRows: Int {
        guard let count = users?.items?.count else {return 0}
        return count
    }

    func getLoginName(for index: Int) -> String {
        guard let login = users?.items?[index].login else {return ""}
        return login
    }
    
    func getAvatarURL(for index: Int) -> String {
        guard let avatarURL = users?.items?[index].avatarURL else {return ""}
        return avatarURL
    }
    
    func getURL(for index: Int) -> String {
        guard let url = users?.items?[index].url else {return ""}
        return url
    }
    
    func setURL(for index: Int, url: String) {
        users?.items?[index].url = url
    }
    
    func bind(_ updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }

    func unbind() {
        self.updateHandler = nil
    }

    func saveImage(image:UIImage,urlString:String) {
        imageCache.setObject(image, forKey: urlString as NSString)
    }

    func isImageExist(urlString: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return cachedImage
        } else {
            return nil
        }
    }
    
    func saveRepoCount(count:Int,loginName:String) {
        repoCountCache.setObject(NSNumber(value: count), forKey: loginName as NSString)
    }

    func isRepoCountExist(loginName: String) -> Int? {
        if let cachedCount = repoCountCache.object(forKey: loginName as NSString) {
            return cachedCount.intValue
        } else {
            return nil
        }
    }
    
    func fetchSearchUsers(searchString:String, _ completion: @escaping (Error?) -> Void)  {
        service.fetchSearchUsers(searchString: searchString) { (result) in
            switch result {
                case .success(let SearchUsers):
                    self.users = SearchUsers
                    completion(nil)
                case .failure(let err):
                    self.users = nil
                    completion(err)
                    print(err)
            }
        }
    }
    
    func fetchImage(urlString: String, _ completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
        }else {
            service.fetchImage(urlString) { (result) in
            switch result {
                case .success(let imageData):
                    guard let image = UIImage(data:imageData,scale:1.0) else {
                        completion(nil)
                        return
                    }
                    self.saveImage(image: image, urlString: urlString)
                    completion(image)
                case .failure(let err):
                    completion(nil)
                    print(err)
                }

            }
        }
    }
}

class TestSearchUsersViewModel: SearchUsersViewModel {
    func setMockNetworkServise(networkService:Networking){
        self.setNetworkService(networkService:networkService)
    }
}
