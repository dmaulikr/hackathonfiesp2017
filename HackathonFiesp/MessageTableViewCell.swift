//
//  MessageTableViewCell.swift
//  HackathonFiesp
//
//  Created by Raul Brito on 05/08/17.
//  Copyright © 2017 Raul Brito. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var precisionLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var hourLabel: UILabel!
	
	var darkGray = UIColor.black
	var lighterGray = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
	
	func setMessage(_ message: Message, status: String) {
		if status == "medium" {
			titleLabel.textColor = darkGray
			hourLabel.textColor = darkGray
			
			precisionLabel.textColor = lighterGray
			dateLabel.textColor = lighterGray
		}
	
        titleLabel.text = message.texto
        precisionLabel.text = "\(message.nivelPerigo ?? 0)% de assertividade"
		dateLabel.text = message.dataEnvio
		hourLabel.text = message.horaEnvio
    }
	
}
