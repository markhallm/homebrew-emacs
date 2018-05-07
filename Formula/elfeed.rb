require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Elfeed < EmacsFormula
  desc "Feed reader for Emacs"
  homepage "https://github.com/skeeto/elfeed"
  url "https://github.com/skeeto/elfeed/archive/2.3.0.tar.gz"
  sha256 "bbffa9fa3cf7ab78b57c55a34717222dfa985dbfb768fadbdb69e18041afa1b9"
  head "https://github.com/skeeto/elfeed.git"

  depends_on EmacsRequirement => "24.3"
  depends_on "dunn/emacs/simple-httpd"

  def install
    byte_compile Dir["web/*.el"]
    elisp.install "web"

    system "make", "test"
    elisp.install (Dir["*.el"] - %w[elfeed-pkg.el]), Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "elfeed")
      (print elfeed-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
