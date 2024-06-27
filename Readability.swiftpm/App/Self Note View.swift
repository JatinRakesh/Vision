import SwiftUI

struct SelfNoteView: View { 
    @Binding var note: Note
    var body: some View{
        VStack {
            TextField("Title", text: $note.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding()
            
            TextField("Make your personal notes here", text: $note.text, axis: .vertical)
                .font(.caption)
                .fontWeight(.light)
                .foregroundStyle(.secondary)
                .padding()
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
