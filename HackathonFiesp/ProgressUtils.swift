//
//  ProgressUtils.swift
//  HackathonFiesp
//
//  Created by Raul Brito on 06/08/17
//  Copyright © 2016 Raul Brito. All rights reserved.
//

import Foundation
import SVProgressHUD

class ProgressUtils {
    
    static func configure() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(0.3)
    }
    
    static var isVisible: Bool {
        return SVProgressHUD.isVisible()
    }
    
    static func show() {
        SVProgressHUD.show(withStatus: NSLocalizedString("loading", comment: ""))
    }
	
}
