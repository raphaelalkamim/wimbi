//
//  CountdownWidgetView.swift
//  wimbWidgetExtension
//
//  Created by Beatriz Duque on 10/11/22.
//

import SwiftUI

struct CountdownWidgetView: View {
    var countdown = ""
    var nextTrip = ""
    var days = "days".localized()
    
    var body: some View {
        ZStack {
            Color(uiColor: UIColor(named: "backgroundWidget")!).edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                VStack {
                    // Text(entry.date, style: .time)
                    Text("Your trip to".localized())
                        .font(.custom("Avenir-Book", size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .colorInvert()
                    Text(nextTrip)
                        .font(.custom("Avenir-Medium", size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .colorInvert()
                    Text("will happen in".localized())
                        .font(.custom("Avenir-Book", size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .colorInvert()
                    
                    Text("\(countdown) \(days)")
                        .font(.custom("Avenir-Black", size: 35))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .colorInvert()
                    
                }.padding()
                VStack {
                    Image("bussolaWidget")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
            }
        }
    }
}

struct CountdownWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetView(countdown: "", nextTrip: "")
    }
}
