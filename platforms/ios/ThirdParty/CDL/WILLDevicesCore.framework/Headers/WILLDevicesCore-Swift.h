// Generated by Apple Swift version 4.1.2 (swiftlang-902.0.54 clang-902.0.39.2)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import ObjectiveC;
@import Foundation;
@import WILLInk;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="WILLDevicesCore",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class InkGroup;

/// InkDocument is a DOM tree describing the content of a file containing ink. It has a
/// tree structure with different groups and nodes which present different data releated
/// to the ink
SWIFT_CLASS("_TtC15WILLDevicesCore11InkDocument")
@interface InkDocument : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
/// Create a new <code>InkDocument</code>
/// \param root The root node of the document
///
- (nonnull instancetype)init:(InkGroup * _Nonnull)root OBJC_DESIGNATED_INITIALIZER;
/// Load a document from the spepcified path
- (nullable instancetype)initWithPath:(NSURL * _Nonnull)path OBJC_DESIGNATED_INITIALIZER;
/// Override comparison operation
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
/// Get the root node for the document
///
/// returns:
/// The document root
- (InkGroup * _Nonnull)getRoot SWIFT_WARN_UNUSED_RESULT;
/// Gets the total count of <code>InkStrokes</code> in the document. Iterates through all the groups to fine event stroke
///
/// returns:
/// the count of strokes in the document
- (NSInteger)getStrokesCount SWIFT_WARN_UNUSED_RESULT;
/// Save the InkDocument out to the path
/// \param path the file path to save the document
///
- (BOOL)saveToPath:(NSURL * _Nonnull)path error:(NSError * _Nullable * _Nullable)error;
/// Add an existing document to the end of this document. THis will take the root node of the supplied
/// <code>InkDocument</code> object, and append it to the end of the current document
/// \param document The document to append
///
- (void)append:(InkDocument * _Nonnull)document;
@end


/// Represents a node in the DOM tree of an <code>InkDocument</code> object
SWIFT_CLASS("_TtC15WILLDevicesCore7InkNode")
@interface InkNode : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// Inkgroup is a group that can contain different <code>InkNode</code> objects. Used as the main type of grouping object in the DOM tree of the <code>InkDocument</code>
SWIFT_CLASS("_TtC15WILLDevicesCore8InkGroup")
@interface InkGroup : InkNode
/// Default init method
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
/// Override equality
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
/// Add a new child node to the ink group
/// \param child The inknode to add to this group
///
- (void)addChildWithChild:(InkNode * _Nonnull)child;
/// Get a child at the specified index
/// \param index The index to retrei
///
///
/// returns:
/// The node at the specified index, or nil if no node is found
- (InkNode * _Nullable)getChildWithIndex:(NSInteger)index SWIFT_WARN_UNUSED_RESULT;
/// Get the total number of children in this group
///
/// returns:
/// The number of child nodes
- (NSInteger)size SWIFT_WARN_UNUSED_RESULT;
@end


@class PenId;
enum ToolType : NSInteger;
@class UIColor;
@class WCMFloatVector;
@class RawPoint;
@class UIBezierPath;

/// A node of the <code>InkDocument</code> DOM tree that contains the ink stroke data
SWIFT_CLASS("_TtC15WILLDevicesCore9InkStroke")
@interface InkStroke : InkNode
/// An optional penID that was used to draw the stroke
@property (nonatomic, strong) PenId * _Nullable penID;
/// The type of tool that was used to capture the stroke
@property (nonatomic) enum ToolType toolType;
/// The WILL blend mode for the stroke
@property (nonatomic) WCMBlendMode blendMode;
/// The colour of the stroke
@property (nonatomic, strong) UIColor * _Nullable color;
/// The WILL path for the stroke
@property (nonatomic, strong) WCMFloatVector * _Nullable path;
/// The width parameter for the stroke
@property (nonatomic) float width;
/// Start time of the stroke (0.0 -> 1.0)
@property (nonatomic) float startT;
/// End time of the stroke (1.0 -> (0.0)
@property (nonatomic) float endT;
/// The raw captured points that make up the stroke
@property (nonatomic, copy) NSArray<RawPoint *> * _Nullable rawPoints;
/// A bezier path representation of the WILL stroke
@property (nonatomic, strong) UIBezierPath * _Nullable bezierPath;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
/// Set the interval of the stroke
/// \param start The startT
///
/// \param end The endT
///
- (void)setInterval:(float)start end:(float)end;
/// Override for isEqual
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
@end


/// An object containing the identifier of the pen that was used to create the ink on the InkDevice.
/// This is used to distingush different pens of the same <code>ToolType</code>. The pen ID is presented in the
/// form of eight bytes.
SWIFT_CLASS("_TtC15WILLDevicesCore5PenId")
@interface PenId : NSObject
/// The length of the penID
@property (nonatomic, readonly) NSInteger length;
/// Returns the bytes describing the pen ID as a byte array
@property (nonatomic, readonly, copy) NSArray<NSNumber *> * _Nonnull bytes;
/// Hide default constructor
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
/// Instantiate a new penID by passing a byte array
/// \param penID The penID
///
///
/// throws:
/// If then PenID is invalid, a <code>PenIDError</code> will be thrown
- (nullable instancetype)init:(NSArray<NSNumber *> * _Nonnull)penID error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithB0:(uint8_t)b0 b1:(uint8_t)b1 b2:(uint8_t)b2 b3:(uint8_t)b3 b4:(uint8_t)b4 b5:(uint8_t)b5 b6:(uint8_t)b6 b7:(uint8_t)b7 OBJC_DESIGNATED_INITIALIZER;
@end


/// A point that makes up part of an <code>InkStroke</code> in raw data as reported by the capture device.
/// A raw point is described with 4 dimensions - x position, y position, pressure and the time
/// when the point was created. If altitude and azimuth are supported by the device, these will
/// also be recorded in the data, otherwise this will be nil. If the device doesn’t support
/// pressure (e.g. finger input) then the pressure field will also be nil. The rotation paramter
/// of a point refers to the amount of rotation on the input device itself (e.g the roll of the
/// stylus). If this is not supported by the input device, this parameter will be nil.
SWIFT_CLASS("_TtC15WILLDevicesCore8RawPoint")
@interface RawPoint : NSObject
/// The x coodinate of the point
@property (nonatomic) NSInteger x;
/// The y coordinate of the point
@property (nonatomic) NSInteger y;
/// The pressure value of the point
@property (nonatomic) CGFloat p;
/// The timestamp for the captured point (TimeInterval since 1970)
@property (nonatomic) NSTimeInterval t;
/// The angle of tile of the pen relative to the drawing surface. If this isn’t supported by the capture device, this value will be MAXFLOAT
@property (nonatomic) CGFloat altitude;
/// The planar rotation of the pen relative to the axis of the drawing surface. If this isn’t supported by the capture device, this value will be MAXFLOAT
@property (nonatomic) CGFloat azimuth;
/// The rotation of the pen in the hand. If this isn’t supported by the capture device, this value will be MAXFLOAT
@property (nonatomic) CGFloat rotation;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


@interface RawPoint (SWIFT_EXTENSION(WILLDevicesCore)) <NSCopying>
- (id _Nonnull)copyWithZone:(struct _NSZone * _Nullable)zone SWIFT_WARN_UNUSED_RESULT;
@end

/// Specifies the device types that can be used to produce digital ink
/// <ul>
///   <li>
///     unknown: Unkown device
///   </li>
///   <li>
///     touch: Touch input
///   </li>
///   <li>
///     wacomBallPen: Wacom ball point pen
///   </li>
///   <li>
///     wacomPencil: Wacom pencil
///   </li>
///   <li>
///     wacomGelPen: Wacom gel pen
///   </li>
///   <li>
///     wacomBluetoothStylus: Wacom BTLE stylus
///   </li>
///   <li>
///     applePencil: Apple Pencil
///   </li>
/// </ul>
typedef SWIFT_ENUM(NSInteger, ToolType) {
  ToolTypeWacomBallPen = 0,
  ToolTypeWacomPencil = 1,
  ToolTypeWacomGelPen = 2,
  ToolTypeWacomBluetoothStylus = 3,
  ToolTypeApplePencil = 4,
  ToolTypeUnknown = 5,
  ToolTypeTouch = 6,
};

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
