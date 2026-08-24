# Homebrew formula template for memo.
#
# The release workflow substitutes the placeholder tokens below with the version
# and the sha256 sums from the published release, then commits the result to
# cardiadev/homebrew-tap as Formula/memo.rb.
#
# Edit this template, never the generated copy in the tap.
class Memo < Formula
  desc "Per-repository vector memory for AI coding agents"
  homepage "https://github.com/cardiadev/memo"
  version "0.3.3"
  license "MIT"

  # Apple Silicon and Linux x64 only. Intel Macs are out of scope by choice;
  # Linux arm64 is blocked upstream (no arm64 tokenizer build).
  on_macos do
    on_arm do
      url "https://github.com/cardiadev/memo/releases/download/v#{version}/memo-darwin-arm64.tar.gz"
      sha256 "fe0704b978ad100852eaaab4f097b6772817534699edde2c6f29ebb3d3a64f99"
    end
    on_intel do
      odie "memo does not support Intel Macs. Apple Silicon (M1 or later) is required."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cardiadev/memo/releases/download/v#{version}/memo-linux-x64.tar.gz"
      sha256 "40fa8607eb162915a26b72e35cb391d28df4ab4f0c9fbe608a63f1b29591e7bf"
    end
    on_arm do
      odie "memo does not support Linux ARM64: the embedding tokenizer has no arm64 build upstream."
    end
  end

  def install
    libexec.install Dir["*"]
    (bin/"memo").write_env_script libexec/"bin/memo", {}
  end

  def caveats
    <<~EOS
      Wire memo into your AI agents:
        memo install

      Then initialize a repository:
        cd <your-project> && memo init
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memo version")
  end
end
