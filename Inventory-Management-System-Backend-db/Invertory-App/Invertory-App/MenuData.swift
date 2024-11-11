//
//  MenuData.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/2/24.
//

import Foundation
import SwiftUI
struct MenuData: Identifiable{
    let id = UUID()
    let title: String
    let image: String
    let dropdown: Bool
}
