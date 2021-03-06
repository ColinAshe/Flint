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
import org.flintparticles.threed.geom.Vector3DUtils;
import org.flintparticles.threed.particles.Particle3D;

import openfl.geom.Vector3D;

/**
	 * The TargetVelocity action adjusts the velocity of the particle towards the target velocity.
	 */
class TargetVelocity extends ActionBase
{
    public var targetVelocity(get, set) : Vector3D;
    public var rate(get, set) : Float;
    public var x(get, set) : Float;
    public var y(get, set) : Float;
    public var z(get, set) : Float;

    private var _vel : Vector3D;
    private var _rate : Float;
    
    /**
		 * The constructor creates a TargetVelocity action for use by 
		 * an emitter. To add a TargetVelocity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param velX The x coordinate of the target velocity, in pixels per second.
		 * @param velY The y coordinate of the target velocity, in pixels per second.
		 * @param rate Adjusts how quickly the particle reaches the target velocity.
		 * Larger numbers cause it to approach the target velocity more quickly.
		 */
    public function new(targetVelocity : Vector3D = null, rate : Float = 0.1)
    {
        super();
        this.targetVelocity = (targetVelocity != null) ? targetVelocity : new Vector3D();
        this.rate = rate;
    }
    
    /**
		 * The x coordinate of the target velocity, in pixels per second.s
		 */
    private function get_TargetVelocity() : Vector3D
    {
        return _vel;
    }
    private function set_TargetVelocity(value : Vector3D) : Vector3D
    {
        _vel = Vector3DUtils.cloneVector(value);
        return value;
    }
    
    /**
		 * Adjusts how quickly the particle reaches the target angular velocity.
		 * Larger numbers cause it to approach the target angular velocity more quickly.
		 */
    private function get_Rate() : Float
    {
        return _rate;
    }
    private function set_Rate(value : Float) : Float
    {
        _rate = value;
        return value;
    }
    
    /**
		 * The x coordinate of the target velocity.
		 */
    private function get_X() : Float
    {
        return _vel.x;
    }
    private function set_X(value : Float) : Float
    {
        _vel.x = value;
        return value;
    }
    
    /**
		 * The y coordinate of  the target velocity.
		 */
    private function get_Y() : Float
    {
        return _vel.y;
    }
    private function set_Y(value : Float) : Float
    {
        _vel.y = value;
        return value;
    }
    
    /**
		 * The z coordinate of the target velocity.
		 */
    private function get_Z() : Float
    {
        return _vel.z;
    }
    private function set_Z(value : Float) : Float
    {
        _vel.z = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    override public function update(emitter : Emitter, particle : Particle, time : Float) : Void
    {
        var v : Vector3D = cast((particle), Particle3D).velocity;
        var c : Float = _rate * time;
        v.x += (_vel.x - v.x) * c;
        v.y += (_vel.y - v.y) * c;
        v.z += (_vel.z - v.z) * c;
    }
}

