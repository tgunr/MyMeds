import UIKit
import SwiftUI

final class MedData: ObservableObject {
    @Published var showEssentialOnly = false
    @Published var med = Medication()
}


import PlaygroundSupport

struct TopView: View {
    @State var medication: Medication
    
    var body: some View {
        CircleImage(name: medication.imagename)
            .padding(.top)
        HStack(
            spacing: 10
        ) {
            Spacer()
            TextField("Enter text", text: $medication.name)
//            EssentialButtonView(medication: medication)
        }
    }
}

struct MedicationDetail: View {
    var med: Medication
    var body: some View {
        VStack() {
            VStack() {
                TopView(medication: med)
                Spacer()
            }
        }
    }
}

struct ContentView: View {
    var med = Medication()
    var body: some View {
        MedicationDetail(med: med)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
