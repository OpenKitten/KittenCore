import Foundation

func representSigned<I : SignedInteger, S>(_ i: I) -> S? {
    let largeInt = numericCast(i) as Int64
    
    if Int.self is S, largeInt >= Int64(Int.min), largeInt <= Int64(Int.max) {
        return largeInt as? S
    }
    
    if Int64.self is S, largeInt >= Int64(Int64.min), largeInt <= Int64(Int64.max) {
        return (numericCast(i) as Int64) as? S
    }
    
    if Int32.self is S, largeInt >= Int64(Int32.min), largeInt <= Int64(Int32.max) {
        return (numericCast(i) as Int32) as? S
    }
    
    if Int16.self is S, largeInt >= Int64(Int16.min), largeInt <= Int64(Int16.max) {
        return (numericCast(i) as Int16) as? S
    }
    
    if Int8.self is S, largeInt >= Int64(Int8.min), largeInt <= Int64(Int8.max) {
        return (numericCast(i) as Int8) as? S
    }
    
    return nil
}

func representUnsigned<I : UnsignedInteger, S>(_ i: I) -> S? {
    let largeInt = numericCast(i) as UInt64
    
    if UInt.self is S, largeInt <= UInt64(Int.max) {
        return largeInt as? S
    }
    
    if UInt64.self is S, largeInt <= UInt64(Int64.max) {
        return (numericCast(i) as Int64) as? S
    }
    
    if UInt32.self is S, largeInt <= UInt64(Int32.max) {
        return (numericCast(i) as Int32) as? S
    }
    
    if UInt16.self is S, largeInt <= UInt64(Int16.max) {
        return (numericCast(i) as Int16) as? S
    }
    
    if UInt8.self is S, largeInt <= UInt64(Int8.max) {
        return (numericCast(i) as Int8) as? S
    }
    
    return nil
}

extension Int : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representSigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension Int8 : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representSigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension Int16 : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representSigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension Int32 : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representSigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension Int64 : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representSigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension UInt : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representUnsigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension UInt8 : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representUnsigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension UInt16 : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representUnsigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension UInt32 : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representUnsigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }}

extension UInt64 : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if let new = representUnsigned(self) as S? {
            return new
        }
        
        if Double.self is S {
            return Double(self) as? S
        }
        
        return nil
    }
}

extension Date : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if Double.self is S {
            return self.timeIntervalSince1970 as? S
        }
        
        if let signedInteger = representSigned(Int(self.timeIntervalSince1970)) as S? {
            return signedInteger
        }
        
        return nil
    }
}

extension Double : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if self > 0 {
            return representUnsigned(UInt(self))
        }
        
        return representSigned(Int(self))
    }
}
