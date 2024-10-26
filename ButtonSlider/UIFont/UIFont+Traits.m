//
//  UIFont+Traits.m
//  TextLearning
//
//  Created by Ranix on 2024/10/17.
//

#import "UIFont+Traits.h"

@implementation UIFont (Traits)

- (UIFont *)withTraits:(UIFontDescriptorSymbolicTraits)traits {
    UIFontDescriptor *fd = [self.fontDescriptor fontDescriptorWithSymbolicTraits:traits];
    
    if (fd) {
        return [UIFont fontWithDescriptor:fd size:self.pointSize];
    } else {
        return self;
    }
}

- (UIFont *)italic {
    return [self withTraits:UIFontDescriptorTraitItalic];
}

- (UIFont *)bold {
    return [self withTraits:UIFontDescriptorTraitBold];
}

- (UIFont *)boldItalic {
    return [self withTraits:(UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)];
}

@end

