//
//  Carousel.swift
//
//  Created by Abdullah Kardaş on 12.03.2023.
//

import SwiftUI

import SwiftUI
import Combine


struct Carousel<Content:View>: View {
    
    let timer:Publishers.Autoconnect<Timer.TimerPublisher>
    
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    @State var activeIndex: Int = 0
    let items:[Item]
    var duration:Double = 2
    
    let content:(Item) -> Content

    
    init(items:[Item],duration:Double, @ViewBuilder content: @escaping (Item) -> Content) {
        self.timer = Timer.publish(every: duration, on: .main, in: .common).autoconnect()
        self.items = items
        self.duration = duration
        self.content = content
    }
    
   
    var body: some View {
            ZStack {
                ForEach(items) { item in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(items.firstIndex(of:item) == activeIndex ? Color(hex: "36213e"):Color(hex: "554971"))
                        .shadow(color: .black, radius: items.firstIndex(of:item) == activeIndex ? 8:4,y:items.firstIndex(of:item) == activeIndex ? 8:0)
                        .overlay(content: {
                            content(item)
                        })
                    .frame(width: 200, height: 200)
                    .scaleEffect(1.0 - abs(distance(item.id)) * 0.28)
                    .opacity(1.0 - abs(distance(item.id)) * 0.05 )
                    .offset(x: myXOffset(item.id), y: 0)
                    .zIndex(1.0 - abs(distance(item.id)) * 0.1).animation(.spring(), value: item.id)
                    
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        draggingItem = snappedItem + value.translation.width / 300
                        print("\(draggingItem) -- \(snappedItem)")
                    }
                    .onEnded { value in
                        withAnimation {
                            draggingItem = snappedItem + value.predictedEndTranslation.width / 300
                            draggingItem = round(draggingItem).remainder(dividingBy: Double(items.count))
                            snappedItem = draggingItem

                            //Get the active Item index
                            self.activeIndex = items.count + Int(draggingItem)
                            if self.activeIndex > items.count || Int(draggingItem) >= 0 {
                                self.activeIndex = Int(draggingItem)
                            }
                            
                        }
                    }
            )
            .onReceive(timer) { value in
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    draggingItem -= 1
                    snappedItem -= 1
                    activeIndex = Int(draggingItem.magnitude) % items.count
                }
        }
            .onDisappear{
                timer.upstream.connect().cancel()
            }
        
    }
    
    func distance(_ item: Int) -> Double {
    
        return (draggingItem + Double(item)).remainder(dividingBy: Double(items.count))
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(items.count) * distance(item)
        return sin(angle) * 200
    }
}

struct Carousel_Previews: PreviewProvider {
   
    static var previews: some View {
                        Carousel(items: Item.items,duration: 2.0) { item in
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

struct Item: Identifiable,Equatable {
    var id: Int
    var title: String
    var description:String 
    var image:String
    
    //Example Model
    static var items:[Item] =  [
        Item(id: 0, title: "Duration",description: "Get unlimited duration every month", image: "clock.fill"),
        Item(id: 1, title: "Save", description: "Don't lose your\ndocuments",image: "paperclip"),
        Item(id: 2, title: "Security",description: "Secure your documents every time", image: "lock.fill"),
        Item(id: 3, title: "FaceID",description: "Unlock your documents\nwith FaceID", image: "faceid"),
        Item(id: 4, title: "Themes",description: "Discover premium\nthemes", image: "paintpalette.fill"),
        Item(id: 5, title: "Musics",description: "Play your favorite musics", image: "music.quarternote.3"),
        Item(id: 6, title: "Download",description: "Download your favorite\nmovies", image: "icloud.and.arrow.down.fill"),
        Item(id: 7, title: "Duration",description: "Get unlimited duration every month", image: "clock.fill"),
        Item(id: 8, title: "Save", description: "Don't lose your\ndocuments",image: "paperclip"),
        Item(id: 9, title: "Security",description: "Secure your documents every time", image: "lock.fill"),
        Item(id: 10, title: "FaceID",description: "Unlock your documents\nwith FaceID", image: "faceid"),
        Item(id: 11, title: "Themes",description: "Discover premium\nthemes", image: "paintpalette.fill"),
     
    ]
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
