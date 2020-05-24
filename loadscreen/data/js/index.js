$(document).ready(function(){
    const introTag = document.getElementById('esx_intro');
    const loopTag = document.getElementById('esx_loop');

    introTag.onended = function() {
        introTag.style.display = 'none';
        loopTag.play();
    }
})