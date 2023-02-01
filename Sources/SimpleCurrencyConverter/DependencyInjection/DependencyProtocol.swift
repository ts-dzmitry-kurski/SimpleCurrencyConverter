import Foundation

protocol DependencyProtocol {
    func register<Dependency>(type: Dependency.Type, component: Any)
    func resolve<Dependency>(type: Dependency.Type) -> Dependency?
}
