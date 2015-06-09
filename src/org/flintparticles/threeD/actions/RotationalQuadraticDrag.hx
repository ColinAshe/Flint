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

package org.flintparticles.threed.actions;


import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.threed.particles.Particle3D;

import flash.geom.Vector3D;

/**
	 * The RotationalQuadraticDrag action applies drag to the particle to slow it 
	 * down when it's rotating. The drag force is proportional to the square of the 
	 * angular velocity of the particle.
	 */

class RotationalQuadraticDrag extends ActionBase
{
    public var drag(get, set) : Float;

    private var _drag : Float;
    
    /**
		 * The constructor creates a RotationalQuadraticDrag action for use by 
		 * an emitter. To add a RotationalQuadraticDrag to all particles created 
		 * by an emitter, use the emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param drag The amount of drag. A higher number produces a stronger drag force.
		 */
    public function new(drag : Float = 0)
    {
        super();
        this.drag = drag;
    }
    
    /**
		 * The amount of drag. A higher number produces a stronger drag force.
		 */
    private function get_Drag() : Float
    {
        return _drag;
    }
    private function set_Drag(value : Float) : Float
    {
        _drag = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    override public function update(emitter : Emitter, particle : Particle, time : Float) : Void
    {
        var v : Vector3D = cast((particle), Particle3D).angVelocity;
        if (v.x == 0 && v.y == 0 && v.z == 0) 
        {
            return;
        }
        var scale : Float = 1 - _drag * time * v.length / cast((particle), Particle3D).inertia;
        if (scale < 0) 
        {
            v.x = 0;
            v.y = 0;
            v.z = 0;
        }
        else 
        {
            v.scaleBy(scale);
        }
    }
}

