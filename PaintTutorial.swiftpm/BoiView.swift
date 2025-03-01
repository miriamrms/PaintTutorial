//
//  SwiftUIView.swift
//  PaintTutorial
//
//  Created by Miriam Mendes on 01/03/25.
//

import SwiftUI

struct BoiView: View {
    @Binding var showPaintedImage: Bool
    @Binding var paintedImage: UIImage?
    
    var body: some View {
        ZStack{
            Color("blue2")
                .opacity(0.9)
            
            VStack{
                Text("This is your painting")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 54, weight: .semibold, design: .rounded))
                
                if let paintedImage = paintedImage {
                    Image(uiImage: paintedImage)
                }
            }
        }
        .onTapGesture {
            showPaintedImage = false
        }
    }
}

#Preview {
    BoiView(showPaintedImage: .constant(true), paintedImage: .constant(UIImage()))
}
