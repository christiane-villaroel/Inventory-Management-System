//
//  SideMenuHeaderView.swift
//  Invertory-App
//
//  Created by Brandon Mccoll on 10/30/24.
//

import SwiftUI

struct SideMenuHeaderView: View {
    var body: some View {
        HStack{
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.myColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
        
            VStack(alignment: .leading, spacing: 6){
                Text("Place Holder")
                    .font(.subheadline)
                Text("placeholder123@gmail.com")
                    .font(.footnote)
                    .tint(.gray)
                
            }
        }
    }
}

#Preview {
    SideMenuHeaderView()
}
