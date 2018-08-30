//
//  CustomMessageTextView.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/21/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

protocol CustomMessageTextViewDelegate: class {
    func onSendBtnClicked(message: String)
}

class CustomMessageTextView: UIView {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var view: UIView?
    weak var delegate: CustomMessageTextViewDelegate?
    
    let textViewPlaceHolder = "Enter a message..."
    
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
        self.view = UINib(nibName: "CustomMessageTextView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        
        self.view?.frame = self.bounds
        self.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(self.view!)
        
        self.setupTextFieldView()
    }
    
    private func setupTextFieldView() {
        
        self.messageTextView.textColor = UIColor.lightGray
        self.messageTextView.text = self.textViewPlaceHolder
        self.messageTextView.delegate = self
        
        self.sendButton.isEnabled = false
        self.sendButton.alpha = 0.6
    }
    
    @IBAction func onSendBtnClicked(_ sender: Any) {
        
        guard let message = self.messageTextView.text, message.isEmpty == false else {
            logger.info("Message to send cannot be empty")
            return
        }
        
        self.messageTextView.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.alpha = 0.6
        
        self.delegate?.onSendBtnClicked(message: message)
    }
    
}

extension CustomMessageTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            //remove placeholder
            self.messageTextView.text = ""
            self.messageTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.black && textView.text.isEmpty {
            textView.text = self.textViewPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        
        //If the text size is over the limit, don't apply the change
        if textView.text.bytes.count + text.bytes.count > Constants.messageSizeLimitInByte {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if let text = textView.text {
            if text.count == 0 {
                //disable the send button
                self.sendButton.isEnabled = false
                self.sendButton.alpha = 0.6
            } else {
                //enable the send button
                self.sendButton.isEnabled = true
                self.sendButton.alpha = 1
            }
        }
    }
}
