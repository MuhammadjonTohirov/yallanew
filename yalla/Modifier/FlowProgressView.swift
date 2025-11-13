import SwiftUI
import Core

// MARK: - Demo
struct ColoredStripedBarDemo: View {
    @State private var progress: Double = 0.35

    var body: some View {
        VStack(spacing: 16) {
            FlowProgressView(
                progress: progress,
                fillGradient: LinearGradient(
                    colors: [.red, .iPrimaryDark],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 14)
            
            FlowProgressView(
                progress: progress,
                fillGradient: LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 14)

            HStack {
                Text("0%")
                Slider(value: $progress, in: 0...1)
                Text("100%")
            }
        }
        .padding()
    }
}

// MARK: - Striped Progress Bar (refactored with defaults)
struct FlowProgressView: View {
    enum Direction { case leftToRight, rightToLeft }

    // REQUIRED parameters
    let progress: Double
    let fillGradient: LinearGradient

    // OPTIONAL parameters with defaults
    var trackColor: Color = .iBackgroundSecondary
    var stripeColor: Color = Color.iBackgroundSecondary.opacity(0.20)
    var stripeWidth: CGFloat = 7
    var stripeGap: CGFloat = 7
    var stripeAngle: CGFloat = 30
    var direction: Direction = .leftToRight
    var speed: CGFloat = 40
    var showMarker: Bool = false
    var markerSizeFactor: CGFloat = 2
    var markerYOffset: CGFloat = 0
    var markerImageName: String? = ""
    var height: Double = 14

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let unit = min(max(progress, 0), 1)
            let filledW = w * unit
            let isActive = unit > 0.0001

            // Base bar (track + gradient + stripes)
            let bar = ZStack(alignment: .leading) {
                Capsule().fill(trackColor)

                ZStack {
                    Capsule().fill(fillGradient)

                    // ⬇️ Time-driven stripes (TimelineView inside Canvas)
                    StripesCanvasTimeDriven(
                        speed: isActive ? speed : 0,          // pause at zero
                        stripeWidth: stripeWidth,
                        stripeGap: stripeGap,
                        angle: stripeAngle,
                        color: stripeColor,
                        direction: direction
                    )
                    .clipShape(Capsule())
                    .allowsHitTesting(false)
                }
                .frame(width: filledW)
                .animation(.easeOut(duration: 0.35), value: unit) // fill grows L → R
            }

            bar
                .overlay(alignment: .leading) {
                    if showMarker, let name = markerImageName, !name.isEmpty {
                        let side = h * markerSizeFactor
                        let xPos = min(max(filledW - side/2, 0), w - side/2)

                        Image(name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: side, height: side)
                            .allowsHitTesting(false)
                            .offset(x: xPos, y: markerYOffset)
                            .animation(.easeOut(duration: 0.35), value: unit)
                    }
                }
        }
        .frame(height: height)
    }
}

// MARK: - Canvas with TimelineView (matches your sample's approach)
private struct StripesCanvasTimeDriven: View {
    var speed: CGFloat                 // points/sec
    var stripeWidth: CGFloat
    var stripeGap: CGFloat
    var angle: CGFloat                 // degrees; positive = "/" slant
    var color: Color
    var direction: FlowProgressView.Direction = .leftToRight

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            // distance traveled along X since t=0
            let dist = CGFloat(t) * abs(speed)
            let period = stripeWidth + stripeGap
            let signed = (direction == .leftToRight ? dist : -dist)
            let phase = signed.truncatingRemainder(dividingBy: period)

            Canvas { context, size in
                let rect = CGRect(origin: .zero, size: size)
                context.clip(to: Path(rect))

                // Rotate drawing space so stripes lean correctly
                context.drawLayer { layer in
                    layer.translateBy(x: rect.midX, y: rect.midY)
                    layer.rotate(by: .degrees(angle))
                    layer.translateBy(x: -rect.midX, y: -rect.midY)

                    let diag = hypot(size.width, size.height)
                    let startX = -diag + phase
                    let endX = size.width + diag

                    var x = startX
                    while x < endX {
                        let stripe = CGRect(x: x, y: -diag, width: stripeWidth, height: diag * 2)
                        layer.fill(Path(stripe), with: .color(color))
                        x += period
                    }
                }
            }
            .opacity(0.45)
        }
    }
}

// MARK: - Preview
#Preview {
    ColoredStripedBarDemo()
        .padding()
        .background(Color.background)
}
