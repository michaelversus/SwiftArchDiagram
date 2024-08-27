class Swiftarchdiagram < Formula
  desc "This is a command-line tool that generates mermaid diagram for Swift Packages"
  homepage "https://github.com/michaelversus/SwiftArchDiagram"
  url "https://github.com/michaelversus/SwiftArchDiagram"
  version "0.1.0"
  sha256 "66e8f0bab44097f28a9049b1f1b228c4a3ac3c583ebf3ceee95d30a921fe3d54"
  license "MIT"
  uses_from_macos "swift"
  def install
    system "swift", "build", "-c", "release"
    bin.install ".build/release/SwiftArchDiagram"
  end

  test do
    system "#{bin}/SwiftArchDiagram", "--version"
  end
end
