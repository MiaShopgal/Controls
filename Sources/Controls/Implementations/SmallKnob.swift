import SwiftUI

/// Knob in which you start by tapping in its bound and change the value by either horizontal or vertical motion
public struct SmallKnob: View {
    @Binding var value: Float
    var range: ClosedRange<Float> = 0.0 ... 1.0
    var limit: ClosedRange<Float>

    var backgroundColor: Color = .gray
    var foregroundColor: Color = .black

    var strokeWidthModifier :  CGFloat = 20
    var strokeHeightModifier : CGFloat = 4

    @Binding var disableScroll : Bool

    /// Initialize the knob with a bound value and range
    /// - Parameters:
    ///   - value: value being controlled
    ///   - disableScroll: indicate parent's scroll view should disable scroll-ability
    ///   - range: range of the value
    ///   - limit: range of the draggable value
    public init ( value : Binding<Float>,
                  disableScroll: Binding<Bool>,
                  range : ClosedRange<Float> = 0.0 ... 1.0,
                  limit : ClosedRange<Float> ) {
        _value = value
        _disableScroll = disableScroll
        self.range = range
        self.limit = limit
    }

    var normalizedValue: Double {
        Double((value - range.lowerBound) / (range.upperBound - range.lowerBound))
    }

    public var body: some View {
        Control ( value : $value,
                  in : range,
                  between : limit,
                  geometry : .twoDimensionalDrag ( xSensitivity : 1,
                                                   ySensitivity : 1 ),
                  onStarted : { disableScroll = true },
                  onEnded : { disableScroll = false} ) { geo in
            ZStack(alignment: .center) {
                Ellipse().foregroundColor(backgroundColor)
                Rectangle().foregroundColor(foregroundColor)
                    .frame(width: geo.size.width / strokeWidthModifier, height: geo.size.height / strokeHeightModifier)
                    .rotationEffect(Angle(radians: normalizedValue * 1.6 * .pi + 0.2 * .pi))
                    .offset(x: -sin(normalizedValue * 1.6 * .pi + 0.2 * .pi) * geo.size.width / 2.0 * 0.75,
                            y: cos(normalizedValue * 1.6 * .pi + 0.2 * .pi) * geo.size.height / 2.0 * 0.75)
            }.drawingGroup() // Drawing groups improve antialiasing of rotated indicator
        }
        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)

    }
}


extension SmallKnob {
    /// Modifier to change the background color of the knob
    /// - Parameter backgroundColor: background color
    public func backgroundColor(_ backgroundColor: Color) -> SmallKnob {
        var copy = self
        copy.backgroundColor = backgroundColor
        return copy
    }

    /// Modifier to change the foreground color of the knob
    /// - Parameter foregroundColor: foreground color
    public func foregroundColor(_ foregroundColor: Color) -> SmallKnob {
        var copy = self
        copy.foregroundColor = foregroundColor
        return copy
    }

    /// Modifier to change the foreground color of the knob
    /// - Parameter strokeWidthModifier: modifier for Rectangle frame's width
    public func strokeWidthModifier(_ strokeWidthModifier: CGFloat) -> SmallKnob {
        var copy = self
        copy.strokeWidthModifier = strokeWidthModifier
        return copy
    }

    /// Modifier to change the foreground color of the knob
    /// - Parameter strokeHeightModifier: modifier for Rectangle frame's height
    public func strokeHeightModifier(_ strokeHeightModifier: CGFloat) -> SmallKnob {
        var copy = self
        copy.strokeHeightModifier = strokeHeightModifier
        return copy
    }
}
