
import SwiftUI
import Combine 

struct TextPreviewView: View {   
    @Binding var text: String 
    @State private var placeholder: String = "The scanner was unable to recognize any text"
        @State private var placeholder2: String = "Try scanning again or typing something long down below "
    @State private var wordCount: Int =  0 
     let manager = Managerclass.shared
    
    var body: some View {   
        VStack{
            
            TimerView()
                .padding()
            Text("Word count: \(wordCount)")
                .padding(.top,   10)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
            Divider()
            VStack {
                if text.isEmpty {
                    VStack{
                        Text(placeholder)
                            .padding(.leading, 20)
                            .padding(.top, 75)
                            .foregroundStyle(.red)
                            .font(.title3)
                            .fontWeight(.regular)
                        Text(placeholder2)
                            .fontWeight(.light)
                            .font(.caption)
                    }
                }
                TextEditor(text: $text)
                    .padding()
                    .font(.callout)
                    .onReceive(Just(text)) { newText in
                        let textComponents = newText.components(separatedBy: .whitespacesAndNewlines)
                        wordCount = textComponents.filter { !$0.isEmpty }.count
                        manager.wordCount = wordCount
                    }

                
            }
        }
    }
}
