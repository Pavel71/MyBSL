//
//  WebController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.08.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit
import WebKit



class WebController : UIViewController {
  
  // MARK: - Outlets
  lazy var webView : WKWebView = {
    let wView = WKWebView()
    wView.navigationDelegate = self
    wView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    wView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
    return wView
  }()
  
  lazy var cancelButton  = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
  
  @objc private func didTapCancelButton() {
    tabBarController?.tabBar.isHidden = false
    self.navigationController?.popViewController(animated: true)
  }
  
  lazy var refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didRe4freshButtonTapped))
  
  @objc private func didRe4freshButtonTapped() {
    progressView.isHidden = false
    webView.reload()
  }
  
  lazy var progressView : UIProgressView =  {
    let progress = UIProgressView(progressViewStyle: .default)
    progress.progressTintColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    return progress
  }()
  
  // MARK: - Init
  
  init(urlString: String) {
    super.init(nibName: nil, bundle: nil)
    
    webView.load(urlString)
    title = "Loading..."
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Web View Did Load")
    
    setNavigationButton()
    setViews()

    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = false
    tabBarController?.tabBar.isHidden = true
  }

  

  
}

// MARK: - Set Up View

extension WebController {
  
  private func setViews() {
    let vStack = UIStackView(arrangedSubviews: [
    progressView,
    webView
    ])
    progressView.constrainHeight(constant: 5)
    vStack.distribution = .fill
    vStack.axis         = .vertical
    
    view.addSubview(vStack)
    vStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
  }
  
  private func setNavigationButton() {
    navigationItem.setLeftBarButton(cancelButton, animated: true)
    navigationItem.setRightBarButton(refreshButton, animated: true)
  }
  
}
// MARK: - WKUi Delegate
extension WebController : WKUIDelegate {
  
}

// MARK: - Wk Navigation Delegate
extension WebController : WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
    progressView.isHidden = true
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    if keyPath == #keyPath(WKWebView.estimatedProgress) {
      progressView.progress = Float(webView.estimatedProgress)
    }
    
  }
}
