import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .previewProject(
  projectName: "GPT",
  packages: [
    .local(path: "../../Feature/GPT"),
    .local(path: "../../Core/Architecture"),
    .local(path: "../../Core/DesignSystem"),
    .local(path: "../../Core/Domain"),
    .local(path: "../../Core/Platform"),
  ],
  dependencies: [
    .package(product: "GPT"),

  ])
