//
//  OffenderTableViewCell.swift
//  HackathonFiesp
//
//  Created by Raul Brito on 05/08/17.
//  Copyright © 2017 Raul Brito. All rights reserved.
//

import UIKit

class OffenderTableViewCell: UITableViewCell {
	
	@IBOutlet weak var mainImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var statusView: UIView!
	
	func setOffender(_ offender: Offender, indexPath: Int) {
		mainImageView.image = UIImage(named: "\(indexPath)")
        titleLabel.text = offender.nome
        phoneLabel.text = offender.telefone
		
		if offender.nivelPerigo > 60.0 {
			statusView.backgroundColor = .red
		} else if offender.nivelPerigo > 20.0 {
			statusView.backgroundColor = UIColor(red: 255/255, green: 208/255, blue: 52/255, alpha: 1)
		} else {
			statusView.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 187/255, alpha: 1)
		}
    }

}
