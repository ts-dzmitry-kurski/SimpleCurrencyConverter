import Foundation

public final class DependencyContainer: DependencyProtocol {

    private var dependencies: [String: Any] = [:]
    
    public func register<Dependency>(type: Dependency.Type, component dependency: Any) {
        dependencies["\(type)"] = dependency
    }
    
    public func resolve<Dependency>(type: Dependency.Type) -> Dependency? {
        dependencies["\(type)"] as? Dependency
    }
    
}
