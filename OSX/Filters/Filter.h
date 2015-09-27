//
//  Filter.h
//
//  Created by Steve Webster on 27/09/2015.
//

@protocol Filter <NSObject>

- (id)initWithConfig:(NSDictionary*)config;
- (void)applyFilterToAxis:(float[])axis;

@end