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

package org.flintparticles.common.initializers;


import org.flintparticles.common.events.ParticleEvent;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;

/**
	 * The MouseEventHandlers Initializer sets event handlers to listen for the mouseOver and mouseOut events on each 
	 * particle. To use this initializer, you must use a DisplayObjectRenderer, use an InteractiveObject as the image
	 * for each particle, and set the mouseChildren property of the renderer to true.
	 */

class MouseEventHandlers extends InitializerBase
{
    public var overHandler(get, set) : Function;
    public var outHandler(get, set) : Function;
    public var upHandler(get, set) : Function;
    public var downHandler(get, set) : Function;
    public var clickHandler(get, set) : Function;

    private var _overHandler : Function;
    private var _outHandler : Function;
    private var _upHandler : Function;
    private var _downHandler : Function;
    private var _clickHandler : Function;
    
    /**
		 * The constructor creates a MouseEventHandlers initializer for use by 
		 * an emitter. To add a MouseEventHandlers to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
    public function new()
    {
        super();
        
    }
    
    /**
		 * The mouseOver event handler.
		 */
    private function get_OverHandler() : Function
    {
        return _overHandler;
    }
    private function set_OverHandler(value : Function) : Function
    {
        _overHandler = value;
        return value;
    }
    
    /**
		 * The mouseOut event handler.
		 */
    private function get_OutHandler() : Function
    {
        return _outHandler;
    }
    private function set_OutHandler(value : Function) : Function
    {
        _outHandler = value;
        return value;
    }
    
    /**
		 * The mouseUp event handler.
		 */
    private function get_UpHandler() : Function
    {
        return _upHandler;
    }
    private function set_UpHandler(value : Function) : Function
    {
        _upHandler = value;
        return value;
    }
    
    /**
		 * The mouseDown event handler.
		 */
    private function get_DownHandler() : Function
    {
        return _downHandler;
    }
    private function set_DownHandler(value : Function) : Function
    {
        _downHandler = value;
        return value;
    }
    
    /**
		 * The mouseClick event handler.
		 */
    private function get_ClickHandler() : Function
    {
        return _clickHandler;
    }
    private function set_ClickHandler(value : Function) : Function
    {
        _clickHandler = value;
        return value;
    }
    
    /**
		 * Listens for particles to die and removes the mouse event listeners from them when this occurs.
		 */
    override public function addedToEmitter(emitter : Emitter) : Void
    {
        emitter.addEventListener(ParticleEvent.PARTICLE_DEAD, removeListeners, false, 0, true);
    }
    
    /**
		 * Stops listening for particles to die.
		 */
    override public function removedFromEmitter(emitter : Emitter) : Void
    {
        emitter.removeEventListener(ParticleEvent.PARTICLE_DEAD, removeListeners);
    }
    
    private function removeListeners(event : ParticleEvent) : Void
    {
        if (Std.is(event.particle.image, IEventDispatcher)) 
        {
            var dispatcher : IEventDispatcher = cast((event.particle.image), IEventDispatcher);
            if (_overHandler != null) 
            {
                dispatcher.removeEventListener(MouseEvent.MOUSE_OVER, _overHandler);
            }
            if (_outHandler != null) 
            {
                dispatcher.removeEventListener(MouseEvent.MOUSE_OVER, _outHandler);
            }
            if (_upHandler != null) 
            {
                dispatcher.removeEventListener(MouseEvent.MOUSE_OVER, _upHandler);
            }
            if (_downHandler != null) 
            {
                dispatcher.removeEventListener(MouseEvent.MOUSE_OVER, _downHandler);
            }
            if (_clickHandler != null) 
            {
                dispatcher.removeEventListener(MouseEvent.MOUSE_OVER, _clickHandler);
            }
        }
    }
    
    /**
		 * @inheritDoc
		 */
    override public function initialize(emitter : Emitter, particle : Particle) : Void
    {
        if (Std.is(particle.image, IEventDispatcher)) 
        {
            var dispatcher : IEventDispatcher = cast((particle.image), IEventDispatcher);
            if (_overHandler != null) 
            {
                dispatcher.addEventListener(MouseEvent.MOUSE_OVER, _overHandler, false, 0, true);
            }
            if (_outHandler != null) 
            {
                dispatcher.addEventListener(MouseEvent.MOUSE_OVER, _outHandler, false, 0, true);
            }
            if (_upHandler != null) 
            {
                dispatcher.addEventListener(MouseEvent.MOUSE_OVER, _upHandler, false, 0, true);
            }
            if (_downHandler != null) 
            {
                dispatcher.addEventListener(MouseEvent.MOUSE_OVER, _downHandler, false, 0, true);
            }
            if (_clickHandler != null) 
            {
                dispatcher.addEventListener(MouseEvent.MOUSE_OVER, _clickHandler, false, 0, true);
            }
        }
    }
}

