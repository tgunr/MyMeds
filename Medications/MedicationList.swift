/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of medications.
 */

import SwiftUI
import CoreData

//struct AddMedication: View {
//    @EnvironmentObject private var userData: UserData
//    @State var delegate: NavigationDelegate?
//    //    var medication: Medication
//
//    var body: some View {
//        Button(action: {
//            let newMed = Medication()
//            userData.medications.append(newMed)
//            MedicationDetail(medication: newMed)
//            print("Tapped")
//        }, label: {
//            Text("Add")
//        })
//    }
//}

struct MedicationList: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var medications: FetchedResults<Medicine>
    
    @State private var addMode = false
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $userData.showEssentailOnly) {
                    Text("Show Essential Only")
                }
                
                ForEach(medications) { medication in
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
            .navigationBarTitle(Text("Meds"))
//            .navigationBarItems(trailing:
//                                    HStack {
//                                        let newItem = Medicine(context: viewContext)
//                                        let newView = MedicationDetail(medication: newItem)
//                                        NavigationLink(
//                                            destination: newView,
//                                            label: {
//                                                Image(systemName: "plus")
//                                                    .resizable()
//                                                    .padding(6)
//                                                    .frame(width: 24, height: 24)
//                                                    .background(Color.blue)
//                                                    .clipShape(Circle())
//                                                    .foregroundColor(.white)
//                                            })
//                                    }
//            )
        }
    }
}


// invisible link inside NavigationView for add mode
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
