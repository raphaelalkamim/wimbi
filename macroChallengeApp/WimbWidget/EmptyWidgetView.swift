//
//  EmptyWidgetView.swift
//  wimbWidgetExtension
//
//  Created by Beatriz Duque on 10/11/22.
//

import SwiftUI

struct EmptyWidgetView: View {
    var body: some View {
        ZStack {
            Color(uiColor: UIColor(named: "backgroundWidget")!).edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                VStack {
                    Text("How about creating a new roadmap?".localized())
                        .font(.custom("Avenir-Black", size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .colorInvert()
                    Text("Click here and create or duplicate a roadmap".localized())
                        .font(.custom("Avenir-Book", size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .colorInvert()
                }
                VStack {
                    Image("emptyWidget")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
            }
        }
    }
}

struct EmptyWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyWidgetView()
    }
}
