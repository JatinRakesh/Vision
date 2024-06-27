import SwiftUI


struct HomeView: View {
    @ObservedObject var recognizedContent = RecognizedContent()
    @State private var showScanner = false
    @State private var isRecognizing = false
    @State var editingId: String? = nil
    @State private var showingAlert = false
    @State private var searchText = ""
    @State private var idea: Bool = false
    @Environment(\.presentationMode) var present
    @State private var showPopover = true

    
    var body: some View {
        NavigationView{
            
            VStack(alignment: .leading)
            {
                DisclosureGroup {
                    ForEach(recognizedContent.items.indices, id: \.self) { index in
                        if editingId == recognizedContent.items[index].id {
                            TextField("Title", text: $recognizedContent.items[index].Title)
                                .submitLabel(.done)
                                .onSubmit {
                                    editingId = nil
                                }
                        } else {
                            NavigationLink(destination: TextPreviewView(text: $recognizedContent.items[index].text)) {
                                HStack {
                                    Text(String(recognizedContent.items[index].Title))
                                    Image(systemName: "doc.text")
                                }
                                .padding(.bottom,  10)
                            }
                            .contextMenu {
                                Button(action: {
                                    editingId = recognizedContent.items[index].id
                                }) {
                                    Label("Rename", systemImage: "pencil")
                                }
                                Button(role: .destructive, action: {
                                    recognizedContent.items.remove(at: index)
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                
            label: { 
                Label("Reading Lists", systemImage: "book")
            }
            .accentColor(.indigo)
            .padding()
                NavigationLink(destination: NotesView()){ 
                    HStack{ 
                        Image(systemName: "note.text")
                        Text("Notes")
                    }
                    
                }
                .accentColor(.indigo)
                .padding()
                NavigationLink(destination: InfoFileView()){
                    HStack{ 
                        Image(systemName:"info.circle.fill")
                        Text("Tips & Information")
                    }
                }
                .accentColor(.indigo)
                .padding()
                
                NavigationLink(destination: EyeTracker()){
                    HStack{ 
                        Image(systemName:"figure.run")
                        Text("On The Way")
                    }
                }
                .accentColor(.indigo)
                .padding()
                Spacer()
                FunFactView()
                if isRecognizing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor.systemIndigo)))
                        .padding(.bottom,  20)
                }
            }
            .navigationTitle("Readability")
            .navigationBarItems(trailing: 
                Button(action: {
                guard !isRecognizing else { return }
                showingAlert = true 

            }, label: {
                HStack {
                    Image(systemName: "doc.viewfinder")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                    Text("Insert")
                        .foregroundColor(.white)
                }
                .padding(.horizontal,  16)
                .frame(height:  36)
                .background(Color(UIColor.systemIndigo))
                .cornerRadius(18)
                Button(action: { 
                    self.idea = true 
                }){
                    Image(systemName: "lightbulb.min.badge.exclamationmark")
                }
                .foregroundStyle(.indigo)
                .padding(.leading, 10)
            })
            .popover(isPresented: $showPopover) { 
                VStack {
                    HStack{
                        Image(systemName: "text.insert")
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.leading,15)
                        Text("Please click on the 'Insert' button first before navigating elsewhere so that you can take a personalised reading 'test' in your Readings List.")
                            .font(.headline)
                            .padding()
                    }
                }
                    }
        
          )
            
            }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Please scan a page from an English book"),
                message: Text("Ensure the page is clear and well-lit."),
                primaryButton: .default(Text("Ok")) {
                    showScanner = true
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    present.wrappedValue.dismiss() 
                }
            )
        }

        .sheet(isPresented: $idea){ 
            Idea()
        }
            .fullScreenCover(isPresented: $showScanner, content: {
                ScannerView { result in
                    switch result {
                    case .success(let scannedImages):
                        isRecognizing = true
                        
                        TextRecognition(scannedImages: scannedImages,
                                        recognizedContent: recognizedContent)
                       {
                            isRecognizing = false
                        }
                                        .recognizeText()
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                    showScanner = false
                    
                } didCancelScanning: {
                    showScanner = false
                }
            })
        
        }
    
    }








   
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()  
    }
}

