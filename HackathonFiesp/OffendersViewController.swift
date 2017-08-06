//
//  OffendersViewController.swift
//  HackathonFiesp
//
//  Created by Raul Brito on 05/08/17.
//  Copyright © 2017 Raul Brito. All rights reserved.
//

import UIKit
import Firebase

class OffendersViewController: UIViewController {
	
	// MARK: Properties
	
	var offenders: [Offender] = []
	
	var exists: Bool = false
	
	lazy var offenderRef: DatabaseReference = Database.database().reference().child("conversas")
	private var offenderRefHandle: DatabaseHandle?
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return .lightContent
	}
	
	@IBOutlet weak var tableView: UITableView!
	
	
	// MARK: ViewController Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.view.backgroundColor = .black
		
		Auth.auth().signInAnonymously(completion: { (user, error) in
			//			self.getOffendersBy(profileID: user.id ?? "")
			
			self.observeChats()
		})
	}
	
	deinit {
		if let refHandle = offenderRefHandle {
			offenderRef.removeObserver(withHandle: refHandle)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		UIApplication.shared.statusBarStyle = .lightContent
		
		navigationController?.navigationBar.barTintColor = UIColor.white
		navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
	}
	
	
	// MARK: Methods
	
	func updateTableData(id: String, offenderData: Dictionary<String, AnyObject>, eventType: String) {
		if let name = offenderData["nome"] as! String!, name.characters.count > 0 {
			let offender = [
				"id": id,
				"nome": offenderData["nome"] ?? "",
				"telefone": offenderData["telefone"] ?? "",
				"nivelPerigo": offenderData["nivelPerigo"] ?? "",
				"qtdMsg": offenderData["qtdMsg"] ?? 0
				] as [String : Any]
			
			for offenderItem in self.offenders {
				if offenderItem.id == id {
					exists = true
				}
			}
			
			if !exists {
				self.offenders.append(Offender(offender))
				self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
			}
		} else {
			print("Error! Could not decode channel data")
		}
	}
	
	private func observeChats() {
		offenderRefHandle = offenderRef.observe(.childAdded, with: { (snapshot) -> Void in
			let offenderData = snapshot.value as! Dictionary<String, AnyObject>
			
			self.updateTableData(id: snapshot.key, offenderData: offenderData, eventType: "added")
		})
		
		offenderRefHandle = offenderRef.observe(.childRemoved, with: { (snapshot) -> Void in
			let offenderData = snapshot.value as! Dictionary<String, AnyObject>
			
			self.updateTableData(id: snapshot.key, offenderData: offenderData, eventType: "removed")
		})
		
		offenderRefHandle = offenderRef.observe(.childChanged, with: { (snapshot) -> Void in
			let offenderData = snapshot.value as! Dictionary<String, AnyObject>
			
			self.updateTableData(id: snapshot.key, offenderData: offenderData, eventType: "changed")
		})
	}
	
	
	// MARK: Segue
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		if let offender = sender as? Offender {
			let offenderVc = segue.destination as! OffenderViewController
			
			if offender.nivelPerigo > 60.0 {
				offenderVc.status = "high"
			} else if offender.nivelPerigo > 20.0 {
				offenderVc.status = "medium"
			} else {
				offenderVc.status = "low"
			}
			
			offenderVc.offender = offender
			offenderVc.offenderRef = offenderRef.child(offender.id)
		}
	}
	
}


// MARK: Extensions

extension OffendersViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return offenders.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OffenderTableViewCell") as! OffenderTableViewCell
		
		cell.setOffender(offenders[indexPath.row])
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 74
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		performSegue(withIdentifier: "SuspectSegue", sender: offenders[(indexPath as NSIndexPath).row])
	}
}
