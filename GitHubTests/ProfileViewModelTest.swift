//
//  ProfileViewModelTest.swift
//  GitHubTests
//
//  Created by Admin on 5/1/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import XCTest
@testable import GitHub

class ProfileViewModelTest: XCTestCase {
    var testProfileViewModel: TestProfileViewModel!
     override func setUp() {
         super.setUp()
         testProfileViewModel = TestProfileViewModel()
     }
     
     override func tearDown() {
            testProfileViewModel = nil
            super.tearDown()
     }
     
     func testCountBeforFetchData(){
        XCTAssertEqual(testProfileViewModel.getLoginName(), "", "data exist")
     }
     
     func setUPMockData(){
        let mockSearchUsersData = Profile(login: "testLogin", id: 1, avatarURL: "testAvatarURL", reposURL: "testReposURL", name: "testName", location: "testLocation", email: "testEmail", bio: "testBio", followers: 1, following: 2, createdAt: "testCreatedAt", publicRepos: 3)
        let mockNetworking = MockNetworking(searchUsers: nil, searchUser: nil, publicRepositories: nil, profile: mockSearchUsersData, data: nil, error: nil)
        testProfileViewModel .setMockNetworkServise(networkService: mockNetworking)
     }

    func setUPMockDataWithNilValue(){
        let mockSearchUsersData = Profile(login: nil, id: nil, avatarURL: nil, reposURL: nil, name: nil, location: nil, email: nil, bio: nil, followers: nil, following: nil, createdAt: nil, publicRepos: nil)
         let mockNetworking = MockNetworking(searchUsers: nil, searchUser: nil, publicRepositories: nil, profile: mockSearchUsersData, data: nil, error: nil)
         testProfileViewModel .setMockNetworkServise(networkService: mockNetworking)
     }

     func setUPMockDataWithError(){
        let mockNetworking = MockNetworking(searchUsers: nil, searchUser: nil, publicRepositories: nil, profile: nil, data: nil, error: GitErrorList.BadResponse)
         testProfileViewModel .setMockNetworkServise(networkService: mockNetworking)
     }

     func testFetchData(){
        setUPMockData()
        testProfileViewModel.fetchProfiele(login: "") { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self.testProfileViewModel.getLoginName(), "testLogin", "data dose not exist")
        }
     }

     func testGetProperties(){
         setUPMockData()
         testProfileViewModel.fetchProfiele(login: "") { (error) in
             XCTAssertNil(error)
             XCTAssertEqual(self.testProfileViewModel.getLoginName(), "testLogin", "LoginName is not \'testLogin\'")
            XCTAssertEqual(self.testProfileViewModel.getBio(), "testBio", "Bio is not \'testBio\'")
            XCTAssertEqual(self.testProfileViewModel.getEmail(), "testEmail", "Email is not \'testEmail\'")
            XCTAssertEqual(self.testProfileViewModel.getLocation(), "testLocation", "Location is not \'testLocation\'")
             XCTAssertEqual(self.testProfileViewModel.getCreatedAt(), "testCreatedAt", "Location is not \'testCreatedAt\'")
            XCTAssertEqual(self.testProfileViewModel.getFollowers(), 1, "Followers is not \'1\'")
            XCTAssertEqual(self.testProfileViewModel.getFollowing(), 2, "Following is not \'2\'")
            XCTAssertEqual(self.testProfileViewModel.getPublicReposCount(), 3, "PublicRepos is not \'3\'")
         }
     }

     func testGetPropertiesWithNilValue(){
        setUPMockDataWithNilValue()
        testProfileViewModel.fetchProfiele(login: "") { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self.testProfileViewModel.getLoginName(), "", "LoginName is not \'\'")
           XCTAssertEqual(self.testProfileViewModel.getBio(), "", "Bio is not \'\'")
           XCTAssertEqual(self.testProfileViewModel.getEmail(), "", "Email is not \'\'")
           XCTAssertEqual(self.testProfileViewModel.getLocation(), "", "Location is not \'\'")
            XCTAssertEqual(self.testProfileViewModel.getCreatedAt(), "", "Location is not \'\'")
           XCTAssertEqual(self.testProfileViewModel.getFollowers(), 0, "Followers is not \'0\'")
           XCTAssertEqual(self.testProfileViewModel.getFollowing(), 0, "Following is not \'0\'")
           XCTAssertEqual(self.testProfileViewModel.getPublicReposCount(), 0, "PublicRepos is not \'0\'")
            
        }
     }

     func testBind(){
         setUPMockData()
         var bindTest = false
         testProfileViewModel.bind {
             bindTest = true
         }
         testProfileViewModel.fetchProfiele(login: "") { (error) in
             XCTAssertNil(error)
             XCTAssertTrue(bindTest)
         }
     }

     func testUnBind(){
         setUPMockData()
         var bindTest = false
         testProfileViewModel.bind {
             bindTest = true
         }
         testProfileViewModel.unbind()
         testProfileViewModel.fetchProfiele(login: "") { (error) in
             XCTAssertNil(error)
             XCTAssertFalse(bindTest)
         }
     }

     func testFetchDataWithError(){
         setUPMockDataWithError()
         testProfileViewModel.fetchProfiele(login: "") { (error) in
             XCTAssertNotNil(error)
             XCTAssertTrue(error is GitErrorList)
             let err = error as! GitErrorList
                 XCTAssertEqual(err,GitErrorList.BadResponse, "error" )
        }
     }
    
}
