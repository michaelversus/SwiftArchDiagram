class Swiftarchdiagram < Formula
  desc "This is a command-line tool that generates mermaid diagram for Swift Packages"
  homepage "https://github.com/michaelversus/SwiftArchDiagram"
  url "https://github.com/michaelversus/SwiftArchDiagram"
  version "0.1.2"
  sha256 "6dd0a2364041d4a969b969c7fe181b17b6a15b387d0db06cff9bc6b0cc208bda"
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
