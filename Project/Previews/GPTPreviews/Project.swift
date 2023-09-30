import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .previewProject(
  projectName: "GPT",
  packages: [
    .local(path: "../../Feature/GPT"),
  ],
  dependencies: [
    .package(product: "GPT"),
  ])
