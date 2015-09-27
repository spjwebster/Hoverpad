//
//  DoubleExponentialSmoothingFilter.h
//
//  Created by Steve Webster on 27/09/2015.
//

#import "Filter.h"

@interface DoubleExponentialSmoothingFilter : NSObject <Filter> {
@private
    
    float sp[3];
    float sp2[3];
    
    float alpha;
    int interval;
    
    NSDate *lastTickTime;
    bool initialised;
}



@end