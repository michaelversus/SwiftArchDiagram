class Swiftarchdiagram < Formula
  desc "This is a command-line tool that generates mermaid diagram for Swift Packages"
  homepage "https://github.com/michaelversus/SwiftArchDiagram"
  url "https://github.com/michaelversus/SwiftArchDiagram"
  version "0.1.1"
  sha256 "8ef1dccba56b351b4df1f9998d6309038a9cced2ca1a5753b001ef6742fe2a92"
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
