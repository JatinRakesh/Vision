import SwiftUI

struct FactCard: Identifiable {
    var id: Int
    var fact: String
   
}

class CardStore: ObservableObject {
    @Published var cards: [FactCard]
    
    init() {
        cards = [
            FactCard(id:  0, fact: "Some speed reading experts can read as much as 1000 WPM"),
            FactCard(id:  1, fact: "The average speed reading for an adult is 250 WPM"),
            FactCard(id:  2, fact: "The normal reading speed when reading fast is 300 - 400 WPM"),
            FactCard(id:  3, fact: "To get a gist of a text, people read at a rate of about 300 - 400 WPM"),
            FactCard(id: 4, fact: "It helps in maintaining focus during reading sessions by improving reading efficiency "),
            FactCard(id: 5, fact: "It stimulates the mind and enhances cognitive abilities such as memory, creativity, and problem-solving"),
            FactCard(id: 6, fact: "Speed reading can broaden vocabulary and knowledge, enriching communication, critical thinking, and empathy")
            
        ]
    }
}

struct FunFactView: View {
    @StateObject var cardStore = CardStore()
    @State private var snappedItem =  0.0
    @State private var draggingItem =  0.0
    
    var body: some View {
      GeometryReader { geometry in
            ZStack {
                ForEach(cardStore.cards) { i in
                    VStack {
                        Text("Fun Facts")
                            .font(.footnote) 
                            .foregroundColor(.gray)
                        EachCardView(fact: i.fact, isActive: abs(distance(i.id)) <  0.01)
                            .frame(width:  200, height:  250)
                            .scaleEffect(1.0 - abs(distance(i.id)) *  0.5)
                            .opacity(1.0 - abs(distance(i.id)) *  0.3)
                            .offset(x: xOffset(i.id), y:  0)
                            .zIndex(1.0 - abs(distance(i.id)) *  0.1)
                            .onTapGesture {
                                withAnimation {
                                    draggingItem = Double(i.id)
                                }
                            }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .gesture(getDragGesture())
        }

    }
    
    private func getDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                draggingItem = snappedItem + value.translation.width /  100
            }
            .onEnded { value in
                withAnimation {
                    draggingItem = snappedItem + value.predictedEndTranslation.width /  100
                    draggingItem = round(draggingItem).remainder(dividingBy: Double(cardStore.cards.count))
                    snappedItem = draggingItem
                }
            }
    }
    
    func distance(_ cardId: Int) -> Double {
        return (draggingItem - Double(cardId)).remainder(dividingBy: Double(cardStore.cards.count))
    }
    
    func xOffset(_ cardId: Int) -> Double {
        let angle = Double.pi *  2 / Double(cardStore.cards.count) * distance(cardId)
        return sin(angle) *  200
    }
}

struct EachCardView: View {
    var fact: String
    var isActive: Bool
    var body: some View {
        
    
        RoundedRectangle(cornerRadius:  20)
            .fill(Color.yellow)
            .overlay(
                Text(fact)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
            )
        .shadow(color: isActive ? .indigo : .clear, radius: isActive ?  10 :  0, x:  0, y:  10)
    
    }
}

struct Fact_Previews: PreviewProvider {
    static var previews: some View {
        FunFactView()
    }
}

