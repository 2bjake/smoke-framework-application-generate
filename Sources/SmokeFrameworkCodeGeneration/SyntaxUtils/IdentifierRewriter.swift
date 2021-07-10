import SwiftSyntax

class IdentifierRewriter: SyntaxRewriter {
    let pattern: String
    let replacement: String

    init(pattern: String, replacement: String) {
        self.pattern = pattern
        self.replacement = replacement
    }

    override func visit(_ token: TokenSyntax) -> Syntax {
        guard case .identifier(let identifier) = token.tokenKind else { return Syntax(token) }
        let newIdentifier = identifier.replacingOccurrences(of: pattern, with: replacement)
        guard newIdentifier != identifier else { return Syntax(token) }
        return Syntax(token.withKind(.identifier(newIdentifier)))
    }
}
