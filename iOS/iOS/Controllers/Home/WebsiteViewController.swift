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
        
        let url = URL(string: "https://" + websites[currentWebsite])!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
title: "다른 추천 사이트 보기", style: .plain, target: self, action: #selector(openTapped))
        progressView = UIProgressView(progressViewStyle: .default)
            progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)

                let spacer = UIBarButtonItem(barButtonSystemItem:
         .flexibleSpace, target: nil, action: nil)
                let refresh = UIBarButtonItem(barButtonSystemItem:
         .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "뒤로", style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: "앞으로", style: .plain, target: webView, action: #selector(webView.goForward))
        
        
                toolbarItems = [progressButton, spacer, refresh, goBack,goForward]
                navigationController?.isToolbarHidden = false

                webView.addObserver(self, forKeyPath:
        #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            }

            @objc func openTapped() {
                let ac = UIAlertController(title: "페이지 로딩중", message: nil,
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

            func openPage(action: UIAlertAction) {
                let url = URL(string: "https://" + action.title!)!
                webView.load(URLRequest(url: url))
            }

            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                title = webView.title
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
        }



