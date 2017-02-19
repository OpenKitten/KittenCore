public protocol Convertible {
    func converted<C : Convertible>() -> C?
}

public protocol SerializableObject {
    associatedtype SupportedValue: Convertible
    
    init(dictionary: [String: SupportedValue])
    
    func getValue(forKey key: String) -> SupportedValue?
    mutating func setValue(to newValue: SupportedValue?, forKey key: String)
    
    func getKeys() -> [String]
    func getValues() -> [SupportedValue]
    func getKeyValuePairs() -> [String: SupportedValue]
}

public protocol IdentifierType : Hashable, Equatable { }

public protocol DatabaseEntity: SerializableObject {
    associatedtype Identifier: IdentifierType
    
    static var defaultIdentifierField: String { get }
    
    func getIdentifier() -> Identifier?
}

extension SerializableObject {
    public func convert<S: SerializableObject>(to type: S.Type) -> (converted: S, remainder: Self) {
        var s = S(dictionary: [:])
        
        var remainder = Self(dictionary: [:])
        
        for (key, value) in self.getKeyValuePairs() {
            if let value = value as? S.SupportedValue {
                s.setValue(to: value, forKey: key)
            } else {
                if let value: S.SupportedValue = value.converted() {
                    s.setValue(to: value.converted(), forKey: key)
                } else {
                    remainder.setValue(to: value, forKey: key)
                }
            }
        }
        
        return (s, remainder)
    }
}
