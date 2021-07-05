//
//  WebLoginViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 23.05.2021.
//

import UIKit
import WebKit

class WebLoginViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
        let storage = WKWebsiteDataStore.default()
        storage.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                storage.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record]) { [self] in
                    Session.Instance.token = String()
                    Session.Instance.userId = 0
                    request()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        request()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func request() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7861858"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.132"),
        ]
        
        let request = URLRequest(url: components.url!)
        print(request)
        webView.load(request)
    }
    
}

extension WebLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
                   url.path == "/blank.html",
                   let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
               
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
               
        print(params)
               
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let userId = Int(userIdString)
        else {
            decisionHandler(.allow)
            return
        }
               
        Session.Instance.token = token
        Session.Instance.userId = userId
        print("Session.Instance.token = \(Session.Instance.token) userId = \(Session.Instance.userId)")
        performSegue(withIdentifier: "LoginSegue", sender: nil)
       //        NetworkService.loadGroups(token: token)
               
               
               
        decisionHandler(.cancel)
    }

}
