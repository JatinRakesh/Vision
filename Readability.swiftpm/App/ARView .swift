import ARKit 
import RealityKit 
import SwiftUI 



struct arview: View { 
    var body: some View { 
            ARVIEW()
                .edgesIgnoringSafeArea(.vertical)
        
    }
}
struct ARVIEW: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)        
        let textAnchor = AnchorEntity()
        
        textAnchor.addChild(TextGenerator(TString: "Upcoming Feature: You can take reading tests on the go with a digital eye-tracker displaying a marker on the text you're reading using the back camera, ensuring thorough reading and convenience."))
        arView.scene.addAnchor(textAnchor)
        return arView
        
    }
    
    func TextGenerator(TString: String) -> ModelEntity {
        let depthVar: Float = 0.001
        let fontVar = UIFont.systemFont(ofSize: 0.01)
        let materialVar = SimpleMaterial(color: .systemGray4, roughness: 0, isMetallic: true)
        let containerFrameVar = CGRect(x: -0.1, y: -0.1, width:  0.3, height:  0.3) 
        let alignmentVar: CTTextAlignment = .center
        let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
        
        let textMeshResource : MeshResource = .generateText(TString,
                                                            extrusionDepth: depthVar,
                                                            font: fontVar,
                                                            containerFrame: containerFrameVar,
                                                            alignment: alignmentVar,
                                                            lineBreakMode: lineBreakModeVar)
        
        let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
        
        return textEntity
    }

func updateUIView(_ uiView: ARView, context: Context) {}
    
}




#Preview{ 
    arview()
}
