// Nice touch with JavaScrip

let foot = document.getElementsByClassName("pkgdown-footer-left");

if (foot.length > 0) {
  footdiv = foot[0];

  text = '<p class="mt-4">Part of <a href="http://ropengov.org/">' +
    '<img src="http://ropengov.org/images/logo2020_white_orange.svg"' +
    ' height="20" class="d-inline-block mx-1" alt="rOpenGov R packages for open government data analytics"' +
    ' style="margin-bottom: 5px;"></a></p>';

  footdiv.innerHTML += text
  
}
