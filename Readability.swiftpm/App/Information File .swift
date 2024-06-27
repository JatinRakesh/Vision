import SwiftUI
struct InfoFileView: View { 
    @State private var Open = false
    @State private var Open2 = false
    @State private var Open3 = false
    @State private var Open4 = false
    @State private var Open5 = false
    @State private var Open6 = false
    @State private var Open7 = false
    @State private var Open8 = false
    
    var body: some View{ 
        VStack{
            Form{
                Section(header: Text ("Reference Table")){
                    Image("WPMCounter")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                }
                Section(header: Text("Reading Techniques Tips")){ 
                    DisclosureGroup("Minmize Subvocalization", isExpanded: $Open){ 
                        Text("To enhance your speed reading, work on reducing subvocalization – the habit of silently pronouncing each word in your mind. This inner voice can slow down your reading pace. Instead, focus on visualizing concepts and ideas as you read, allowing your eyes to move swiftly across the text without relying on vocalization for comprehension. This adjustment helps to streamline the reading process and increase overall speed.")
                            .fontWeight(.light)
                            .font(.subheadline)
                    }
                    DisclosureGroup("Practice Chunking",isExpanded: $Open2){ 
                        Text("Train your eyes to recognize and process phrases or groups of words at once, rather than fixating on individual words. This technique, known as chunking, enables you to absorb more information in a single glance, reducing the number of eye movements required. Through consistent practice, you can improve your ability to chunk information, leading to a more efficient and accelerated reading experience.")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    DisclosureGroup("Rapid Serial Visual Presentation (RSVP)",isExpanded: $Open3){ 
                        Text("RSVP is a technology-based technique where text is presented one word at a time at a user-defined speed. By eliminating the need for eye movements between words, RSVP promotes a consistent reading rhythm and helps increase overall reading speed. Though initially challenging, regular practice with RSVP tools or apps can lead to significant improvements in reading speed without compromising comprehension.")
                            .fontWeight(.light)
                            .font(.subheadline)
                    }
                    DisclosureGroup("Skim & Preview",isExpanded:$Open4){ 
                        Text("Before diving into the details of a passage, take a moment to preview the material by quickly skimming headings, subheadings, and highlighted text. This initial overview provides context and allows you to grasp the main ideas before delving into the finer details. Previewing helps for more efficient and focused reading, improving both speed and comprehension.")
                            .fontWeight(.light)
                            .font(.subheadline)
                    }
                    DisclosureGroup("Use A Guided Pointer",isExpanded:$Open5){
                        Text("Get a finger, pen, or pointer to guide your eyes along the lines as you read. This physical guide helps maintain a steady pace, prevents regression and assists in smoothly navigating through the text. The act of pointing serves as a visual anchor, contributing to a more fluid reading experience and helping in the development of a consistent and accelerated reading rhythm.")
                            .fontWeight(.light)
                            .font(.subheadline)
                    }
                    }
                Section(header: Text("Tips For Self-Improvement")){ 
                   DisclosureGroup("Set Goals",isExpanded: $Open6){ 
                       Text("Before you start reading, define your purpose and set specific goals. Knowing why you're reading and what you aim to achieve can help you stay focused and avoid unnecessary distractions, leading to a more purposeful and efficient reading session.")
                           .font(.subheadline)
                           .fontWeight(.medium)
                       Image("SMART")
                           .resizable()
                           .scaledToFit()
                           .cornerRadius(10)
                       }
                    DisclosureGroup("Eliminate Sub-Optimal Reading Habits",isExpanded:$Open7){ 
                        Text("Identify and eliminate habits that hinder your reading speed, such as backtracking or re-reading sentences unnecessarily. Be conscious of these behaviors and work on breaking them to maintain a steady reading flow.")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    DisclosureGroup("Practice Makes Perfect",isExpanded:$Open8){ 
                        Text("Like any skill, speed reading improves with consistent practice. Dedicate time each day to practice speed reading techniques and gradually challenge yourself to read faster without sacrificing understanding. Regular practice is essential for long-term improvement. As the saying goes - 'Practice Makes Perfect'")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
                }
                
            }
        
    }
}

#Preview{ 
    InfoFileView()
}

                     
                   
