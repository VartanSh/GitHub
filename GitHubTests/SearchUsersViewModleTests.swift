//
//  SearchUsersViewModleTests.swift
//  GitHubTests
//
//  Created by Admin on 5/1/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import XCTest
@testable import GitHub

class SearchUsersViewModleTests: XCTestCase {
    
    var testSearchUsersViewModel: TestSearchUsersViewModel!
     override func setUp() {
         super.setUp()
         testSearchUsersViewModel = TestSearchUsersViewModel()
     }
     
     override func tearDown() {
            testSearchUsersViewModel = nil
            super.tearDown()
     }
     
     func testCountBeforFetchData(){
         XCTAssertEqual(testSearchUsersViewModel.numberOfRows,0, "numberOfRows is not 0")
     }
     
     func setUPMockData(){
        let items = [SearchUser(login: "testLogin", avatarURL: "testAvatarURL", url: "testURL", numberOfRepo: 1)]
        let mockSearchUsersData = SearchUsers(totalCount: 1, incompleteResults: false, items:items)
        let mockNetworking = MockNetworking(searchUsers: mockSearchUsersData, searchUser: nil, publicRepositories: nil, profile: nil, data: nil, error: nil)
        testSearchUsersViewModel .setMockNetworkServise(networkService: mockNetworking)
     }
    
    func setUPMockDataWithNilValue(){
         let items = [SearchUser(login: nil, avatarURL: nil, url: nil, numberOfRepo: nil)]
         let mockSearchUsersData = SearchUsers(totalCount: nil, incompleteResults: nil, items:items)
         let mockNetworking = MockNetworking(searchUsers: mockSearchUsersData, searchUser: nil, publicRepositories: nil, profile: nil, data: nil, error: nil)
         testSearchUsersViewModel .setMockNetworkServise(networkService: mockNetworking)
     }

     func setUPMockDataWithError(){
        let mockNetworking = MockNetworking(searchUsers: nil, searchUser: nil, publicRepositories: nil, profile: nil, data: nil, error: GitErrorList.BadResponse)
         testSearchUsersViewModel .setMockNetworkServise(networkService: mockNetworking)
     }

     func testFetchData(){
        setUPMockData()
        testSearchUsersViewModel.fetchSearchUsers(searchString: "") { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self.testSearchUsersViewModel.numberOfRows, 1, "numberOfRows is 1")
        }
        
     }
    
     func testGetProperties(){
         setUPMockData()
         testSearchUsersViewModel.fetchSearchUsers(searchString: "") { (error) in
             XCTAssertEqual(self.testSearchUsersViewModel.getLoginName(for: 0), "testLogin", "LoginName is not \'testLogin\'")
             XCTAssertEqual(self.testSearchUsersViewModel.getURL(for: 0), "testURL", "choolLocation is not \'testURL\'")
             XCTAssertEqual(self.testSearchUsersViewModel.getAvatarURL(for: 0), "testAvatarURL", "SchoolWebSite is not \'testAvatarURL\'")
         }
     }
    
     func testGetPropertiesWithNilValue(){
        setUPMockDataWithNilValue()
        testSearchUsersViewModel.fetchSearchUsers(searchString: "") { (error) in
            XCTAssertEqual(self.testSearchUsersViewModel.getLoginName(for: 0),"", "LoginName is not empty")
            XCTAssertEqual(self.testSearchUsersViewModel.getURL(for: 0), "", "URL is not empty")
           XCTAssertEqual(self.testSearchUsersViewModel.getAvatarURL(for: 0), "", "AvatarURL is not empty")
        }
     }

     func testBind(){
         setUPMockData()
         var bindTest = false
         testSearchUsersViewModel.bind {
             bindTest = true
         }
         testSearchUsersViewModel.fetchSearchUsers(searchString: "") { (error) in
             XCTAssertNil(error)
             XCTAssertTrue(bindTest)
         }
     }

     func testUnBind(){
         setUPMockData()
         var bindTest = false
         testSearchUsersViewModel.bind {
             bindTest = true
         }
         testSearchUsersViewModel.unbind()
         testSearchUsersViewModel.fetchSearchUsers(searchString: "") { (error) in
             XCTAssertNil(error)
             XCTAssertFalse(bindTest)
         }
     }

     func testFetchDataWithError(){
         setUPMockDataWithError()
         testSearchUsersViewModel.fetchSearchUsers(searchString: "") { (error) in
             XCTAssertNotNil(error)
             XCTAssertTrue(error is GitErrorList)
             let err = error as! GitErrorList
                 XCTAssertEqual(err,GitErrorList.BadResponse, "error" )
        }
     }
}
