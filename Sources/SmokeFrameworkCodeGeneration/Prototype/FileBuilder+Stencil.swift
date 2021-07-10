import Foundation
import ServiceModelCodeGeneration
import Stencil
import StencilSwiftKit

extension FileBuilder {
    func appendRenderedTemplate(name: String, context: [String: Any]) {
        let name = name.hasPrefix("Templates/") ? name : "Templates/" + name
        var environment = stencilSwiftEnvironment()
        environment.loader = FileSystemLoader(bundle: [Bundle.module])
        appendLine(try! environment.renderTemplate(name: name, context: context))
    }
}
