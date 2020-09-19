/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of medications.
*/

import SwiftUI

struct MedicationList: View {
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $userData.showFavoritesOnly) {
                    Text("Show Essential Only")
                }
                
                ForEach(userData.medications) { medication in
                    if !self.userData.showFavoritesOnly || medication.isFavorite {
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
