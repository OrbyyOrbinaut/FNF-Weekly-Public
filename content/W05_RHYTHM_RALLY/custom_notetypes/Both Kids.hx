function opponentNoteHit(note){
    if(note.noteType == 'Both Kids'){
        game.gf.playAnim(game.singAnimations[note.noteData], true);
        game.gf.holdTimer = 0;
    } 
}