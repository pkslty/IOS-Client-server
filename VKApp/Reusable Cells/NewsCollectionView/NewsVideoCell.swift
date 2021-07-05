//
//  NewsVideoCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 29.06.2021.
//

import UIKit
import WebKit

class NewsVideoCell: UICollectionViewCell {

    @IBOutlet weak var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(videoUrlString: String, plus: Int?) {
        guard let url = URL(string: videoUrlString)
        else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
        /*self.plus.isHidden = true
        guard let plus = plus, plus > 0 else { return}
        self.plus.isHidden = false
        self.plus.text = "+\(plus)"*/
    }

    override func prepareForReuse() {
        webView.load(URLRequest(url: URL(string: "about:blank")!))
    }
}
