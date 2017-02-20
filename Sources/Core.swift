import Foundation

public protocol Convertible {
    func convert<S : SerializableObject>(toType type: S.Type) -> S.SequenceType.SupportedValue?
    func convert<S : InitializableSequence>(toType type: S.Type) -> S.SupportedValue?
}

public protocol SimpleConvertible : Convertible {
    func convert<S: Any>() -> S?
}

extension SimpleConvertible {
    public func convert<S>(toType type: S.Type) -> S.SequenceType.SupportedValue? where S : SerializableObject {
        return self.convert()
    }
    
    public func convert<S>(toType type: S.Type) -> S.SupportedValue? where S : InitializableSequence {
        return self.convert()
    }
}

public protocol SerializableObject : Convertible {
    associatedtype SequenceType : InitializableSequence
    associatedtype HashableKey : Hashable
    
    init(dictionary: [HashableKey: SequenceType.SupportedValue])
    
    func getValue(forKey key: HashableKey) -> SequenceType.SupportedValue?
    mutating func setValue(to newValue: SequenceType.SupportedValue?, forKey key: HashableKey)
    
    func getKeys() -> [HashableKey]
    func getValues() -> [SequenceType.SupportedValue]
    func getKeyValuePairs() -> [HashableKey: SequenceType.SupportedValue]
    
    static func convert(_ value: Any) -> SequenceType.SupportedValue?
}

extension SerializableObject {
    public func convert<S>(to type: S.Type) -> (converted: S, remainder: Self) where S : SerializableObject {
        var s = S(dictionary: [:])
        
        var remainder = Self(dictionary: [:])
        
        loop: for (key, value) in self.getKeyValuePairs() {
            if let key = key as? S.HashableKey {
                if let value = value as? S.SequenceType.SupportedValue {
                    s.setValue(to: value, forKey: key)
                    continue loop
                } else if let value = value as? Convertible {
                    if let value: S.SequenceType.SupportedValue = value.convert(toType: type) {
                        s.setValue(to: value, forKey: key)
                        continue loop
                    }
                }
                
                if let newValue = S.convert(value) {
                    s.setValue(to: newValue, forKey: key)
                }
            }
            
            remainder.setValue(to: value, forKey: key)
        }
        
        return (s, remainder)
    }
    
    public func convert<S>(to type: S.Type) -> S where S : InitializableSequence {
        return S(sequence: self.getValues().flatMap { value in
            if let value = value as? S.SupportedValue {
                return value
            } else if let value = value as? Convertible {
                if let value: S.SupportedValue = value.convert(toType: type) {
                    return value
                }
            }
            
            return nil
        })
    }
    
    public func convert<S>(toType type: S.Type) -> S.SequenceType.SupportedValue? where S : SerializableObject {
        return convert(to: type).converted as? S.SequenceType.SupportedValue
    }
    
    public func convert<S>(toType type: S.Type) -> S.SupportedValue? where S : InitializableSequence {
        return convert(to: type) as? S.SupportedValue
    }
}

public protocol SerializableSequence : Convertible, Sequence {
    associatedtype SupportedValue
}

public protocol InitializableSequence : SerializableSequence {
    init<S: Sequence>(sequence: S) where S.Iterator.Element == SupportedValue
}

extension SerializableSequence {
    mutating func convert<IS: InitializableSequence>(to type: IS.Type) -> IS {
        var iterator = self.makeIterator()
        
        return IS(sequence: self.flatMap { value in
            if let value = iterator.next() {
                if let value = value as? IS.SupportedValue {
                    return value
                } else if let value = value as? Convertible {
                    if let value: IS.SupportedValue = value.convert(toType: type) {
                        return value
                    }
                }
            }
            
            return nil
        })
    }
    
    public func convert<S>(toType type: S.Type) -> S.SupportedValue? where S : InitializableSequence {
        let sequence: [S.SupportedValue] = self.flatMap { element in
            if let element = element as? Convertible {
                return element.convert(toType: type)
            }
            
            return element as? S.SupportedValue
        }
        
        return S(sequence: sequence) as? S.SupportedValue
    }
    
    public func convert<S>(toType type: S.Type) -> S.SequenceType.SupportedValue? where S : SerializableObject {
        if self is S.SequenceType.SupportedValue {
            return self as? S.SequenceType.SupportedValue
        }
        
        return self.convert(toType: S.SequenceType.self)
    }
}

extension Dictionary : SerializableObject {
    public typealias SequenceType = Array<Value>
    
    public mutating func setValue(to newValue: Value?, forKey key: Key) {
        self[key] = newValue
    }
    
    public func getKeys() -> [Key] {
        return Array(self.keys)
    }
    
    public func getValues() -> [Value] {
        return Array(self.values)
    }
    
    public init(dictionary: [Key : Value]) {
        self = dictionary
    }
    
    public func getKeyValuePairs() -> [Key : Value] {
        return self
    }
    
    public func getValue(forKey key: Key) -> Value? {
        return self[key]
    }
    
    public static func convert(_ value: Any) -> Value? {
        return value as? Value
    }
}

extension Array : InitializableSequence {
    public typealias SupportedValue = Element
    
    public init<S>(sequence: S) where S : Sequence, S.Iterator.Element == Element {
        self = Array(sequence)
    }
}

extension String : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        if Double.self is S, let number = Double(self) as? S {
            return number
        }
        
        if Int.self is S, let number = Int(self) as? S {
            return number
        }
        
        if UInt.self is S, let number = UInt(self) as? S {
            return number
        }
        
        if UInt64.self is S, let number = UInt64(self) as? S {
            return number
        }
        
        if UInt32.self is S, let number = UInt32(self) as? S {
            return number
        }
        
        if UInt16.self is S, let number = UInt16(self) as? S {
            return number
        }
        
        if UInt8.self is S, let number = UInt8(self) as? S {
            return number
        }
        
        if Int64.self is S, let number = Int64(self) as? S {
            return number
        }
        
        if Int32.self is S, let number = Int32(self) as? S {
            return number
        }
        
        if Int16.self is S, let number = Int16(self) as? S {
            return number
        }
        
        if Int8.self is S, let number = Int8(self) as? S {
            return number
        }
        
        return nil
    }
}

extension StaticString : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        return nil
    }
}

extension Bool : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        return nil
    }
}

extension Data : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        return nil
    }
}

extension NSRegularExpression : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        return nil
    }
}

public struct Null : SimpleConvertible {
    public func convert<S>() -> S? {
        if self is S {
            return self as? S
        }
        
        return nil
    }
    
    public init() {}
}
