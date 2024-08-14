function dadSkin(){
    return 'NOTE_assets_crust';
}
function bfSkin(){
    return 'NOTE_assets_crust';
}

function quants(){
    return true;
}

function offset(note, strum, sus){
    for(s in note){
        s.x += 20;
        s.y += 20;
    }
    for(s in sus){
        s.x -= 15;
        s.y -= 20;
    }
}