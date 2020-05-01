//
//  UserProfileViewController.swift
//  GitHub
//
//  Created by Admin on 4/12/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import UIKit


class UserProfileViewController: UIViewController {

    enum Constants {
        static let cellReuseId = "MasterViewTableViewCell"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var userImageView : UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var JoinDate: UILabel!
    @IBOutlet weak var email: UILabel!
    private var lastUIElement : UIView = UIView()
    private let profileViewModel = ProfileViewModel()
    private let publicRepoViewModel = PublicRepositoriesViewModel()
    private var userImage = UIImage()
    private var userLogin = ""
    private var actInd = UIActivityIndicatorView()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lastUIElement = self.tableView
        self.setupUI()
        
        profileViewModel.bind {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        publicRepoViewModel.bind {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        actInd.startAnimating()
        profileViewModel.fetchProfiele(login: self.userLogin){ [weak self] err in
            guard let err = err else {
                self?.publicRepoViewModel.fetchPublicRepositories(login: self?.userLogin ?? ""){ [weak self] err in
                    guard let err = err else {
                        DispatchQueue.main.async {
                            self?.actInd.stopAnimating()
                        }
                        return
                    }
                    self?.alert(err: err as? GitErrorList)
                }
                return
            }
            DispatchQueue.main.async {
                self?.actInd.stopAnimating()
            }
            self?.alert(err: err as? GitErrorList)
        }
    }
    
    func setUserImage(userImage:UIImage?){
        guard let image = userImage else {
            return
        }
        self.userImage = image
    }
    
    func setUserLogin(userLogin:String){
        self.userLogin = userLogin
    }
    
    func setupUI(){
        // Activity IndicatorView
        self.actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        self.actInd.center = tableView.center
        self.actInd.hidesWhenStopped = true
        self.actInd.style = UIActivityIndicatorView.Style.large
        //tableview
        self.tableView.register(PublicRepositoriesTableViewCell.self,
        forCellReuseIdentifier: Constants.cellReuseId)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundView = self.actInd
        //searchbar
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search Repos"
    }

    func updateUI(){
        let dateFormatter = ISO8601DateFormatter()
        let readableDate = dateFormatter.date(from: profileViewModel.getCreatedAt())
        dateFormatter.formatOptions = .withDashSeparatorInDate
        var dateString = ""
        if let readableDate = readableDate {
            dateString = dateFormatter.string(from: readableDate)
        }
        self.Name.text = "UserName: " + profileViewModel.getLoginName()
        self.numberOfFollowers.text =  String(profileViewModel.getFollowers()) + " Followers"
        self.numberOfFollowing.text = "Following " + String(profileViewModel.getFollowing())
        self.biography.text =  "Bio:\n" + profileViewModel.getBio()
        self.location.text = "Location: " + profileViewModel.getLocation()
        self.JoinDate.text = "JoinDate: " + dateString
        self.email.text = "Email: " + profileViewModel.getEmail()
        self.userImageView.image = self.userImage
    }
    
    func dateToString(date:Date?) -> String{
        guard let date = date else {
            return ""
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
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

extension UserProfileViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        publicRepoViewModel.setFilterString(filterString: searchText)
        //actInd.startAnimating()
    }
}

extension UserProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicRepoViewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as? PublicRepositoriesTableViewCell else {
            fatalError("Could not dequeue cell, please register first")
        }
        cell.repoNameLablel.text = publicRepoViewModel.getName(for: indexPath.row)
        cell.numberOfForksLablel.text = String(publicRepoViewModel.getNumberOfForks(for: indexPath.row)) + " Forks"
        cell.numberOfStrarsLablel.text = String(publicRepoViewModel.getNumberOfStrars(for: indexPath.row)) + " Stars"
        cell.backgroundColor = .white
        return cell
    }
}

extension UserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = publicRepoViewModel.getRepoURL(for: indexPath.row) else {
            return
        }
        let webVC = WebViewController()
        webVC.setURL(urlString: url)
        navigationController?.pushViewController(webVC, animated: true)

    }
}

