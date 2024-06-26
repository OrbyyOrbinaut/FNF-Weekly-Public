
function dadSkin(){
    return 'skullkid/majora_NOTE_assets';
}
function bfSkin(){
    return 'skullkid/majora_NOTE_assets';
}

function quants(){
    return false;
}

function offset(note, strum, sus){
    for(s in strum){
        s.x += 35;
        s.y += 35;
    }
    for(s in sus){
        s.x += 2;

        if(ClientPrefs.downScroll)
        {
            s.y -= 40;          
        }
    }
}