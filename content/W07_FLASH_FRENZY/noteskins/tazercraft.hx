function dadSkin(){
    return 'tazercraft_NOTE_assets';
}
function bfSkin(){
    return 'tazercraft_NOTE_assets';
}

function quants(){
    return true;
}

function offset(note, strum, sus){
    for(s in strum){
        s.y += 10;
        if(ClientPrefs.downScroll)
        {
            s.y -= 15;          
        }
    }
    for(s in sus){
        s.y += 15;

        if(ClientPrefs.downScroll)
        {
            s.y -= 15;          
        }
    }
}