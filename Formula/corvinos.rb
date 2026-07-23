class Corvinos < Formula
  include Language::Python::Virtualenv

  desc "Agentic OS. EU AI Act & GDPR compliance by design — connects Ollama to Discord, Telegram, WhatsApp, Slack & Email"
  homepage "https://corvin-labs.com"
  url "https://files.pythonhosted.org/packages/15/73/2b30603ec406fc974f5945a85599487e696eef7ff884fc601b38490199da/corvinos-0.10.60.tar.gz"
  sha256 "b047b3a605213a58a829d0df2f26af7144dda588d6387139779003797ab7def9"
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
