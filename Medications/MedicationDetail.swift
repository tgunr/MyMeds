//  MedicationDetail.swift
//  MyMeds
//
//  Created by Dave Carlton on 12/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//
// Abstract:
// A view showing the details for a medication.

import SwiftUI
import CoreData

extension Medicine {
    public var wrappedName: String {
        get { name ?? "NoName" }
        set { name = newValue }
    }

//    public dynamic class func fetchOne() -> NSFetchRequest<Medicine> {
//        return NSFetchRequest<Medicine>(entityName: "Medicine")
//    }

}

struct TopView: View {
//    @ObservxedObject var medication: FetchedResults<Medicine>.Element
    @ObservedObject var medication: Medicine

//    var medication: FetchedResults<Medicine>.Element
    @State var mednameField: String = ""

    var body: some View {
        VStack {
            CircleImage(name: medication.imagename!)
            HStack() {
                TextField("Medication name", text: $medication.wrappedName)
//                    medication.name = self.mednameField
//                })
                EssentialButtonView(medication: medication)
                Spacer()
            }
        }
    }
}

struct EssentialButtonView: View {
    var medication: FetchedResults<Medicine>.Element

    var body: some View {
        Button(action: {
            medication.essential.toggle()
        }) {
            if medication.essential {
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
            } else {
                Image(systemName: "star")
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct FrequencyView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        HStack(alignment: .top) {
            let frequency = medication.frequency
            //            let interval = medication.interval
            Text("Frequency:")
                .font(.headline)
            if frequency == 1 {
                Text("Every Hour")
            } else {
                Text("Every \(frequency)")

            }
            Spacer()
        }
    }
}

struct RemainingView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        HStack {
            Text("Remaining: ")
                .font(.headline)
            Text("\(medication.quantity)")
            //            Text("\(medication.kind )s")
            Spacer()
        }
    }
}

struct RefillView: View {
    var medication: FetchedResults<Medicine>.Element
    static var formatter = DateFormatter()
    var body: some View {
        let refilled = medication.refilled
        //        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        //        formatter.timeStyle = .short

        HStack {
            //            Self.formatter.dateStyle = .long
            Text("Refill Date: \((refilled!.addingTimeInterval(0)), style: .date)")
            if #available(iOS 14.0, *) {
                Text(Date().addingTimeInterval(0), style: .date)
            } else {
                // Fallback on earlier versions
            }
            Spacer()
        }
    }
}

struct MedicationDetail: View {
    @FetchRequest(entity: Medicine.entity(), sortDescriptors: [])
    var medications: FetchedResults<Medicine>
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        VStack() {
            TopView(medication: medication)
//            FrequencyView(medication: medication)
//            RemainingView(medication: medication)
//            RefillView(medication: medication)
            NavigationView {
                VStack {
                    HStack {
                        NavigationLink("Frequency Detail",
                                       destination: FrequencyView(medication: medication))
                        Spacer()
                    }
                    HStack {
                        NavigationLink("Dosage Detail",
                                       destination: DosageDetailView(medication: medication))
                        Spacer()
                    }
                    HStack {
                        NavigationLink("Notification Detail",
                                       destination: NotifyDetailView(medication: medication))
                        Spacer()
                    }
                }
                .navigationViewStyle(.automatic)
            }
        }
    }
}

struct MedicationDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistentStore.shared.mco
        let testItems = TestItems(context: context)
        //        testItems.reset()
        let med = testItems.getFirst()
        med.name = "Med Preview"
        return NavigationView {
            MedicationDetail(medication: med)
        }
        .preferredColorScheme(.dark)
    }
}
