//
//  OffenderViewController.swift
//  HackathonFiesp
//
//  Created by Raul Brito on 05/08/17.
//  Copyright © 2017 Raul Brito. All rights reserved.
//

import UIKit
import Firebase

class OffenderViewController: UIViewController {
	
	// MARK: Properties
	
	var offenderRef: DatabaseReference?
	var offender: Offender?
	
	var messages: [Message] = []
	
	var exists: Bool = false
	
	var status: String = "high"
	
	var darkGray = UIColor.black
	var lighterGray = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
	
	lazy var messageRef: DatabaseReference = self.offenderRef!.child("mensagens")
	private var newMessageRefHandle: DatabaseHandle?
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		if status == "medium" {
			return .default
		} else {
			return .lightContent
		}
	}
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var phoneTitleLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var evidenceTitleLabel: UILabel!
	@IBOutlet weak var messagesCountLabel: UILabel!
	
	
	// MARK: ViewController Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = .clear
		
		var statusText = ""
		
		if let offender = offender {
			if offender.nivelPerigo >= 60.0 {
				statusText = "criminoso em potencial"
				self.view.backgroundColor = .red
				self.navigationController?.navigationBar.barTintColor = UIColor.white
				navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
				
				self.navigationController?.navigationBar.tintColor = UIColor.white
				
				status = "high"
			} else if offender.nivelPerigo >= 20 {
				statusText = "possível criminoso"
				self.view.backgroundColor = UIColor(red: 255/255, green: 208/255, blue: 52/255, alpha: 1)
				
				phoneLabel.textColor = lighterGray
				nameLabel.textColor = darkGray
				statusLabel.textColor = lighterGray
				messagesCountLabel.textColor = lighterGray
				phoneTitleLabel.textColor = darkGray
				evidenceTitleLabel.textColor = darkGray
				
				self.navigationController?.navigationBar.barTintColor = UIColor.black
				navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkGray]
				
				self.navigationController?.navigationBar.tintColor = UIColor.black
				
				status = "medium"
			} else {
				statusText = "sob vigilância"
				self.view.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 187/255, alpha: 1)
				
				self.navigationController?.navigationBar.barTintColor = UIColor.white
				navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
				
				self.navigationController?.navigationBar.tintColor = UIColor.white
				
				status = "low"
			}
			
			phoneLabel.text = offender.telefone
			nameLabel.text = offender.nome
			statusLabel.text = statusText
			messagesCountLabel.text = "\(offender.qtdMsg ?? 0) mensagens suspeitas"
		}
		
		observeMessages()
	}
	
	
	// MARK: Methods
	
	private func observeMessages() {
		if offenderRef != nil {
			messageRef = offenderRef!.child("mensagens")
			
			let messageQuery = messageRef.queryLimited(toLast: 500)
			
			newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
				
				let messageData = snapshot.value as! Dictionary<String, Any>
				
				if let texto = messageData["texto"] as? String, texto.characters.count > 0 {
					let message = [
						"id": snapshot.key,
						"texto": messageData["texto"] ?? "",
						"dataEnvio": messageData["dataEnvio"] ?? "",
						"horaEnvio": messageData["horaEnvio"] ?? "",
						"nivelPerigo": messageData["nivelPerigo"] ?? ""
						] as [String : Any]
					
					for messageItem in self.messages {
						if messageItem.id == snapshot.key {
							self.exists = true
						}
					}
					
					if !self.exists {
						self.messages.append(Message(message))
						self.tableView.reloadData()
					}
				} else {
					print("Error! Could not decode message data")
				}
			})
		}
	}
	
}


// MARK: Extensions

extension OffenderViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
		
		cell.setMessage(messages[indexPath.row], status: status)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
