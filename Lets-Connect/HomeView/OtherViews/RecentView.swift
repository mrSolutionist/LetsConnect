//
//  RecentView.swift
//  Lets-Connect
//
//  Created by HD-045 on 30/04/23.
//

import SwiftUI

struct RecentView: View {
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Capsule()
                    .frame(width: 30,height: 8)
                Spacer()
            }
            
            .padding()
            Spacer()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                Spacer()
        }
        .foregroundColor(Color("Secondary"))
        .background(Color("Primary"))
        .cornerRadius(10)
    }
}

struct RecentView_Previews: PreviewProvider {
    static var previews: some View {
        RecentView()
    }
}
