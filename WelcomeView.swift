//
//  WelcomeView.swift
//  MyMeds
//
//  Created by Dave Carlton on 9/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

//struct OneView: View {
//    var body: some View {
//        Text("Text")
//    }
//}

struct WelcomeView: View {
    var body: some View {
        TabView {
//            ExtractedView()
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Third")
                }
        }
        .font(.headline)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView()
        }
    }
}

