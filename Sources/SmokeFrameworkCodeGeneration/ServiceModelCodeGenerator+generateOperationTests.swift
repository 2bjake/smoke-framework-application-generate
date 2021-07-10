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
//  ServiceModelCodeGenerator+generateOperationTests.swift
//  SmokeFrameworkCodeGeneration
//

import Foundation
import ServiceModelCodeGeneration
import ServiceModelEntities

extension ServiceModelCodeGenerator {
    /**
     Generate the example operation unit tests for the generated application.
     */
    func generateOperationTests(generationType: GenerationType, operationStubGenerationRule: OperationStubGenerationRule) {
        let baseName = applicationDescription.baseName
        let baseFilePath = applicationDescription.baseFilePath
        let filePath = "\(baseFilePath)/Tests/\(baseName)OperationsTests"

        // iterate through each operation
        for (operationName, operationDescription) in model.operationDescriptions {
            let name = operationName.startingWithUppercase

            // skip this operation if it doesn't have an
            // input structure or output structure
            guard let input = operationDescription.input else {
                continue
            }

            let fileName = "\(name)Tests.swift"
            
            if case .serverUpdate = generationType {
                guard !FileManager.default.fileExists(atPath: "\(filePath)/\(fileName)") else {
                    continue
                }
            }

            let withinContext = operationStubGenerationRule.getStubGeneration(forOperation: operationName) == .functionWithinContext
            let context: [String: Any] = [
                "baseName": baseName,
                "name": name,
                "input": input,
                "output": operationDescription.output ?? "",
                "withinContext": withinContext,
                "tryPrefix": !operationDescription.errors.isEmpty ? "try " : ""
            ]

            let fileBuilder = FileBuilder()
            fileBuilder.appendRenderedTemplate(name: "OperationTest.tmpl", context: context)
            fileBuilder.write(toFile: fileName,
                              atFilePath: filePath)
        }
    }
}
