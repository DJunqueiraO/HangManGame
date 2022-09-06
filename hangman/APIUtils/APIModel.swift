//
//  APIModel.swift
//  amaroChallenge
//
//  Created by Josicleison on 03/09/22.
//

import Foundation

// MARK: - Slip

struct AdvicesSlip: Codable {
    
    let slip: Slip
}

struct Slip: Codable {
    
    let id: Int
    let advice: String
}
