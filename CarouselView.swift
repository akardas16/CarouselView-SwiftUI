//
//  CourosialEffect.swift
//  PantoneChips
//
//  Created by Abdullah Kardaş on 12.03.2023.
//

import SwiftUI

struct CarouselView: View {
    var body: some View {
            
        ZStack {
            
            Color.indigo.opacity(0.5).ignoresSafeArea()
            VStack {
                Carousel(items: Item.items, duration: 2.0) { item in
                    VStack {
                        Spacer()
                        Image(systemName: item.image).font(.largeTitle).foregroundColor(.white)
                        Spacer()
                        VStack(spacing:12) {
                            Text(item.title).font(.title2.bold()).foregroundColor(.white)
                            Text(item.description)
                                .foregroundColor(.white.opacity(0.9)).font(.subheadline).multilineTextAlignment(.center).padding(.horizontal,4)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
