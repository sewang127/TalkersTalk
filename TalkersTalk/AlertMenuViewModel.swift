//
//  AlertMenuViewModel.swift
//  TalkersTalk
//
//  Created by Se Wang Oh on 9/11/18.
//  Copyright © 2018 SWO. All rights reserved.
//

import UIKit

protocol LobbyAlertMenuViewModelDelegate: class {
    
    func onChangeNameActionClicked()
    func onBlockActionClicked()
    func onReportActionClicked()
    func onDevContactActionClicked()
    func onEULAActionClicked()
    
}

protocol AlertMenuViewPresentable: class {
    
    func getMenuActions() -> [UIAlertAction]
    
}

class LobbyAlertMenuViewModel: AlertMenuViewPresentable {
    
    weak var delegate: LobbyAlertMenuViewModelDelegate?
    
    func getMenuActions() -> [UIAlertAction]  {
        
        let changeNameAction = UIAlertAction(title: "Change User Name", style: UIAlertActionStyle.default, handler: { action in
            self.delegate?.onChangeNameActionClicked()
        })
        
        let blockAction = UIAlertAction(title: "Block User", style: UIAlertActionStyle.default, handler: { action in
            self.delegate?.onBlockActionClicked()
        })
        
        let reportAction = UIAlertAction(title: "Report User", style: UIAlertActionStyle.default, handler: { action in
            self.delegate?.onReportActionClicked()
        })
        
        let devContactAction = UIAlertAction(title: "Dev Contact", style: UIAlertActionStyle.default, handler: { action in
            self.delegate?.onDevContactActionClicked()
        })
        
        let endUserLicenseAction = UIAlertAction(title: "End User License Agreement", style: UIAlertActionStyle.default, handler: { action in
            self.delegate?.onEULAActionClicked()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        return [changeNameAction, blockAction, reportAction, devContactAction, endUserLicenseAction, cancelAction]
    }
    
}
