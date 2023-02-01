import Foundation

public final class DependencyContainer: DependencyProtocol {

  static let shared = DependencyContainer()

  private init() {}

  var dependencies: [String: Any] = [:]

  func register<Dependency>(type: Dependency.Type, dependency: Any) {
      dependencies["\(type)"] = dependency
  }

  func resolve<Dependency>(type: Dependency.Type) -> Dependency? {
    return dependencies["\(type)"] as? Dependency
  }
    
}
