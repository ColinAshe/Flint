  /*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org
 * 
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */  

package org.flintparticles.common.utils;


import org.flintparticles.common.events.UpdateEvent;

import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.EventDispatcher;


/**
	 * This class is used to provide a constant tick event to update the emitters
	 * every frame. This is the internal tick that is used when the useInternalTick
	 * property of the emitter is set to true.
	 * 
	 * <p>Usually developers don't need to use this class at all - its use is
	 * internal to the Emitter classes.</p>
	 * 
	 * @see org.flintparticles.common.emitters.Emitter.Emitter()
	 */
class FrameUpdater extends EventDispatcher
{
    public static var instance(get, never) : FrameUpdater;

    private static var _instance : FrameUpdater;
    
    /**
		 * This is a singleton instance. There's no requirement to use this singleton -
		 * the constructor isn't private (or in any other way restricted) and nothing
		 * will go wrong if you create multiple instances of the class. The singleton
		 * instance is provided for speed and memory optimization - it is usually 
		 * possible for all code to use the same instance and this singleton makes it
		 * easy for code to do this by all code using this singleton instance.
		 */
    private static function get_Instance() : FrameUpdater
    {
        if (_instance == null) 
        {
            _instance = new FrameUpdater();
        }
        return _instance;
    }
    
    private var _shape : Shape;
    private var _time : Float;
    private var _running : Bool = false;
    
    /**
		 * The constructor creates an EmitterUpdater object.
		 */
    public function new()
    {
        super();
        _shape = new Shape();
    }
    
    private function startTimer() : Void
    {
        _shape.addEventListener(Event.ENTER_FRAME, frameUpdate, false, 0, true);
        _time = Math.round(haxe.Timer.stamp() * 1000);
        _running = true;
    }
    
    private function stopTimer() : Void
    {
        _shape.removeEventListener(Event.ENTER_FRAME, frameUpdate);
        _running = false;
    }
    
    private function frameUpdate(ev : Event) : Void
    {
        var oldTime : Int = _time;
        _time = Math.round(haxe.Timer.stamp() * 1000);
        var frameTime : Float = (_time - oldTime) * 0.001;
        dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE, frameTime));
    }
    
    override public function addEventListener(type : String, listener : Function,
            useCapture : Bool = false, priority : Int = 0, weakReference : Bool = false) : Void
    {
        super.addEventListener(type, listener, useCapture, priority, weakReference);
        if (!_running && hasEventListener(UpdateEvent.UPDATE)) 
        {
            startTimer();
        }
    }
    
    override public function removeEventListener(type : String, listener : Function, useCapture : Bool = false) : Void
    {
        super.removeEventListener(type, listener, useCapture);
        if (_running && !hasEventListener(UpdateEvent.UPDATE)) 
        {
            stopTimer();
        }
    }
}

