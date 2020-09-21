/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of medications.
*/

import SwiftUI

struct AddMedication: View {
    @EnvironmentObject private var userData: UserData
    @State var delegate: NavigationDelegate?
//    var medication: Medication

    var body: some View {
        Button(action: {
            let newMed = Medication()
            userData.medications.append(newMed)
            MedicationDetail(medication: newMed)
//            self.delegate?.moveTo(view: .welcome)
        }, label: {
            Text("Add")
        })
    }
}

struct MedicationList: View {
    @EnvironmentObject private var userData: UserData
    @State var delegate: NavigationDelegate?
    @State private var addMode = false

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $userData.showEssentailOnly) {
                    Text("Show Essential Only")
                }
                
                ForEach(userData.medications) { medication in
                    if !self.userData.showEssentailOnly || medication.essentail {
                        NavigationLink(
                            destination: MedicationDetail(medication: medication)
                                .environmentObject(self.userData)
                        ) {
                            MedicationRow(medication: medication)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Medications"))
            .navigationBarItems(trailing: Button(action: {
                 // button activates link
                  self.addMode = true
                } ) {
                Image(systemName: "plus")
                    .resizable()
                    .padding(6)
                    .frame(width: 24, height: 24)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            } )

            // invisible link inside NavigationView for add mode
//            NavigationLink(destination:
//                            MedicationDetail(medication: Medication()).environmentObject(self.userData),
//                isActive: $addMode) { EmptyView() }
        }
    }
}

struct MedicationsList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            MedicationList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .environmentObject(UserData())
    }
}
