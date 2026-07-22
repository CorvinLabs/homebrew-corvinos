class Corvinos < Formula
  include Language::Python::Virtualenv

  desc "Agentic OS. EU AI Act & GDPR compliance by design — connects Ollama to Discord, Telegram, WhatsApp, Slack & Email"
  homepage "https://corvin-labs.com"
  url "https://files.pythonhosted.org/packages/1c/91/fc6ca1c9834d2597550e2adcd2bd0a9321e95d1a615bff628a1022f1972a/corvinos-0.10.58.tar.gz"
  sha256 "54cd5f17256d5839ae7166b78d97fad0abeb16ece2e529333cd5d8946722da5d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :pypi
  end

  depends_on "python@3.12"

  # NOTE (2026-07-22): do NOT switch this back to `virtualenv_install_with_resources`.
  # That helper runs `pip install --no-deps`, so every one of CorvinOS's 46 runtime
  # dependencies would need its own `resource` block, regenerated on every release.
  # The previous formula declared exactly one resource (anthropic) and carried the
  # literal `sha256 "placeholder"`, so `brew install corvinos` could never succeed.
  # Installing the hash-verified sdist with plain pip resolves dependencies normally
  # and keeps the formula to a single version bump per release.
  def install
    virtualenv_create(libexec, "python3.12")
    system libexec/"bin/pip", "install", "--disable-pip-version-check", buildpath
    bin.install_symlink Dir[libexec/"bin/corvin*"]
  end

  def caveats
    <<~EOS
      Get started with:
        corvin-install    # interactive bridge + model setup
        corvin-serve      # web console on http://127.0.0.1:8765

      Browser automation is an optional extra:
        #{libexec}/bin/pip install 'corvinos[browser]' && corvin-install --browser
    EOS
  end

  test do
    # The entry points must exist and be runnable through the linked bin.
    assert_predicate bin/"corvin-serve", :exist?
    assert_predicate bin/"corvin-install", :exist?
    system bin/"corvin", "--help"

    # The installed distribution must report this formula's version — catches a
    # stale-pin or a partially-installed venv, which the old formula did not.
    output = shell_output("#{libexec}/bin/python -c " \
                          "'import importlib.metadata as m; print(m.version(\"corvinos\"))'")
    assert_equal version.to_s, output.strip
  end
end
