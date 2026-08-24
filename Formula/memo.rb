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
  version "0.3.2"
  license "MIT"

  # Apple Silicon and Linux x64 only. Intel Macs are out of scope by choice;
  # Linux arm64 is blocked upstream (no arm64 tokenizer build).
  on_macos do
    on_arm do
      url "https://github.com/cardiadev/memo/releases/download/v#{version}/memo-darwin-arm64.tar.gz"
      sha256 "2bd9740f1007d639291958e36607df37ef670dc05c4babf485a9dd1a5e41d383"
    end
    on_intel do
      odie "memo does not support Intel Macs. Apple Silicon (M1 or later) is required."
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cardiadev/memo/releases/download/v#{version}/memo-linux-x64.tar.gz"
      sha256 "c2a58717fdfad3ea0e2ce3508034a136271faf5aed6440cfb0c2945c376a3018"
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
