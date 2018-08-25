//
//  CustomActivityIndicatorView.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/21/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class CustomActivityIndicatorView: UIView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    
    var view: UIView?
    
    private var animTimer: Timer?
    
    deinit {
        print("Custom Indicator view is being deallocated")
        self.animTimer?.invalidate()
    }
    
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
        self.view = UINib(nibName: "CustomActivityIndicatorView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        
        self.view?.frame = self.bounds
        self.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(self.view!)
        self.setupActivityIndicatorView()
        
        self.activityLabel.text = ""
    }
    
    private func setupActivityIndicatorView() {
        
        self.activityIndicatorView.color = UIColor.black
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        activityIndicatorView.transform = transform
        activityIndicatorView.startAnimating()
    }
    
    func setupLabel(label: String) {
        self.activityLabel.text = label
        self.animTimer?.invalidate()
        
        let animTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { [weak self] timer in
            
            if self?.activityLabel.text == label {
                self?.activityLabel.text! += "."
            } else if self?.activityLabel.text == label + "." {
                self?.activityLabel.text! += "."
            } else if self?.activityLabel.text == label + ".." {
                self?.activityLabel.text! += "."
            } else {
                self?.activityLabel.text! = label
            }
        })
        
        self.animTimer = animTimer
    }

    
}
