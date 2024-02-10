//
//  ViewController.swift
//  WebBrowser
//
//  Created by Jessi Zimmerman on 2/3/24.
//
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
//    Define the view
    var webView: WKWebView!
    var progressView: UIProgressView!
    var website: String?
    var websites: [String]?
    
    override func loadView() {
        //        Create the webview
                webView = WKWebView()
                webView.navigationDelegate = self
                view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//       Cast the website string as URL and pass it in a URLRequest to the webView to load
        let url = URL(string: "https://" + website!)!
        webView.load(URLRequest(url: url))
//        Allow swiping back and forward to navigate in the webview
        webView.allowsBackForwardNavigationGestures = true
//        Add navigation buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack)), UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))]
//        Define and appropriately size the progress bar for the webView
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
//        Define the space between the progressView and the next button, which is a refresh button, also defined here
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
//       Add the progress bar, spacer, and refresh button to the toolbar (at the bottom)
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
//        Have the webView check the estimated progress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
//    This is a #selector function so it requires an @objc wrapper. It tells what to do when you tap the open button.
    @objc func openTapped(){
//        create an alert controller
        let ac = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
//        Add a button which calls the openPage function on that website
        for site in websites!{
            ac.addAction(UIAlertAction(title: site, style: .default, handler: openPage))
        }
//        Have a cancel button in the alert controller
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        The alert controller should pop open and present itself in the navigation bar on the right button
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
//    Receive a website from the Open page alert controller and open that website
    func openPage(action: UIAlertAction){
//        Unwrap the website if possible. If not, don't continue.
        guard let actionTitle = action.title else {return}
//        Assign the website string to the URL data type if possible. If not, don't continue.
        guard let url = URL(string: "https://" + actionTitle) else {return}
//        Pass the URL data type of the website string to a URLRequest and have the webview load it.
        webView.load(URLRequest(url: url))
    }
//    When the webView finishes navigating to the website, set a Title of the webView to the title of the website
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
//    Check the value of esimatedProgress and make it a Float then assign it the progressView's progress variable
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
//    Take in a navigation action from the webView and decide how to handle it
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        Get the website URL that was chosen
        let url = navigationAction.request.url
//        Optionally unwrap the url's host property and assign it to the host constant
        if let host = url?.host{
//            Check to see if the host property contains that website. If so, return a decision of allow and stop there.
            for site in websites!{
                if host.contains(site){
                    decisionHandler(.allow)
                    return
                }
            }
//            If not, call the bad request function.
            badRequest()
        }
        decisionHandler(.cancel)
    }
//    Handle a website that is not allowed
    func badRequest(){
//        Create an alert controller
        let ac = UIAlertController(title: "Bad request", message: "This website is blocked.", preferredStyle: .actionSheet)
//        Have a cancel button in the alert controller
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        The alert controller should pop open and present itself in the navigation bar on the right button
        ac.popoverPresentationController?.sourceView = self.webView.scrollView
        present(ac, animated: true)
    }
}

