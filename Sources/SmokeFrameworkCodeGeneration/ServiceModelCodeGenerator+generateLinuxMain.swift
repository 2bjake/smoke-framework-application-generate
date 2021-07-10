// Copyright 2019-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//
//  ServiceModelCodeGenerator+generateLinuxMain.swift
//  SmokeFrameworkCodeGeneration
//

import Foundation
import ServiceModelCodeGeneration
import SwiftSyntax

private class LinuxMainRewriter: SyntaxRewriter {
    private let operations: [String]
    private let baseNameRewriter: IdentifierRewriter

    init(baseName: String, operations: [String]) {
        self.operations = operations.sorted(by: <).map { $0.startingWithUppercase }
        baseNameRewriter = IdentifierRewriter(pattern: "$baseName$", replacement: baseName)
    }

    override func visit(_ token: TokenSyntax) -> Syntax {
        baseNameRewriter.visit(token)
    }

    override func visit(_ node: ArrayElementListSyntax) -> Syntax {
        guard let child = node.first else { return Syntax(node) }
        var newNode = node.removingLast()
        for operation in operations {
            let newChild = ArrayElementSyntax(IdentifierRewriter(pattern: "$operationName$", replacement: operation).visit(child))!
            newNode = newNode.appending(newChild)
        }
        return Syntax(newNode)
    }
}

extension ServiceModelCodeGenerator {

    func generateLinuxMain() {
        let fileBuilder = FileBuilder()
        let baseName = applicationDescription.baseName
        let baseFilePath = applicationDescription.baseFilePath

        let templateURL = Bundle.module.url(forResource: "Templates/LinuxMain", withExtension: "tmpl")!
        let templateSource = try! SyntaxParser.parse(templateURL)

        let rewriter = LinuxMainRewriter(baseName: baseName, operations: Array(model.operationDescriptions.keys))

        let rewritten = rewriter.visit(templateSource)
        fileBuilder.appendLine("\(rewritten)")

        let fileName = "LinuxMain.swift"
        fileBuilder.write(toFile: fileName, atFilePath: "\(baseFilePath)/Tests")
    }
}
