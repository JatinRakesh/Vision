import Foundation


class TextItem: Identifiable{ 
    var id: String
    var text: String = "" 
    var Title: String = "" 
    init() { 
        id = UUID().uuidString
    }
}

class RecognizedContent: ObservableObject  { 
    @Published var items = [TextItem]()
}
