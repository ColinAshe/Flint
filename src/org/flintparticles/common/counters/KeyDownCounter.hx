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

package org.flintparticles.common.counters;


import org.flintparticles.common.emitters.Emitter;

import openfl.display.Stage;
import openfl.events.KeyboardEvent;

/**
	 * The KeyDownCounter Counter modifies another counter to only emit particles when a specific key
	 * is being pressed.
	 */
class KeyDownCounter implements Counter
{
    public var counter(get, set) : Counter;
    public var keyCode(get, set) : Int;
    public var stage(get, set) : Stage;
    public var complete(get, never) : Bool;
    public var running(get, never) : Bool;

    private var _counter : Counter;
    private var _keyCode : Int;
    private var _isDown : Bool;
    private var _stop : Bool;
    private var _stage : Stage;
    
    /**
		 * The constructor creates a ZonedAction action for use by 
		 * an emitter. To add a ZonedAction to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param counter The counter to use when the key is down.
		 * @param keyCode The key code of the key that controls the counter.
		 * @param stage A reference to the stage.
		 */
    public function new(counter : Counter = null, keyCode : Int = 0, stage : Stage = null)
    {
        _stop = false;
        _counter = counter;
        _keyCode = keyCode;
        _isDown = false;
        _stage = stage;
        createListeners();
    }
    
    private function createListeners() : Void
    {
        if (stage != null) 
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener, false, 0, true);
        }
    }
    
    private function keyDownListener(ev : KeyboardEvent) : Void
    {
        if (ev.keyCode == _keyCode) 
        {
            _isDown = true;
        }
    }
    private function keyUpListener(ev : KeyboardEvent) : Void
    {
        if (ev.keyCode == _keyCode) 
        {
            _isDown = false;
        }
    }
    
    /**
		 * The counter to use when the key is down.
		 */
    private function get_Counter() : Counter
    {
        return _counter;
    }
    private function set_Counter(value : Counter) : Counter
    {
        _counter = value;
        return value;
    }
    
    /**
		 * The key code of the key that controls the counter.
		 */
    private function get_KeyCode() : Int
    {
        return _keyCode;
    }
    private function set_KeyCode(value : Int) : Int
    {
        _keyCode = value;
        return value;
    }
    
    /**
		 * A reference to the stage
		 */
    private function get_Stage() : Stage
    {
        return _stage;
    }
    private function set_Stage(value : Stage) : Stage
    {
        _stage = value;
        createListeners();
        return value;
    }
    
    public function startEmitter(emitter : Emitter) : Int
    {
        if (_isDown && !_stop) 
        {
            return _counter.startEmitter(emitter);
        }
        _counter.startEmitter(emitter);
        return 0;
    }
    
    /**
		 * @inheritDoc
		 */
    public function updateEmitter(emitter : Emitter, time : Float) : Int
    {
        if (_isDown && !_stop) 
        {
            return _counter.updateEmitter(emitter, time);
        }
        return 0;
    }
    
    /**
		 * Stops the emitter from emitting particles
		 */
    public function stop() : Void
    {
        _stop = true;
    }
    
    /**
		 * Resumes the emitter after a stop
		 */
    public function resume() : Void
    {
        _stop = false;
    }
    
    
    /**
		 * Indicates if the counter has emitted all its particles.
		 */
    private function get_Complete() : Bool
    {
        return _counter.complete;
    }
    
    /**
		 * Indicates if the counter is currently emitting particles
		 */
    private function get_Running() : Bool
    {
        return _counter.running;
    }
}
