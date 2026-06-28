class Corvinos < Formula
  include Language::Python::Virtualenv

  desc "Self-hosted agentic AI assistant for Discord, Telegram, WhatsApp, Slack & Email"
  homepage "https://corvin-labs.com"
  url "https://files.pythonhosted.org/packages/52/86/1fde599f4d017694f2dad95b43c519dbf46fcd4e32a025e3cceb630c799c/corvinos-0.9.52.tar.gz"
  sha256 "c956078c48fd8d6f2e11cbdabde4ba25cd3258e25812ad62a36ce29e211529d5"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "python@3.12"

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/source/a/anthropic/anthropic-0.40.0.tar.gz"
    sha256 "placeholder"  # filled by brew audit --fix
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"corvin", "--help"
  end
end
