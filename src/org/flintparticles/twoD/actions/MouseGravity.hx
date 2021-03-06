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

package org.flintparticles.twod.actions;


import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.twod.particles.Particle2D;

import openfl.display.DisplayObject;

/**
	 * The MouseGravity action applies a force on the particle to draw it towards
	 * the mouse. The force applied is inversely proportional to the square
	 * of the distance from the particle to the mouse, in accordance with Newton's
	 * law of gravity.
	 */

class MouseGravity extends ActionBase
{
    public var power(get, set) : Float;
    public var renderer(get, set) : DisplayObject;
    public var epsilon(get, set) : Float;

    private var _power : Float;
    private var _epsilonSq : Float;
    private var _gravityConst : Float = 10000;  // scales the power to more useable levels  
    private var _renderer : DisplayObject;
    
    /**
		 * The constructor creates a MouseGravity action for use by an emitter.
		 * To add a MouseGravity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the gravity force - larger numbers produce a 
		 * stronger force.
		 * @param renderer The display object whose coordinate system the mouse 
		 * position is converted to. This is usually the renderer for the particle 
		 * system created by the emitter.
		 * @param epsilon The minimum distance for which gravity is calculated. 
		 * Particles closer than this distance experience a gravity force as if 
		 * they were this distance away. This stops the gravity effect blowing up 
		 * as distances get small. For realistic gravity effects you will want a 
		 * small epsilon ( ~1 ), but for stable visual effects a larger epsilon 
		 * (~100) is often better.
		 */
    public function new(power : Float = 0, renderer : DisplayObject = null, epsilon : Float = 100)
    {
        super();
        this.power = power;
        this.epsilon = epsilon;
        this.renderer = renderer;
    }
    
    /**
		 * The strength of the gravity force.
		 */
    private function get_Power() : Float
    {
        return _power / _gravityConst;
    }
    private function set_Power(value : Float) : Float
    {
        _power = value * _gravityConst;
        return value;
    }
    
    /**
		 * The display object whose coordinate system the mouse position is 
		 * converted to. This is usually the renderer for the particle system 
		 * created by the emitter.
		 */
    private function get_Renderer() : DisplayObject
    {
        return _renderer;
    }
    private function set_Renderer(value : DisplayObject) : DisplayObject
    {
        _renderer = value;
        return value;
    }
    
    /**
		 * The minimum distance for which the gravity force is calculated. 
		 * Particles closer than this distance experience the gravity as it they were 
		 * this distance away. This stops the gravity effect blowing up as distances get 
		 * small.
		 */
    private function get_Epsilon() : Float
    {
        return Math.sqrt(_epsilonSq);
    }
    private function set_Epsilon(value : Float) : Float
    {
        _epsilonSq = value * value;
        return value;
    }
    
    /**
		 * Calculates the gravity force on the particle and applies it for the
		 * period of time indicated.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user.</p>
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame - used for time based updates.
		 * 
		 * @see org.flintparticles.common.actions.Action#update()
		 */
    override public function update(emitter : Emitter, particle : Particle, time : Float) : Void
    {
        var p : Particle2D = cast((particle), Particle2D);
        var x : Float = _renderer.mouseX - p.x;
        var y : Float = _renderer.mouseY - p.y;
        var dSq : Float = x * x + y * y;
        if (dSq == 0) 
        {
            return;
        }
        var d : Float = Math.sqrt(dSq);
        if (dSq < _epsilonSq)             dSq = _epsilonSq;
        var factor : Float = (_power * time) / (dSq * d);
        p.velX += x * factor;
        p.velY += y * factor;
    }
}

