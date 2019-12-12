{ stdenv, python3, fetchFromGitHub }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "brotab";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "balta2ar";
    repo = "brotab";
    rev = "bf1258321f0a87019ad6c5793e38a293bab7ecf7";
    sha256 = "014slk92687f226vkgsr9pl5x7gs7y6ljbid90dw3p5kw014dqxy";
  };

  propagatedBuildInputs = [ requests psutil flask ipython setuptools ];
  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Control your browser's tabs from the command line";
    homepage = https://github.com/balta2ar/brotab;
    license = licenses.mit;
  };
}
