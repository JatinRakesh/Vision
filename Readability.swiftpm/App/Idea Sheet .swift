import SwiftUI

struct Idea : View {
  @Environment(\.presentationMode) var presentationMode
    var body: some View { 
            VStack{
                HStack{
                    Spacer()
                    Button(role: .destructive, action:{ 
                        presentationMode.wrappedValue.dismiss()
                    })
                    { 
                      Image(systemName: "xmark")  
                            .font(.title)
                            .padding()
                            .fontWeight(.medium)
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60,height:48)
                        .foregroundStyle(.bar)
                        .padding(.top,20)
                    Image(systemName: "text.book.closed")
                        .padding(.top,20)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.indigo)
                }
                Text("About This App")
                    .fontWeight(.ultraLight)
                    .font(.caption2)
                    .padding(.top,8)
                Text("Readability")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .padding(.bottom,10)
            }
            
            
            Form{
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60,height:48)
                            .foregroundStyle(.bar)
                        Image(systemName: "swift")
                            .padding()
                            .font(.title)
                            .fontWeight(.regular)
                            .foregroundStyle(.indigo)
                    }
                    
                    Text("This year's entry for Apple's Swift Student Challenge is a pioneering app designed to enhance reading proficiency. Tailored for individuals seeking to bolster their reading speed and skills, the application serves as a comprehensive tool for accelerating reading capabilities.")
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                    
                }
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60,height:48)
                            .foregroundStyle(.bar)
                        Image(systemName: "book.circle")
                            .padding()
                            .font(.title)
                            .fontWeight(.regular)
                            .foregroundStyle(.indigo)
                        
                    }
                    Text("Why is Speed Reading important? Speed reading is crucial for efficient learning, enhancing memory retention, and managing time effectively. It fosters cognitive agility, providing a competitive edge in information-driven environments, while also promoting continuous learning and improving language proficiency. ")
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                }
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60,height:48)
                            .foregroundStyle(.bar)
                        Image(systemName: "graduationcap.circle")
                            .padding()
                            .font(.title)
                            .fontWeight(.regular)
                            .foregroundStyle(.indigo)
                        
                    }
                    Text("This app's initial version focuses on improving reading speed. Future enhancements may include an integrated ML model generating comprehension questions based on the reader's text(s), ensuring users comprehend the material thoroughly and discouraging random stops.")
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                }
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60,height:48)
                            .foregroundStyle(.bar)
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .padding()
                            .font(.title)
                            .fontWeight(.regular)
                            .foregroundStyle(.indigo)
                        
                    }
                    Text("Driven by personal challenges with slow reading and academic setbacks in primary school, I initiated the development of Readability. Faced with consistent academic struggles and difficulty maintaining focus, I dedicated myself to daily immersion in YouTube videos and extensive reading. Recognizing the cognitive benefits of fast reading, I researched techniques to enhance focus and comprehension. This journey fuels my commitment to creating an impactful solution for those sharing similar challenges.")
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.gray)
                }
            }
            
        }
    
}


