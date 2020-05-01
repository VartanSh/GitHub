//
//  WebViewController.swift
//  GitHub
//
//  Created by Admin on 4/30/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    //create webView
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        return webView
    }()
    //create ActivityIndicator
    lazy var actInd: UIActivityIndicatorView = {
        let aInd = self.showActivityIndicatory(uiView: self.view)
        return aInd
    }()
    
    var urlString : String
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        urlString = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setupUI()
        loadWebPage()
    }
    //load web pagr or site
    func loadWebPage() {
        guard let url = URL(string:self.urlString ) else { return }
        let requestURL = URLRequest(url: url)
        //request for borwser version
        self.webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36"
        DispatchQueue.main.async {
            self.webView.load(requestURL)
        }
    }
    //set ip ui
    func setupUI() {
        self.navigationItem.title = "Repository Web Page "
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    //set up the correct webpage url based on school website info
    func setURL(urlString:String){
        let tempString = urlString.lowercased()
        //check if school has its on website
        //if not change the url to access the school web page
        if tempString.contains("www.") {
            //if it already have http or https prifix use diefult
            //if not add http prefix
            if tempString.contains("http://") || urlString.contains("https://"){
                self.urlString = urlString
            } else {
                self.urlString = "http://" + urlString
            }
        } else if tempString.contains("schoolportals"){
            let stringArry = urlString.split{$0 == "/"}
            self.urlString = "https://www." + stringArry[0] + "/schools/" + stringArry[3]
        } else {
            self.urlString = urlString
        }
    }
    //set up Activity Indicatory
    func showActivityIndicatory(uiView: UIView) -> UIActivityIndicatorView {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style =
            UIActivityIndicatorView.Style.large
        uiView.addSubview(actInd)
        return actInd
    }
}

//WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
        print(error)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.actInd.stopAnimating()
        print("didFinish")
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.actInd.startAnimating()
        print("didStartProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.actInd.stopAnimating()
        print("didFailProvisionalNavigation")
        print(error)
    }
}
