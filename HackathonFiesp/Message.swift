//
//  Message.swift
//  HackathonFiesp
//
//  Created by Raul Brito on 06/08/17.
//  Copyright © 2017 Raul Brito. All rights reserved.
//

import Foundation
import Tailor

struct Message: Mappable {
    var id = String()
    var texto: String?
	var dataEnvio: String?
	var horaEnvio: String?
	var nivelPerigo: Double!
    
    init(_ map: [String : Any]) {
        id <- map.property("id")
        texto <- map.property("texto")
		dataEnvio <- map.property("dataEnvio")
		horaEnvio <- map.property("horaEnvio")
		nivelPerigo <- map.property("nivelPerigo")
    }
}
