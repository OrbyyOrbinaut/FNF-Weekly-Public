function onCreatePost(){
    function numericForInterval(start, end, interval, func){
        var index = start;
        while(index < end){
            func(index);
            index += interval;
        }
    }

    var counter:Int = -1;
    numericForInterval(656, 916, 4, function(step){
        counter = counter +1;
        if(counter > 1)counter = 0;

        if(counter == 0){
            modManager.queueEase(step, step+1, "transform0Y", -15, 'quadInOut');
            modManager.queueEase(step, step+1, "transform1Y", 15, 'quadInOut');
            modManager.queueEase(step, step+1, "transform2Y", -15, 'quadInOut');
            modManager.queueEase(step, step+1, "transform3Y", 15, 'quadInOut');
        }
        else
        {
            modManager.queueEase(step, step+1, "transform0Y", 15, 'quadInOut');
            modManager.queueEase(step, step+1, "transform1Y", -15, 'quadInOut');
            modManager.queueEase(step, step+1, "transform2Y", 15, 'quadInOut');
            modManager.queueEase(step, step+1, "transform3Y", -15, 'quadInOut');
        }
    });

    modManager.queueEase(916, 917, "transform0Y", 0, 'quadInOut');
    modManager.queueEase(916, 917, "transform1Y", 0, 'quadInOut');
    modManager.queueEase(916, 917, "transform2Y", 0, 'quadInOut');
    modManager.queueEase(916, 917, "transform3Y", 0, 'quadInOut');
}