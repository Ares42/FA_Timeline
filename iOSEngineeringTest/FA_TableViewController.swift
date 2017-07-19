 //
 //  FA_TableViewController.swift
 //  iOSEngineeringTest
 //
 //  Created by Pierre Laurac on 11/7/16.
 //  Copyright © 2016 FrontApp. All rights reserved.
 //
 
 import Foundation
 import UIKit
 
 
 protocol FA_TableViewControllerDelegate {
    func removeCellSubTitleLabel()
 }
 
 class FA_TableViewController: UITableViewController {
    
    // ===== Variables ===== //
    fileprivate let messageCellIdentifier = "messageCell"
    fileprivate var messages: [FA_Message] = []
    
    var contentHeights : [CGFloat] = [0.0, 0.0, 0.0, 0.0]

    
    // ===== View Lifecycle ===== //
    override func viewDidLoad() {
        getConversation()
        
            tableView.rowHeight = UITableViewAutomaticDimension
        //    tableView.estimatedRowHeight = 140
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    // ===== TableView Delegate Methods ===== //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        * If the content_loaded property of a message is true: display the body of a message first
//        * if the content_loaded property of a message is false: display the blurb. A tap on the blurb should hide it and display the `body` instead. Once a message is expanded, you cannot close it. (By default, some messages are `content_loaded = false` but the body is already set. This is to simplify the test).
        
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath) as! FA_TableViewCell
        
        let message = self.messages[indexPath.row]
        
        cell.titleLabel?.text = message.from
        cell.message = message
        
        if message.content_loaded {
            cell.webView.tag = indexPath.row
            cell.webView.delegate = self
            cell.webView.loadHTMLString(message.body, baseURL: nil)
            cell.webView.scalesPageToFit = true
//            cell.removeSubTitle()
        } else {
            cell.subTitleLabel?.text = message.blurb
        }
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
        return contentHeights[indexPath.row]
    }
    
    // ===== Methods ===== //
    fileprivate func getConversation() {
        do {
            let pathToComposer = Bundle.main.path(forResource: "conversation", ofType: "json")
            let jsonData = try NSData(contentsOfFile: pathToComposer!) as Data
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! Dictionary<String, Any>
            let rawMessages = json["messages"] as! Array<Dictionary<String, Any>>
            rawMessages.reversed().forEach({ (message) in
                self.messages.append(FA_Message(dict: message))
            })
        } catch {}
    }
 }
 extension FA_TableViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        if (messages[webView.tag].content_loaded) {
//            return
//        } else {
//            messages[webView.tag].content_loaded = true
//        }
        
        if contentHeights[webView.tag] != 0.0 {
            return
        } else {
//            messages[webView.tag].content_loaded = true
        }


//        var frame:CGRect = webView.frame
//        frame.size.height = 1
//        webView.frame = frame
//        var fittingSize:CGSize = webView.sizeThatFits(CGSize.zero)
//        frame.size = fittingSize
//        webView.frame = frame

        contentHeights[webView.tag] = webView.scrollView.contentSize.height
        print("webView tag:")
        print(webView.tag)
        print("contentHeight:")
        print(contentHeights[webView.tag])
        
        tableView.reloadRows(at: [IndexPath(item: webView.tag, section: 0)], with: .automatic)
    }
 }
