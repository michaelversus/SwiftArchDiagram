# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SwiftArchDiagram < Formula
  desc "A command line tool that generates mermaid diagram for Swift Packages"
  homepage "https://github.com/michaelversus/SwiftArchDiagram"
  url "https://github.com/michaelversus/SwiftArchDiagram"
  version "0.1.0"
  sha256 "5b1c2d8089125e839339690a82018fbd9cb2962a5ee13a6f8b2dbde68f4fb393"
  license ""

  # depends_on "cmake" => :build

  def install
    bin.install "SwiftArchDiagram"
  end

  test do
    system "#{bin}/SwiftArchDiagram", "--version"
  end
end
