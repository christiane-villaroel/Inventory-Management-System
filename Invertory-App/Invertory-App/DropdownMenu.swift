//
//  DropdownMenu.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/2/24.
//

import SwiftUI

struct DropdownMenu: View {
    @State private var isExpanded: Bool = false
    @State private var selectedOption: String = "Select an Option"
    let options = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        DisclosureGroup(selectedOption, isExpanded: $isExpanded) {
             VStack {
               ForEach(options, id: \.self) { option in
                 Text(option)
                   .padding()
                   .onTapGesture {
                     selectedOption = option
                     isExpanded = false
                   }
               }
             }
           }
           .padding()
           .background(Color.gray.opacity(0.1))
           .cornerRadius(8)
    }
}

#Preview {
    DropdownMenu()
}
