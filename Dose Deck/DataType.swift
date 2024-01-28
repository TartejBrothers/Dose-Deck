//
//  DataType.swift
//  Dose Deck
//
//  Created by Taranjeet Singh Bedi on 26/01/24.
//

import SwiftUI
// Creating the reference DataType
struct DataType: Identifiable {
    var id: String
    var userId: String 
    var medicine: String
    var hours: Int
    var minutes: Int
    var isSelected: Bool
}
