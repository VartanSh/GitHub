//
//  UserViewController.swift
//  GitHub
//
//  Created by Admin on 4/10/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    enum Constants {
        static let cellReuseId = "UsersTableViewCell"
    }

    @IBOutlet weak var tableView: UITableView!
    
    private let queue: DispatchQueue = .main
    let viewModel = SearchUsersViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var actInd = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        viewModel.bind {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func setupUI(){
        // Activity IndicatorView
        self.actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        self.actInd.center = tableView.center
        self.actInd.hidesWhenStopped = true
        self.actInd.style = UIActivityIndicatorView.Style.large
        //tableview
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundView = self.actInd
        //navigation
        navigationController?.isNavigationBarHidden = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "GitHub User Search"
    }
    
    func alert(err:GitErrorList?) {
        var alertString = ""
        guard let err = err else {
            return
        }
        
        switch err {
        case .BadResponse:
            alertString = "Response is not valid"
        case .BadURL:
            alertString = "URL is not valid"
        case .NoData:
            alertString = "Data does not exist"
        case .NoConnection:
            alertString = "No internet connection"
        }
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "error", message: alertString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension UserViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text  else {
        return
    }
    actInd.startAnimating()
    viewModel.fetchSearchUsers(searchString: text){ [weak self] err in
        guard let err = err else {
            DispatchQueue.main.async {
                self?.actInd.stopAnimating()
            }
            return
        }
        DispatchQueue.main.async {
            self?.actInd.stopAnimating()
        }
        self?.alert(err: err as? GitErrorList)
    }
  }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as? UsersTableViewCell else {
            fatalError("Could not dequeue cell, please register first")
        }
        cell.NumberOfRepositories.text = "Repo:  "
        cell.UserAvatarImage.image = nil
        cell.UserName.text = viewModel.getLoginName(for: indexPath.row)
        let url = viewModel.getAvatarURL(for: indexPath.row)
        if  url != "" {
            viewModel.fetchImage(urlString: url) { (result)  in
               DispatchQueue.main.async() {
                   if let image = result {
                       cell.UserAvatarImage.image = image
                   } else {
                       cell.UserAvatarImage.image = UIImage(named: "no_image")
                   }
               }
           }
        } else {
           cell.UserAvatarImage.image = UIImage(named: "no_image")
        }
        let login = viewModel.getLoginName(for: indexPath.row)
        
        if let numOfRepo = viewModel.isRepoCountExist(loginName: login) {
            cell.NumberOfRepositories.text = "Repo: " + String(numOfRepo)
        } else {
            if login != "" {
                let profileViewModel = ProfileViewModel()
                profileViewModel.fetchProfiele(login: login){ [weak self] err in
                    DispatchQueue.main.async() {
                        if err != nil {
                            cell.NumberOfRepositories.text = "Repo: 0"
                        } else {
                            let repoPublicCount = profileViewModel.getPublicReposCount()
                            cell.NumberOfRepositories.text =  "Repo: " + String(repoPublicCount)
                            self?.viewModel.saveRepoCount(count: repoPublicCount, loginName: login)
                        }
                    }
                }
            }
        }
        cell.backgroundColor = .white
        return cell
    }
}

extension UserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UsersTableViewCell
        else {
           fatalError("Could not dequeue cell, please register first")
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let proVC = storyBoard.instantiateViewController(identifier: "UserProfileViewController") as UserProfileViewController
        let login = viewModel.getLoginName(for: indexPath.row)
        if  login != "" {
            proVC.setUserLogin(userLogin:login )
            if let image = cell.UserAvatarImage.image {
                proVC.setUserImage(userImage: image)
            } else {
                proVC.setUserImage(userImage: UIImage(named: "no_image"))
            }
            navigationController?.pushViewController(proVC, animated: true)
        }
        
    }
}

