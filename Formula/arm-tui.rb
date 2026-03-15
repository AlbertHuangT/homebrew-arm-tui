class ArmTui < Formula
  desc "ARM v7 assembly step debugger with a GDB-style terminal UI"
  homepage "https://github.com/AlbertHuangT/Arm-TUI"
  url "https://github.com/AlbertHuangT/Arm-TUI/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "85c1c15c1cd7f73c34b7c968774c255027b724d4765b6d8c759244913647d39e"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "unicorn"

  def install
    # Dependencies are vendored in the repo; build fully offline
    system "cargo", "install",
           "--locked",
           "--offline",
           "--root", prefix,
           "--path", "."
  end

  test do
    # Write a minimal ARM32 program and verify the binary runs
    (testpath/"test.s").write <<~EOS
      .global main
      main:
        mov r0, #0
        mov r7, #1
        svc #0
    EOS
    output = shell_output("#{bin}/arm-tui --help 2>&1")
    assert_match "arm-tui", output
  end
end
