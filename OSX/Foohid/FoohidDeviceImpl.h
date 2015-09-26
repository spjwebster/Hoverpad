//
//  FoohidDevice.m
//
//  Created by Steve Webster on 24/09/2015 based on WirtualJoy.
//

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

#define FOOHID_SERVICE "it_unbit_foohid"

#define FOOHID_CREATE 0
#define FOOHID_DESTROY 1
#define FOOHID_SEND 2
#define FOOHID_LIST 3

@interface FoohidDeviceImpl : NSObject {
@private
    io_connect_t m_Connection;
    NSString *m_Name;
}

+ (BOOL)prepare;
- (id)initWithName:(NSString*)name;

@end

@interface FoohidDeviceImpl (Methods)

- (BOOL)create:(NSData*)HIDDescriptor;
- (BOOL)destroy;
- (BOOL)send:(NSData*)HIDState;

@end
