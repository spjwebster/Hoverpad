//
//  FoohidDevice.m
//
//  Created by Steve Webster on 24/09/2015 based on WirtualJoy.
//

#import "FoohidDeviceImpl.h"

@interface FoohidDeviceImpl (PrivatePart)

+ (io_service_t)findService;
+ (io_connect_t)createNewConnection;

+ (BOOL)isDriverLoaded;

@end

@implementation FoohidDeviceImpl

+ (BOOL)prepare {
    if (![FoohidDeviceImpl isDriverLoaded]) {
        NSLog(@"FooDeviceImpl: Foohid driver not loaded");
        return NO;
    }
    
    return YES;
}

- (id)initWithName:(NSString *)name {
    NSLog(@"FoohidDeviceImpl:initWithName:\"%@\"", name);
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    m_Name = [name copy];
    
    if (![FoohidDeviceImpl prepare]) {
        NSLog(@"- prepare returned NO");
        return nil;
    }
    
    m_Connection = [FoohidDeviceImpl createNewConnection];
    if (m_Connection == IO_OBJECT_NULL) {
        NSLog(@"- createNewConnection returned IO_OBJECT_NULL");
        return nil;
    }
    
    return self;
}

- (void)dealloc {
    if (m_Connection != IO_OBJECT_NULL) {
        IOServiceClose(m_Connection);
    }
}

@end

@implementation FoohidDeviceImpl (Methods)

- (BOOL)create:(NSData*)HIDDescriptor {
    uint32_t output_count = 1;
    uint64_t output = 0;
    
    uint64_t input[4];
    input[0] = (uint64_t) strdup([m_Name UTF8String]);
    input[1] = (uint64_t) [m_Name length];
    input[2] = (uint64_t) [HIDDescriptor bytes];
    input[3] = (uint64_t) [HIDDescriptor length];
    
    kern_return_t ret = IOConnectCallScalarMethod(m_Connection, FOOHID_CREATE, input, 4, &output, &output_count);
    
    free((void*)input[0]);
    
    return ret == KERN_SUCCESS;
}

- (BOOL)destroy {
    uint32_t output_count = 1;
    uint64_t output = 0;
    
    uint64_t input[2];
    input[0] = (uint64_t) strdup([m_Name UTF8String]);
    input[1] = (uint64_t) [m_Name length];
    
    kern_return_t ret = IOConnectCallScalarMethod(m_Connection, FOOHID_DESTROY, input, 2, &output, &output_count);
    
    free((void*)input[0]);
    
    return ret == KERN_SUCCESS;
}

- (BOOL)send:(NSData*)HIDState {
    uint32_t output_count = 1;
    uint64_t output = 0;
    
    uint64_t input[4];
    input[0] = (uint64_t) strdup([m_Name UTF8String]);
    input[1] = (uint64_t) [m_Name length];
    input[2] = (uint64_t) [HIDState bytes];
    input[3] = (uint64_t) [HIDState length];
    
    kern_return_t ret = IOConnectCallScalarMethod(m_Connection, FOOHID_SEND, input, 4, &output, &output_count);
    
    free((void*)input[0]);
    
    return ret == KERN_SUCCESS;
}

@end

@implementation FoohidDeviceImpl (PrivatePart)

+ (io_connect_t)findService {
    io_connect_t conn = IO_OBJECT_NULL;
    io_service_t service = IO_OBJECT_NULL;
    io_iterator_t iterator;
    
    kern_return_t ret = IOServiceGetMatchingServices(
        kIOMasterPortDefault,
        IOServiceMatching(FOOHID_SERVICE),
        &iterator
    );
    
    if (ret != KERN_SUCCESS) {
        return conn;
    }
    
    while ((service = IOIteratorNext(iterator)) != IO_OBJECT_NULL) {
        ret = IOServiceOpen(service, mach_task_self(), 0, &conn);
        if (ret == KERN_SUCCESS) {
            IOObjectRelease(iterator);
            return conn;
        }
    }
    
    IOObjectRelease(iterator);
    return IO_OBJECT_NULL;
}

+ (io_connect_t)createNewConnection {
    return [FoohidDeviceImpl findService];
}

+ (BOOL)isDriverLoaded {
    io_connect_t conn = [FoohidDeviceImpl findService];
    BOOL result  = (conn != IO_OBJECT_NULL);
    
    IOServiceClose(conn);
    IOObjectRelease(conn);
    return result;
}

@end
