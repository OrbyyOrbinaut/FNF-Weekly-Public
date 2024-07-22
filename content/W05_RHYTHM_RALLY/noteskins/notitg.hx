function dadSkin(){
    return 'notitg_NOTE_assets';
}
function bfSkin(){
    return 'notitg_NOTE_assets';
}

function noteSplash(){
    return 'noteSplashes';
}

function quants(){
    return true;
}


function offset(note, strum, sus){
    for(s in sus){
        s.x -= 2;
        s.y += 15;
    }
}