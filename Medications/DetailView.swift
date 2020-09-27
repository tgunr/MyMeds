//
//  DetailView.swift
//  MyMeds
//
//  Created by Dave Carlton on 9/27/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared

        DetailView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
