
import UIKit
import WebKit

final class NewsSourceVC: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var loadUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
    }
    
    private func configureWebView() {
        webView.navigationDelegate = self
        if let url = URL(string: loadUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        webView.allowsBackForwardNavigationGestures = true
    }
}

// MARK: - WKNavigationDelegate
extension NewsSourceVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
