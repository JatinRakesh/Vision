
import ARKit
import RealityKit
import SwiftUI
import UIKit

struct EyeTracker: View {
    @State var eyeGazeActive: Bool = true
    @State var lookAtPoint: CGPoint?
    @State var isWinking: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack{
                Form{ 
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 60,height:48)
                                .foregroundStyle(.bar)
                            Image(systemName: "eye.circle")
                                .font(.largeTitle)
                                .padding()
                                .foregroundStyle(.indigo)
                        }
                        Text("Preview Of Upcoming Feature")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                    }
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 60,height:48)
                                .foregroundStyle(.bar)
                            Image(systemName: "camera.circle")
                                .padding()
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundStyle(.yellow)
                            
                        }
                        
                        Text("Take reading tests, in this view, on the go with a digital eye-tracker and marker displayed on your text using the back camera. No need to scan books; just hold a page behind the camera and read. This ensures thorough reading and convenience for if you have no time to scan any book. After reading through the last word in the text, a pop-up sheet will show up, showing your reading speed. Try switching to portrait orientation for improved marker accuracy")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                    
                    HStack{
                        ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60,height:48)
                            .foregroundStyle(.bar)
                        Image(systemName: "wrench.and.screwdriver")
                            .padding()
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundStyle(.indigo)
                    }
                        Text("The functionality is unfortunately partially being applied and is also not very easy to implement. However,in the future, I hope to implement this function in its entirety to give convenience for users using this app")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    HStack{ 
                        ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60,height:48)
                            .foregroundStyle(.bar)
                        Image(systemName: "minus.circle")
                            .padding()
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundStyle(.red)
                    }
                        Text("Limitations of this feature include the user speed reading through all the text without understanding the text. I plan to resolve this problem by implementing a custom Machine Learning Model that gives MCQ Questions of the text the user has. This ensures that the reader improves his understanding of the text and has integrity when taking this mini-test ")
                            .font(.caption2)
                            .fontWeight(.light)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.leading)
                         
                        
                    }
        
                }
                Divider()
                CustomARViewContainer(eyeGazeActive: $eyeGazeActive, lookAtPoint: $lookAtPoint, isWinking: $isWinking)
                    .edgesIgnoringSafeArea(.top)
            }
            
            if let lookAtPoint = lookAtPoint {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: isWinking ? 150 : 40, height: isWinking ? 150 : 40)
                    .position(lookAtPoint)
            }
        }
    }
}


struct CustomARViewContainer: UIViewRepresentable {
    
    @Binding var eyeGazeActive: Bool
    @Binding var lookAtPoint: CGPoint?
    @Binding var isWinking: Bool
    
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView(eyeGazeActive: $eyeGazeActive, lookAtPoint: $lookAtPoint, isWinking: $isWinking)
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
}


class CustomARView: ARView, ARSessionDelegate {
    
    @Binding var eyeGazeActive: Bool
    @Binding var lookAtPoint: CGPoint?
    @Binding var isWinking: Bool
    
    init(eyeGazeActive: Binding<Bool>, lookAtPoint: Binding<CGPoint?>, isWinking: Binding<Bool>) {
        _eyeGazeActive = eyeGazeActive
        _lookAtPoint = lookAtPoint
        _isWinking = isWinking
        
        super.init(frame: .zero)
        self.session.delegate = self
        
        let config = ARFaceTrackingConfiguration()
        self.session.run(config)
    }
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        guard eyeGazeActive, let faceAnchor = anchors.compactMap({ $0 as? ARFaceAnchor }).first else {
            return
        }
        
        detectGazePoint(faceAnchor: faceAnchor)
        detectWink(faceAnchor: faceAnchor)
        detectEyebrowRaise(faceAnchor: faceAnchor)
    }
    
    private func detectGazePoint(faceAnchor: ARFaceAnchor){
        let lookAtPoint = faceAnchor.lookAtPoint
        
        guard let cameraTransform = session.currentFrame?.camera.transform else {
            return
        }
        
        let LOPIW = faceAnchor.transform * simd_float4(lookAtPoint, 1)
        
        let LOPT = simd_mul(simd_inverse(cameraTransform), LOPIW)
        
        let screenX = LOPT.y / (Float(Device.screenSize.width) / 2) * Float(Device.frameSize.width)
        let screenY = LOPT.x / (Float(Device.screenSize.height) / 2) * Float(Device.frameSize.height)
        
        let focusPoint = CGPoint(
            x: CGFloat(screenX).clamped(to: Ranges.widthRange),
            y: CGFloat(screenY).clamped(to: Ranges.heightRange)
        )
        
        DispatchQueue.main.async {
            self.lookAtPoint = focusPoint
        }
    }
    
    private func detectWink(faceAnchor: ARFaceAnchor) {
        
        let blendShapes = faceAnchor.blendShapes
        
        if let leftEyeBlink = blendShapes[.eyeBlinkLeft] as? Float,
           let rightEyeBlink = blendShapes[.eyeBlinkRight] as? Float {
            if leftEyeBlink > 0.5 && rightEyeBlink > 0.5 {
                isWinking = true
            } else {
                isWinking = false
            }
        }
    }
    
    private func detectEyebrowRaise(faceAnchor: ARFaceAnchor){
        
        let browInnerUp = faceAnchor.blendShapes[.browInnerUp] as? Float ?? 0.0
        
        let eyebrowRaiseThreshold: Float = 0.1
        
        let RaisedEye = browInnerUp > eyebrowRaiseThreshold
        
        if RaisedEye {
            isWinking = true
        }else{
            isWinking = false
        }
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
}

struct Device {
    static var screenSize: CGSize {
        
        let screenWidthPixel: CGFloat = UIScreen.main.nativeBounds.width
        let screenHeightPixel: CGFloat = UIScreen.main.nativeBounds.height
        
        let ppi: CGFloat = UIScreen.main.scale * 163 
        
        let a_ratio=(1125/458)/0.0623908297
        let b_ratio=(2436/458)/0.135096943231532
        
        return CGSize(width: (screenWidthPixel/ppi)/a_ratio, height: (screenHeightPixel/ppi)/b_ratio)
    }
    
    static var frameSize: CGSize {  
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 82)
    }
}

struct Ranges {
    static let widthRange: ClosedRange<CGFloat> = (0...Device.frameSize.width)
    static let heightRange: ClosedRange<CGFloat> = (0...Device.frameSize.height)
}

extension CGFloat {
    func clamped(to: ClosedRange<CGFloat>) -> CGFloat {
        return to.lowerBound > self ? to.lowerBound
        : to.upperBound < self ? to.upperBound
        : self
    }
}

