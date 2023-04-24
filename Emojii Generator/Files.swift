//
//  Files.swift
//  Emojii Generator
//
//  Created by Tom on 2023-04-23.
//

import SwiftUI

struct Files: View {
    @State private var searchText = ""
    var body: some View {
        VStack{
            Divider()
            NavigationStack {
            }
            .searchable(text: $searchText)
            .background(Color(UIColor(red: CGFloat(0xf3) / 255, green: CGFloat(0xe1) / 255, blue: CGFloat(0xa1) / 255, alpha: 0.625)))
            Spacer()
        }
        .background(Color(UIColor(red: CGFloat(0xf3) / 255, green: CGFloat(0xe1) / 255, blue: CGFloat(0xa1) / 255, alpha: 0.625)))
    }
}

struct Files_Previews: PreviewProvider {
    static var previews: some View {
        Files()
    }
}
