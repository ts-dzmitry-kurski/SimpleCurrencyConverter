import Foundation

public final class DependencyContainer: DependencyProtocol {
    
    public static let shared = DependencyContainer()
    
    private init() {}
    
    private var dependencies: [String: Any] = [:]
    
    public func register<Dependency>(type: Dependency.Type, component dependency: Any) {
        dependencies["\(type)"] = dependency
    }
    
    public func resolve<Dependency>(type: Dependency.Type) -> Dependency? {
        dependencies["\(type)"] as? Dependency
    }
    
}
