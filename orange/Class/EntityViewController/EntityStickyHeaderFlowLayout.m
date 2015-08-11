//
//  EntityStickyHeaderFlowLayout.m
//  orange
//
//  Created by 谢家欣 on 15/8/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityStickyHeaderFlowLayout.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"

//NSString *const EntityStickyHeaderParallaxHeader = @"EntityStickyHeaderParallaxHeader";

@interface EntityStickyHeaderFlowLayout ()

@property (strong, nonatomic) UICollectionViewLayoutAttributes * stickyHeader;

@end

@implementation EntityStickyHeaderFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind
                                                                                        atIndexPath:(NSIndexPath *)elementIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind
                                                                                                            atIndexPath:elementIndexPath];
//    CGRect frame = attributes.frame;
//    frame.origin.y += self.parallaxHeaderReferenceSize.height;
//    attributes.frame = frame;
    DDLogInfo(@"%@", attributes);
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
//    if (!attributes && [kind isEqualToString:EntityStickyHeaderParallaxHeader]) {
//        attributes = [CSStickyHeaderFlowLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
//    }
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // The rect should compensate the header size
//    CGRect adjustedRect = rect;
//    adjustedRect.origin.y -= self.parallaxHeaderReferenceSize.height;
    
    NSMutableArray *allItems = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    DDLogInfo(@"%@", allItems);
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *lastCells = [[NSMutableDictionary alloc] init];
//    __block BOOL visibleParallexHeader;
    NSMutableDictionary *lastCells = [[NSMutableDictionary alloc] init];
    [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attributes = obj;

        NSIndexPath *indexPath = [(UICollectionViewLayoutAttributes *)obj indexPath];
        if ([[obj representedElementKind] isEqualToString:UICollectionElementKindSectionHeader]) {
            if (indexPath.section == 1) {
                self.stickyHeader = obj;
            }
            [headers setObject:obj forKey:@(indexPath.section)];
        } else {
            NSIndexPath *indexPath = [(UICollectionViewLayoutAttributes *)obj indexPath];
            
            UICollectionViewLayoutAttributes *currentAttribute = [lastCells objectForKey:@(indexPath.section)];
            
            // Get the bottom most cell of that section
            if ( ! currentAttribute || indexPath.row > currentAttribute.indexPath.row) {
                [lastCells setObject:obj forKey:@(indexPath.section)];
            }
            
//            if ([indexPath item] == 0 && [indexPath section] == 0) {
//                visibleParallexHeader = YES;
//            }
        }

        // For iOS 7.0, the cell zIndex should be above sticky section header
        attributes.zIndex = 1;
        
    }];
    [lastCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSIndexPath *indexPath = [obj indexPath];
        NSNumber *indexPathKey = @(indexPath.section);
        
        UICollectionViewLayoutAttributes *header = headers[indexPathKey];
        // CollectionView automatically removes headers not in bounds
        if ( ! header) {
            [allItems addObject:self.stickyHeader];
//            header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                          atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
//            
//            if (header) {
//                [allItems addObject:header];
//            }
        }
        [self updateHeaderAttributes:self.stickyHeader];
    }];
    return allItems;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
//    frame.origin.y += self.parallaxHeaderReferenceSize.height;
    attributes.frame = frame;
    return attributes;
}

- (CGSize)collectionViewContentSize {
    // If not part of view hierarchy then return CGSizeZero (as in docs).
    // Call [super collectionViewContentSize] can cause EXC_BAD_ACCESS when collectionView has no superview.
    if (!self.collectionView.superview) {
        return CGSizeZero;
    }
    CGSize size = [super collectionViewContentSize];
//    size.height += self.parallaxHeaderReferenceSize.height;
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark Overrides

+ (Class)layoutAttributesClass {
    return [CSStickyHeaderFlowLayoutAttributes class];
}

- (void)setParallaxHeaderReferenceSize:(CGSize)parallaxHeaderReferenceSize {
//    _parallaxHeaderReferenceSize = parallaxHeaderReferenceSize;
    // Make sure we update the layout
    [self invalidateLayout];
}

#pragma mark Helper
- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    CGRect currentBounds = self.collectionView.bounds;
    attributes.zIndex = 1024;
    attributes.hidden = NO;
    CGPoint origin = attributes.frame.origin;
    CGFloat sectionMaxY = self.collectionView.contentSize.height - attributes.frame.size.height;
//            DDLogInfo(@"section max %@", attributes);
    CGFloat y = CGRectGetMaxY(currentBounds) - currentBounds.size.height;
//    DDLogInfo(@"%.2f, %.2f,", CGRectGetMaxY(currentBounds), currentBounds.size.height);
    CGFloat maxY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);
    DDLogInfo(@"%.2f, %.2f, %.2f", y, maxY, sectionMaxY);
    origin.y = maxY;
    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
    DDLogInfo(@"%@", attributes);
}

@end
