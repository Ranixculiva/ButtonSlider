//
//  DrawTextUtility.m
//  ButtonSlider
//
//  Created by Ranix on 2024/10/26.
//

#import "DrawTextUtility.h"
#import <CoreText/CoreText.h>
#import "UIFont+Traits.h"

@implementation DrawTextUtility

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.letterSpacing = 30;
    }
    return self;
}

- (CGFloat)calculateLetterSpacingWithFontSize:(CGFloat)fontSize {
    return self.letterSpacing;
}

- (CGFloat)calculateStrikethroughLineThicknessWithFontSize:(CGFloat)fontSize {
    return 4;
}

- (CGFloat)calculateUnderlineLineThicknessWithFontSize:(CGFloat)fontSize {
    return 4;
}

- (UIImage*)createImageWithText:(NSString*)text fontSize:(CGFloat)fontSize {
    // draw text to image
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(500, 700), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSDictionary* attributes = [self createAttributesWithFont:nil fontSize:fontSize fgColor:[UIColor blackColor] bgColor:[UIColor clearColor] paragraphStyle:nil];
    NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [self drawAttributedTextWithContext:context attributedText:attributedText boldness:0 alignment:NSTextAlignmentRight size:CGRectMake(0, 0, 500, 700) color:[UIColor blackColor] strokeColor:[UIColor clearColor] fontSize:fontSize];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawAttributedTextWithContext:(CGContextRef)context attributedText:(NSAttributedString*)attributedText boldness:(CGFloat)boldness alignment:(NSTextAlignment)alignment size:(CGRect)rect color:(UIColor*)textColor strokeColor:(UIColor*)strokeColor fontSize:(CGFloat)fontSize {
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);// Flip the coordinate system for Core Text
    
    // Create the line of text
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedText);
    
    // Create the path for the text (which is the rect where we will draw text)
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CGMutablePathRef underLine = CGPathCreateMutable();
    CGMutablePathRef strikeLine = CGPathCreateMutable();
    
    // Create the frame that will draw the text inside the given rectangle
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    // Get the lines of text from the frame
    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint origins[lineCount];
    CGFloat strokeLineWidth = 3.0;
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    CGMutablePathRef letters = CGPathCreateMutable();
    for (CFIndex i = 0; i < lineCount; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGPoint lineOrigin = origins[i];
        // Calculate text width for alignment
        CGFloat ascent, descent, leading;
        CGFloat textWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        if (i != lineCount - 1) {
            textWidth -= [self calculateLetterSpacingWithFontSize:fontSize];
        }
        // Calculate the y position of the line (based on ascent and descent)
        CGFloat lineHeight = ascent + descent;
        CGFloat yPosition = lineOrigin.y - descent;
        
        // Calculate the center point of the line (center horizontally in the rect)
        CGFloat xCenter = rect.origin.x + (rect.size.width - textWidth) / 2.0;
        CGFloat yCenter = yPosition + lineHeight / 2.0;
        CGPoint lineCenter = CGPointMake(xCenter, yCenter);
        
        CGFloat xOffset = 0;
        CGFloat yOffsetForUnderline = 0;
        yOffsetForUnderline -= boldness;
        if (self.strokeColor != [UIColor clearColor]) {
            yOffsetForUnderline -= strokeLineWidth;
        }
        switch (alignment) {
            case NSTextAlignmentLeft:
                xOffset = 0;
                break;
            case NSTextAlignmentCenter:
                xOffset = (rect.size.width - textWidth) / 2;
                break;
            case NSTextAlignmentRight:
                xOffset = rect.size.width - textWidth;
                break;
            default:
                break;
        }

        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);

        for (CFIndex j = 0; j < runCount; j++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);

            for (CFIndex k = 0; k < CTRunGetGlyphCount(run); k++) {
                CFRange range = CFRangeMake(k, 1);
                CGGlyph glyph;
                CGPoint position;
                CTRunGetGlyphs(run, range, &glyph);
                CTRunGetPositions(run, range, &position);

                // Check if the glyph is a space
                if (glyph != 0) {  // 0 is typically the glyph for space
                    // get width of letter
                    CGSize advance;
                    CTFontGetAdvancesForGlyphs(runFont, kCTFontOrientationHorizontal, &glyph, &advance, 1);
                    CGFloat letterWidth = advance.width;
                    // draw a red rectangle under each letter to bound the letter
                    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                    CGContextFillRect(context, CGRectMake(position.x + xOffset, position.y + lineOrigin.y, letterWidth, 10));

                    CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                    CGAffineTransform t = CGAffineTransformMakeTranslation(position.x + xOffset, position.y + lineOrigin.y);
                    CGPathAddPath(letters, &t, letter);
                    CGPathRelease(letter);
                }
            }
        }
        if (self.textFormat.isUnderline) {
            // Update underline path for this line
            CGFloat lineStartX = rect.origin.x + xOffset;
            CGFloat lineEndX = lineStartX + textWidth;
            CGPathMoveToPoint(underLine, NULL, lineStartX, lineOrigin.y + yOffsetForUnderline);
            CGPathAddLineToPoint(underLine, NULL, lineEndX, lineOrigin.y + yOffsetForUnderline);
        }
        if (self.textFormat.isStrikethrough) {
            // Add strikethrough path for this line
            CGPathMoveToPoint(strikeLine, NULL, rect.origin.x + xOffset, lineCenter.y);
            CGPathAddLineToPoint(strikeLine, NULL, rect.origin.x + xOffset + textWidth, lineCenter.y);
        }
    }
    
    if (self.strokeColor != UIColor.clearColor) {
        CGContextSetLineWidth(context, boldness + strokeLineWidth);
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        CGContextAddPath(context, letters);
        CGContextStrokePath(context);
    }
    
    if (self.textFormat.isBold) {
        // Set up the context for drawing
        CGContextSetLineWidth(context, boldness);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetStrokeColorWithColor(context, textColor.CGColor);
        // Draw the bold outline
        CGContextAddPath(context, letters);
        CGContextStrokePath(context);
    }
    
    // Fill the text
    CGContextSetFillColorWithColor(context, textColor.CGColor);
    CGContextAddPath(context, letters);
    CGContextFillPath(context);
    
    // Draw underline and strikethrough after processing all lines
    if (self.textFormat.isUnderline) {
        CGContextSetLineWidth(context, [self calculateUnderlineLineThicknessWithFontSize:fontSize]);
        CGContextSetStrokeColorWithColor(context, textColor.CGColor);
        CGContextAddPath(context, underLine);
        CGContextStrokePath(context);
    }
    if (self.textFormat.isStrikethrough) {
        CGContextSetLineWidth(context, [self calculateStrikethroughLineThicknessWithFontSize:fontSize]);
        CGContextSetStrokeColorWithColor(context, textColor.CGColor);
        CGContextAddPath(context, strikeLine);
        CGContextStrokePath(context);
    }
    // Clean up
    CGPathRelease(letters);
    CGPathRelease(path);
    CGPathRelease(underLine);
    CGPathRelease(strikeLine);
    CFRelease(frame);
    CFRelease(framesetter);
}

- (NSDictionary *)createAttributesWithFont:(nullable UIFont *)font
                                  fontSize:(CGFloat)fontSize
                                   fgColor:(nullable UIColor *)fgColor
                                   bgColor:(nullable UIColor *)bgColor
                            paragraphStyle:(nullable NSParagraphStyle *)paragraphStyle
{
    UIFont *typeFace = font ? [font fontWithSize:fontSize] : [UIFont systemFontOfSize:fontSize];
    if (self.textFormat.isBold && self.textFormat.isItalic) {
        typeFace = [typeFace boldItalic];
    } else if (self.textFormat.isBold) {
        typeFace = [typeFace bold];
    } else if (self.textFormat.isItalic) {
        typeFace = [typeFace italic];
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = typeFace;
    
    if (fgColor) {
        attributes[NSForegroundColorAttributeName] = fgColor;
    }
    
    if (bgColor) {
        attributes[NSStrokeColorAttributeName] = bgColor;
        attributes[NSStrokeWidthAttributeName] = @-3.0;
    }
    
    if (paragraphStyle) {
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }

    if (self.letterSpacing != 0) {
        attributes[NSKernAttributeName] = @([self calculateLetterSpacingWithFontSize:fontSize]);
    }
    
    return [attributes copy];
}
@end
