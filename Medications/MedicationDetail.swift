/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a medication.
*/

import SwiftUI

struct MedicationDetail: View {
    @EnvironmentObject var userData: UserData
    var medication: Medication
    
    var medicationindex: Int {
        userData.medications.firstIndex(where: { $0.id == medication.id })!
    }
    
    var body: some View {
        VStack {
            MapView(coordinate: medication.locationCoordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            CircleImage(image: medication.image)
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(medication.name)
                        .font(.title)
                    
                    Button(action: {
                        self.userData.medications[self.medicationindex]
                            .isFavorite.toggle()
                    }) {
                        if self.userData.medications[self.medicationindex]
                            .isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    Text(medication.park)
                        .font(.subheadline)
                    Spacer()
                    Text(medication.state)
                        .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

struct MedicationDetail_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return MedicationDetail(medication: userData.medications[0])
            .environmentObject(userData)
    }
}
