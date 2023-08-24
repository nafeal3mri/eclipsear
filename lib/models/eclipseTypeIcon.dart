class EclipseIcon {
  var eclipseImg = '';
  getimageFromVar(eclipsetype, eclipsemg, solarorlunar) {
    if (solarorlunar == 'solar') {
      if (eclipsetype == 'partialEclipse' && eclipsemg < 0.01) {
        eclipseImg = 'assets/eclipses/sep0.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg < 0.2) {
        eclipseImg = 'assets/eclipses/sep1.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg < 0.3) {
        eclipseImg = 'assets/eclipses/sep2.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg < 0.4) {
        eclipseImg = 'assets/eclipses/sep3.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg < 0.5) {
        eclipseImg = 'assets/eclipses/sep4.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg < 0.6) {
        eclipseImg = 'assets/eclipses/sep5.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg < 0.7) {
        eclipseImg = 'assets/eclipses/sep6.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg < 0.8) {
        eclipseImg = 'assets/eclipses/sep7.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg < 0.9) {
        eclipseImg = 'assets/eclipses/sep8.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg > 0.9) {
        eclipseImg = 'assets/eclipses/sep9.png';
      } else if (eclipsetype == 'partialEclipse' && eclipsemg > 1) {
        eclipseImg = 'assets/eclipses/sep10.png';
      } else if (eclipsetype == 'annularEclipse') {
        eclipseImg = 'assets/eclipses/sean9.png';
      } else if (eclipsetype == 'totalEclipse') {
        eclipseImg = 'assets/eclipses/fulleclipse.png';
      } else {
        eclipseImg = 'assets/eclipses/sunny.png';
      }
    } else {
      if (eclipsetype == 'totalEclipse') {
        eclipseImg = 'assets/eclipses/totallunareclipse.png';
      } else if (eclipsetype == 'partialEclipse') {
        eclipseImg = 'assets/eclipses/pleclipse.png';
      } else if (eclipsetype == 'penumbralEclipse') {
        eclipseImg = 'assets/eclipses/penleclipse.png';
      } else {
        eclipseImg = 'assets/eclipses/totallunareclipse.png';
      }
    }
    return eclipseImg;
  }
}