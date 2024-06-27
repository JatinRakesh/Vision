import SwiftUI

struct TimerView: View {
    @ObservedObject var managerClass = Managerclass.shared
    @State private var showReadings = false
    @State private var showNewRecordSheet = false 
    @State private var newRecordScore: Double?
  
    var body: some View {
        VStack {
            Text(String(format: "%.2f", managerClass.secondElapsed))
                .bold()
                .padding()
                .font(.title2)
            switch managerClass.mode {
            case .stopped:
                Button(action: {
                    managerClass.start()
                }, label: {
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .background(Color.indigo)
                        .cornerRadius(100)
                        .clipShape(Circle())
                        .buttonStyle(.borderless)
                })
            case .running:
                HStack {
                    Button(action: {
                        managerClass.stop()
                    }, label: {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(100)
                            .clipShape(Circle())
                            .buttonStyle(.borderless)
                    })
                    Button(action: {
                        managerClass.pause()

                    }, label: {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(100)
                            .clipShape(Circle())
                            .buttonStyle(.borderless)
                    })
                }
            case .pause:
                HStack {
                    Button(action: {
                        managerClass.start()
                    }, label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                            .background(Color.indigo)
                            .cornerRadius(100)
                            .clipShape(Circle())
                            .buttonStyle(.borderless)
                    })
                    
                    Button(action: {
                        showReadings = true 
                    }, label: {
                        Image(systemName: "list.dash")
                            .foregroundColor(.black)
                            .font(.title)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(100)
                            .clipShape(Circle())
                            .buttonStyle(.borderless)
                    })
                }
            }
        }
        .sheet(isPresented: $managerClass.showAverageWordsPerSecond) {
            AverageWordsPerMinuteView(wordsPerMinute:  managerClass.wordsPerMinute, onDismiss: {managerClass.resetElapseTime()
            })
        }
        .sheet(isPresented: $showReadings){ 
            ReadingsView(managerClass: managerClass)
        }
        
    }
    
    
}

enum Mode {
    case running
    case stopped
    case pause
}

class Managerclass: ObservableObject {
    @Published var secondElapsed =  0.0
    @Published var mode: Mode = .stopped
    @Published var showAverageWordsPerSecond = false
    @Published var wordsPerMinute: Double =  0
    @Published var readings: [Double] = []
    @ObservedObject var rc = RecognizedContent()
    static let shared = Managerclass() 
    private init(){}
    var timer = Timer()
    @Published var wordCount: Int =  0
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval:  0.1, repeats: true) { _ in
            self.secondElapsed +=  0.1

        }
    }
    func resetElapseTime() { 
      secondElapsed = 0
    }
    
    func stop() {
        timer.invalidate()
        secondElapsed =  0
        mode = .stopped
    }
    
    func pause() {
        timer.invalidate()
        mode = .pause
        showAverageWordsPerSecond = true
        wordsPerMinute = Double(calculateWordsPerMinute())
        readings.append(wordsPerMinute)
        print("Words per minute calculated: \(wordsPerMinute)")

           }
    
    func calculateWordsPerMinute() -> Double {
        print("WordCount: \(wordCount)")
        let totalWords = wordCount
        guard totalWords >  0 && secondElapsed >  0 else {
            print("No words/time elapsed.")
            return  0.0
        }
        
        let wordsPerSecond = Double(totalWords) / secondElapsed
        let wordsPerMinute = wordsPerSecond *  60
        let roundedWordsPerMinute = wordsPerMinute.rounded()
        
        print("Words per minute calculated: \(roundedWordsPerMinute)")
        return roundedWordsPerMinute
    }

    
}




struct AverageWordsPerMinuteView: View {
    let wordsPerMinute: Double
    @Environment(\.presentationMode) var presentationMode
    let onDismiss: () -> Void  
    @State private var animatedText: String = ""
    var formattedWordsPerMinute: String {
        return wordsPerMinute.truncatingRemainder(dividingBy:   1) ==   0
        ? String(format: "%.0f", wordsPerMinute)
        : String(wordsPerMinute)
    }
   @State private var showButton = false
    var sentenceWithWordsPerMinute: String {
        return "You've read about \(formattedWordsPerMinute) words per minute."
    }
    var body: some View {
        NavigationView{
            VStack {
                Text(animatedText)
                    .padding()
                    .fontWeight(.medium)
                    .onAppear{ 
                        typeWriter()
                    }
                if showButton{
                    Button(action: {
                        withAnimation{
                            onDismiss()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack{
                        Text("Got it")
                                .padding(.top,30)
                                .foregroundStyle(.green)
                                .fontWeight(.semibold)
                        Image(systemName: "checkmark.circle")
                            .padding(.top, 30)
                            .foregroundStyle(.green)
                            .fontWeight(.semibold)
                            .font(.subheadline)
                        
                    }
                    }
              .animation(.spring(), value: showButton) 
                }
            }
        
        }
    }
    func typeWriter() {
        let characters = Array(sentenceWithWordsPerMinute)
        for (index, character) in characters.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) *  0.1) {
                animatedText.append(character)
                if index == characters.count -  1 { 
                    DispatchQueue.main.asyncAfter(deadline: .now() +  0.1) { 
                        showButton = true 
                    }
                }
                }
        }
    }
}

                    
struct ReadingsView: View {
    @ObservedObject var managerClass: Managerclass = Managerclass.shared
       var body: some View {
           NavigationView {
            Form {
                let sortedIndexes = managerClass.readings.indices.sorted{managerClass.readings[$0] > managerClass.readings[$1]}
                ForEach(sortedIndexes, id: \.self) { index in
                    HStack{
                        Text("\(Int(managerClass.readings[index])) (WPM)")
                        Spacer()
                        if index == sortedIndexes.first { 
                            Text("Personal Best")
                                .foregroundStyle(.gray)
                                .bold()
                        }
                    }
                }
                        .onDelete(perform: deleteItem)
                }
            .navigationBarTitle("WPM History")
            .toolbar{ 
                ToolbarItem(placement: .navigationBarTrailing){ 
                    NavigationLink(destination: InfoFileView()){ 
                        HStack{ 
                            Image(systemName: "info.circle")
                            Text("Tips")
                        }
                    }
                }
            }
        }
    }
    private func deleteItem(offsets: IndexSet){ 
        managerClass.readings.remove(atOffsets: offsets)
    }
}

    
    struct TimerView_Previews: PreviewProvider {
        static var previews: some View {
            TimerView()
        }
    }


