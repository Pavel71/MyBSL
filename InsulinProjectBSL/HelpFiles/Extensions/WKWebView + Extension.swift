//
//  WKWebView + Extension.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.08.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
