//
//  UserHistoryView.swift
//  TalkersTalk
//
//  Created by Se Wang Oh on 9/11/18.
//  Copyright © 2018 SWO. All rights reserved.
//

import UIKit

protocol UserHistoryViewDelegate: class {
    
    func onSelectedCellRow(userId: String, userName: String, purpose: UserHistoryView.UserHistoryViewPurpose)
    
}

class UserHistoryView: UIView {
    
    enum UserHistoryViewPurpose {
        case Block
        case Report
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var view: UIView?
    weak var delegate: UserHistoryViewDelegate?
    
    var purpose: UserHistoryViewPurpose = .Block
    
    var blurView: UIVisualEffectView?
    
    deinit {
        self.blurView?.removeFromSuperview()
        self.blurView = nil
    }
    
    
    var historyList: [(userId: String, userName: String)] = []
    
    let cellId = "DefaultTableViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupXib()
    }
    
    private func setupXib() {
        //Load xib for the view
        self.view = UINib(nibName: "UserHistoryView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        
        self.view?.frame = self.bounds
        self.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(self.view!)
        
        self.setupView()
    }
    
    private func setupView() {
        
        self.tableView.layer.borderWidth = 2
        self.tableView.layer.borderColor = UIColor.black.cgColor
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.tableView.rowHeight = 50
        
        self.historyList = SocketConnectionManager.sharedInstance.strangerIdHistory.reversed()
    }
    
    func addBlurView() {
        //Only can be used after being displayed
        if let presentingView = self.superview {
            let blurEffect = UIBlurEffect(style: .regular)
            let blurView = UIVisualEffectView(effect: blurEffect)
            self.blurView = blurView
            blurView.frame = presentingView.bounds
            presentingView.addSubview(blurView)
            presentingView.bringSubview(toFront: self)
        }
    }
    
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}

extension UserHistoryView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        
        cell.textLabel?.text = " " + historyList[indexPath.row].userName + " (\(historyList[indexPath.row].userId))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let userSelected = self.historyList[indexPath.row]
        print("Selected Row: \(userSelected)")
        
        self.delegate?.onSelectedCellRow(userId: userSelected.userId, userName: userSelected.userName, purpose: self.purpose)
    }
    
}
