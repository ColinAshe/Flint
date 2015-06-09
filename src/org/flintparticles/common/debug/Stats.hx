package org.flintparticles.common.debug;


import flash.events.Event;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


/**
	 * A simple stats display object showing the frame-rate, the memory usage and the number of particles in use.
	 */
class Stats extends TextField
{
    private var FACTOR : Float = 1 / (1024 * 1024);
    private var timer : Int;
    private var fps : Int;
    private var next : Int;
    private var mem : Float;
    private var max : Float;
    
    public function new(color : Int = 0xFFFFFF, bgColor : Int = 0)
    {
        super();
        max = 0;
        
        var tf : TextFormat = new TextFormat();
        tf.color = color;
        tf.font = "_sans";
        tf.size = 9;
        tf.leading = -1;
        
        backgroundColor = bgColor;
        background = true;
        defaultTextFormat = tf;
        multiline = true;
        selectable = false;
        mouseEnabled = false;
        autoSize = TextFieldAutoSize.LEFT;
        
        addEventListener(Event.ADDED_TO_STAGE, start);
        addEventListener(Event.REMOVED_FROM_STAGE, stop);
    }
    
    private function start(e : Event) : Void
    {
        addEventListener(Event.ENTER_FRAME, update);
        text = "";
        next = timer + 1000;
    }
    
    private function stop(e : Event) : Void
    {
        removeEventListener(Event.ENTER_FRAME, update);
    }
    
    private function update(e : Event) : Void
    {
        timer = Math.round(haxe.Timer.stamp() * 1000);
        
        if (timer > next) 
        {
            next = timer + 1000;
            mem = Std.parseFloat((System.totalMemory * FACTOR).toFixed(3));
            if (max < mem) 
            {
                max = mem;
            }
            
            text = "FPS: " + fps + " / " + stage.frameRate + "\nMEMORY: " + mem + "\nMAX MEM: " + max + "\nPARTICLES: " + ParticleFactoryStats.numParticles;
            
            fps = 0;
        }
        
        fps++;
    }
}

