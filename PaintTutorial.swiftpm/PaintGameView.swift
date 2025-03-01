import SwiftUI

struct Line: Equatable{
    var points = [CGPoint]()
    var color: Color
    var lineWidth: Double
}

struct PaintGameView: View {
    @State var currLine = Line(color: Color("yellow1"), lineWidth: 30.0)
    @State var lines: [Line] = []
    @State var boiImage: UIImage?
    
    @State var showPaintedImage: Bool = false
    
    var body: some View {
        ZStack {
            Color("blue2")
            VStack(spacing: 40){
                Canvas{ context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path,
                                       with: .color(line.color),
                                       style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                }
                .frame(width: 795, height: 530)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({value in
                            let newPoint = value.location
                            currLine.points.append(newPoint)
                            lines.append(currLine)
                        })
                        .onEnded({ value in
                            currLine = Line(points: [], color: Color("yellow1"), lineWidth: 30.0)
                        })
                )
                .mask(
                    Image("paintMask") //just paint inside this area
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                )
                .background(
                    ZStack{
                        Color(.white)
                        Image("paintBg")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                )
                .overlay {
                    Rectangle()
                        .stroke(Color(.blue1), lineWidth: 4)
                }
                
                Button {
                    let renderer = ImageRenderer(content: imageRender(lines: lines))
                    renderer.scale = UIScreen.main.scale
                    boiImage = renderer.uiImage
                    showPaintedImage = true
                } label: {
                    ZStack{
                        Color("green2")
                        Text("Done")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                    }
                    .frame(width: 200, height:  58)
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 4)
                    }
                }
            }
        }
        .overlay{
            if showPaintedImage{
                BoiView(showPaintedImage: $showPaintedImage, paintedImage: $boiImage)
            }
        }
        .ignoresSafeArea()
    }
}

//return the BoiBumba Painted Image
func imageRender(lines: [Line]) -> some View {
    Canvas{ context, size in
        for line in lines {
            var path = Path()
            path.addLines(line.points)
            context.stroke(path,
                           with: .color(line.color),
                           style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
        }
    }
    .frame(width: 795, height: 530)
    .mask(
        Image("paintMask")
            .resizable()
            .aspectRatio(contentMode: .fit)
    )
    .background(
        Image("paintBg")
            .resizable()
            .aspectRatio(contentMode: .fit)
    )
}
