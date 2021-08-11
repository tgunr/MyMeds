//
//  NotifyDetailView.swift
//  MyMeds
//
//  Created by Dave Carlton on 8/5/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

struct NotifyButtonOnOff: ButtonStyle {
    let onoff: Bool
    
    init(_ switsh: Bool) {
        self.onoff = switsh
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 110, height: 35, alignment: .center)
            .background(self.onoff ? Color.blue : Color.white)
            .foregroundColor(self.onoff ? Color.white : Color.gray)
            .cornerRadius(30)
            .overlay(RoundedRectangle(cornerRadius: 30) .stroke(self.onoff ? Color.blue : Color.gray, lineWidth: 1))
    }
}

struct NotifyButtonView: View {
    @EnvironmentObject var userData: UserData
    @State private var n = true
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        Toggle(isOn: $n) {
            Text("Notify")
        }
    }
}

struct NotifyDetailView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        let level = medication.notifylevel
        
        VStack {
            Text("Notification")
                .font(.title)
                .fontWeight(.bold)
            .padding(.top)
            HStack {
                Spacer()
            }
            Form {
                Section(header: Text("Notify at percentage left")) {
                    Text("\(level)")
                }
                NotifyButtonView(medication: medication)
            }
        }
        
    }
}

struct NotifyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistentStore.shared.mco
        let testItems = TestItems(context: context)
        //        testItems.reset()
        let med = testItems.getFirst()
        med.name = "Med Preview"
        return NotifyDetailView(medication: med)
    }
}
