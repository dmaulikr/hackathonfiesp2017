//
//  Offender.swift
//  HackathonFiesp
//
//  Created by Raul Brito on 05/08/17.
//  Copyright © 2017 Raul Brito. All rights reserved.
//

import Foundation
import Tailor

struct Offender: Mappable {
    var id = String()
    var nome = String()
    var telefone: String?
	var nivelPerigo: Double!
	var qtdMsg: Int!
    
    init(_ map: [String : Any]) {
        id <- map.property("id")
        nome <- map.property("nome")
        telefone <- map.property("telefone")
		nivelPerigo <- map.property("nivelPerigo")
		qtdMsg <- map.property("qtdMsg")
    }
}
