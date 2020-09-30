/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that clips an image to a circle and adds a stroke and shadow.
*/

import SwiftUI

struct CircleImage: View {
    var name: String

    var body: some View {
        let theImage = Image.init(name)
        theImage
            .resizable()
            .clipShape(Circle())
            .frame(width: 48, height: 48)
            .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(name: "percocet")
            .preferredColorScheme(.dark)
            
    }
}
