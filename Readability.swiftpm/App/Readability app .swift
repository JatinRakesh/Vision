import SwiftUI
import Guide

@main
struct MyApp: App {
    var body: some Scene {
        @StateObject var notesModel = NotesModel()
        
        WindowGroup {
            HomeView()
            
        }
    }
}

