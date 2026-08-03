# Homebrew formula TEMPLATE for the thatsmyhuman CLI suite.
#
# This file is a TEMPLATE. The release workflow substitutes the {{TOKENS}} below
# with the concrete version and per-arch URL/sha256 pairs, then commits the
# rendered formula to the tap repo `thatsmyhuman/homebrew-tmh` as `Formula/tmh.rb`.
# Substituting the tokens yields syntactically valid Ruby (all string tokens are
# already inside quotes), so `ruby -c` and `brew style` pass on the rendered file.
#
# Tap layout means users run:  brew install thatsmyhuman/tmh/tmh
#
# The formula wrapper is MIT-licensed. The installed binaries are proprietary.
class Tmh < Formula
  desc "Secure credential broker and agent-identity CLI (tmh, tmh-broker, mcp-agent)"
  homepage "https://github.com/thatsmyhuman/tmh-install"
  version "0.1.0"

  # macOS-only binary formula: the binaries are glibc-linked, so Linuxbrew is
  # unsupported. `depends_on :macos` refuses non-macOS installs; Linux users are
  # directed to the install script (curl | sh) by the tap README. (component
  # order: dependencies must precede the on_os blocks per `brew style`.)
  depends_on :macos
  # SoftHSM provides the PKCS#11 token store tmh uses for agent key material.
  depends_on "softhsm"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thatsmyhuman/tmh-install/releases/download/v0.1.0/tmh_darwin_arm64.tar.gz"
      sha256 "f15225e2c9953f62a6f5a93218a9038f98c84792be3da89e064668f5964ec7e4"
    else
      url "https://github.com/thatsmyhuman/tmh-install/releases/download/v0.1.0/tmh_darwin_amd64.tar.gz"
      sha256 "8d8b6005a4d05bd9e96bb25c297c73b12dbcad67b69cddae58ace2d061b76f67"
    end
  end

  def install
    bin.install "tmh", "tmh-broker", "mcp-agent"
  end

  def caveats
    <<~EOS
      Before first use, initialize the SoftHSM token store (idempotent — safe to
      re-run, and identical to what the install script does):

        tmh init-hsm

      This lands Homebrew installs in the same post-install state as the
      curl | sh installer. Then enroll this machine against your portal:

        tmh enroll --portal-url <your-portal-url>

      Releases are signed with minisign. The pinned public key is published at
      {portal}/minisign.pub and in the tmh-install README:
        https://github.com/thatsmyhuman/tmh-install#readme

      The tmh binaries are proprietary; this formula wrapper is MIT-licensed.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmh version")
  end
end
