//
//  WebsiteViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/04/15.
//

//
//  WebsiteViewController.swift
//  Project4Test
//
//  Created by 박다미 on 2023/01/29.
//


import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKNavigationDelegate {
    
    //테이블뷰의 [index.row] = 배열 row
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var websites: [String]!
    var currentWebsite: Int!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    

    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        seeNavigation()
        let barButtonAppearance = UIBarButtonItem.appearance()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]
        barButtonAppearance.setTitleTextAttributes(attributes, for: .normal)
        
        let boldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        
        navigationController?.navigationBar.titleTextAttributes = boldAttributes
        
        
        let button = UIBarButtonItem(
            title: "다른 사이트", style: .plain, target: self, action: #selector(openTapped))
        button.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.rightBarButtonItem = button
        
        
        let url = URL(string: "https://" + websites[currentWebsite])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem:
                .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem:
                .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "<", style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: ">", style: .plain, target: webView, action: #selector(webView.goForward))
        
        refresh.tintColor = .black
        toolbarItems = [progressButton, spacer, refresh, goBack,goForward]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath:
                                #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        progressView.tintColor = .systemGreen
        
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(goBack(_:)))
        
        navigationItem.backBarButtonItem = backButton
       
     
    }
    
    
    @objc func goBack(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "추천 페이지 이동 ", message: nil,
                                   preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default,
                                       handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem =
        self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func seeNavigation(){
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        // 로딩이 완료되면 프로그래스바를 숨김
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction:
                 WKNavigationAction, decisionHandler: @escaping
                 (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }


        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // 페이지 로딩을 시작할 때 프로그래스바를 보여줌
            progressView.isHidden = false
        }
}



