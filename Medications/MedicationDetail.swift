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

//extension Medicine {
////        @NSManaged public var name: String?
//    public var wrappedName: String {
//        get{name ?? "NoName"}
//        set{name = newValue}
//    }
//    
//    public dynamic class func fetchOne() -> NSFetchRequest<Medicine> {
//        return NSFetchRequest<Medicine>(entityName: "Medicine")
//    }
//
//}

struct TopView: View {
//    @ObservedObject var medication: FetchedResults<Medicine>.Element
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        CircleImage(name: medication.imagename!)
            .padding(.top)
        HStack() {
//            TextField("Enter text", text: $medication.wrappedName)
            Text(verbatim: medication.name! )
                .font(.title)
            EssentialButtonView(medication: medication)
            Spacer()
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

struct DosageView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        let frequency = medication.frequency
        Section(header: Text("Dosage")
                    .font(.subheadline)
        ) {
            HStack(alignment: .top) {
                let dose = medication.dosage
                let dosageString = "\(dose) \(medication.kind ?? "kind")"
                Text(dosageString)
                    .font(.subheadline)
                if frequency == 1 {
                    Text("Every Hour")
                } else {
                    Text("Every \(frequency)")
                    
                }
                Spacer()
            }
            .padding(.top, 2.0)
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
            Text("Refill Date: \((refilled!.addingTimeInterval(0)),style: .date)")
            if #available(iOS 14.0, *) {
                Text(Date().addingTimeInterval(0),style: .date)
            } else {
                // Fallback on earlier versions
            }
            Spacer()
        }
    }
}

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


struct NotifyView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        let level = medication.notifylevel
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

struct MedicationDetail: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        VStack() {
            VStack() {
                TopView(medication: medication)
                DosageView(medication: medication)
                FrequencyView(medication: medication)
                RemainingView(medication: medication)
                RefillView(medication: medication)
                NotifyView(medication: medication)
            }
            Spacer()
        }
    }
}

struct MedicationDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistentStore.shared.mco
        let testItems = TestItems(context: context)
        testItems.reset()
        let m = testItems.getFirst()
        m.name = "Med Preview"
        return NavigationView {
            MedicationDetail(medication: m)
        }
        .preferredColorScheme(.dark)
    }
}
