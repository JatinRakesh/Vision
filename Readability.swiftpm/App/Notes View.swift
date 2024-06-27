//#-learning-task(getStartedWithApps)
import SwiftUI


class NotesModel: ObservableObject {
    @Published var notes: [Note] = []
    
    init() {
        loadNotes()
    }
    
    func addNote() {
        let newNote = Note(title: "New Note", text: "")
        notes.append(newNote)
        saveNotes()
    }
    
    func deleteNote(offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func saveNotes() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    
    func loadNotes() {
        if let savedNotes = UserDefaults.standard.data(forKey: "notes") {
            let decoder = JSONDecoder()
            if let loadedNotes = try? decoder.decode([Note].self, from: savedNotes) {
                notes = loadedNotes
            }
        }
    }
}





struct Note: Identifiable, Codable {
    var id = UUID()
    var title: String
    var text: String 
    var drawingData: Data? 
}


enum NoteViewState {
    case list
    case detail(Note)
}

struct NotesView: View {
    @EnvironmentObject var notesModel: NotesModel
    @State private var currentView: NoteViewState = .list
    @State private var popoveristrue = true 
    var body: some View {
        VStack {
            if case .list = currentView {
                Form {
                    ForEach(notesModel.notes.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.snappy) {
                                currentView = .detail(notesModel.notes[index])
                            }
                        }) {
                            HStack(alignment: .top) { 
                                VStack(alignment: .leading) {
                                    Text(notesModel.notes[index].title)
                                        .fontWeight(.medium)
                                        .accentColor(.indigo)
                                        .font(.title2)
                                        .multilineTextAlignment(.leading)
                                        .padding(.trailing,20)
                                    if !notesModel.notes[index].text.isEmpty {
                                        Text(String(notesModel.notes[index].text.prefix(50)).appending("..."))
                                            .lineLimit(1) 
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .padding(.top)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: deleteNote)
                }
                HStack{
                    Spacer()
                    Button(action:{  
                        withAnimation(.interactiveSpring){
                            notesModel.addNote()
                        }
                    }) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 60,height:48)
                                .foregroundStyle(.bar)
                                .padding()
                            Image(systemName: "plus.diamond")
                                .font(.title)
                                .accentColor(.indigo)
                                .padding()
                        }
                    }
                    .popover(isPresented: $popoveristrue){
                        HStack{ 
                            Image(systemName: "note.text.badge.plus")
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.leading,10)
                            Text("Click here to make your own simple notes")
                                .font(.headline)
                                .padding()
                        }
                    }
                }
            }  
            if case .detail(let note) = currentView {
                NoteDetailView(note: $notesModel.notes[notesModel.notes.firstIndex(where: { $0.id == note.id })!], onDismiss: {
                    currentView = .list
                })
            }
        }
    }
    
    private func deleteNote(offsets: IndexSet) {
        notesModel.deleteNote(offsets: offsets)
    }
    
}


struct NoteDetailView: View {
    @Binding var note: Note
    var onDismiss: () -> Void
    var body: some View {
        VStack {
            SelfNoteView(note: $note)
            Spacer()
            Button(action: {
                withAnimation(.easeOut){
                    onDismiss()
                    
                }
            })
            {
                Image(systemName: "checkmark.circle")
                    .font(.largeTitle)
                    .foregroundStyle(.green)
            }
            .padding()
            
        }
        
    }
    
    
    
}



