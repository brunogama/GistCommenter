//
//  ChangeStatusModel.swift
//  GistCommenter
//
//  Created by Bruno Gama on 23/03/2018.
//  Copyright © 2018 Bruno Gama. All rights reserved.
//

import Foundation

internal struct ChangeStatusModel: Codable, CodableExtension {
    let additions: Int
    let deletions: Int
    let total: Int
}
