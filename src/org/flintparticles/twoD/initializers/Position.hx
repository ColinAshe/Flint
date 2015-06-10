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

package org.flintparticles.twod.initializers;


import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.twod.particles.Particle2D;
import org.flintparticles.twod.zones.Zone2D;

import openfl.geom.Point;

@:meta(DefaultProperty(name="zone"))


/**
	 * The Position Initializer sets the initial location of the particle.
	 * 
	 * <p>The class uses zones to place the particle. A zone defines a region
	 * in relation to the emitter and the particle is placed at a random point within
	 * that region. For precise placement, the Point zone defines a single
	 * point at which all particles will be placed. Various zones (and the
	 * Zones interface for use when implementing custom zones) are defined
	 * in the org.flintparticles.twoD.zones package.</p>
	 */
class Position extends InitializerBase
{
    public var zone(get, set) : Zone2D;

    private var _zone : Zone2D;
    
    /**
		 * The constructor creates a Position initializer for use by 
		 * an emitter. To add a Position to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param zone The zone to place all particles in.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
    public function new(zone : Zone2D = null)
    {
        super();
        this.zone = zone;
    }
    
    /**
		 * The zone.
		 */
    private function get_Zone() : Zone2D
    {
        return _zone;
    }
    private function set_Zone(value : Zone2D) : Zone2D
    {
        _zone = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    override public function initialize(emitter : Emitter, particle : Particle) : Void
    {
        var p : Particle2D = cast((particle), Particle2D);
        var loc : Point = _zone.getLocation();
        if (p.rotation == 0) 
        {
            p.x += loc.x;
            p.y += loc.y;
        }
        else 
        {
            var sin : Float = Math.sin(p.rotation);
            var cos : Float = Math.cos(p.rotation);
            p.x += cos * loc.x - sin * loc.y;
            p.y += cos * loc.y + sin * loc.x;
        }
        p.previousX = p.x;
        p.previousY = p.y;
    }
}

