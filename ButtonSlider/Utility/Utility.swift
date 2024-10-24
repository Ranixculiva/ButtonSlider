import UIKit
let isDeveloperMode: Bool = true

let IS_IPAD: Bool = UIDevice.current.userInterfaceIdiom == .pad

@propertyWrapper
struct GuidelinePixelValueConvertor {
    private var value: CGFloat
    private var convertedValue: CGFloat
    
    init(wrappedValue: CGFloat) {
        self.value = wrappedValue
        self.convertedValue = GuidelinePixelValueConvertor.convert(value: wrappedValue)
    }
    
    var wrappedValue: CGFloat {
        get { convertedValue }
        set {
            value = newValue
            convertedValue = GuidelinePixelValueConvertor.convert(value: newValue)
        }
    }
    
    private static func convert(value: CGFloat) -> CGFloat {
        let baseWidth: CGFloat = IS_IPAD ? 480 : 320
        let screenWidth = UIScreen.main.bounds.width
        return (value / baseWidth) * screenWidth
    }
}

@propertyWrapper
struct GuidelinePixelHeightValueConvertor {
    private var value: CGFloat
    private var convertedValue: CGFloat
    
    init(wrappedValue: CGFloat) {
        self.value = wrappedValue
        self.convertedValue = GuidelinePixelHeightValueConvertor.convert(value: wrappedValue)
    }
    
    var wrappedValue: CGFloat {
        get { convertedValue }
        set {
            value = newValue
            convertedValue = GuidelinePixelHeightValueConvertor.convert(value: newValue)
        }
    }
    
    private static func convert(value: CGFloat) -> CGFloat {
        let baseHeight: CGFloat = IS_IPAD ? 690.7317073171 : 693.5813953488
        let screenHeight = UIScreen.main.bounds.height
        return (value / baseHeight) * screenHeight
    }
}

