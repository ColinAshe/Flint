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

package org.flintparticles.twod.emitters;


import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.particles.ParticleFactory;
import org.flintparticles.common.utils.Maths;
import org.flintparticles.twod.particles.Particle2D;
import org.flintparticles.twod.particles.ParticleCreator2D;

/**
	 * The Emitter class manages the creation and ongoing state of particles. It uses a number of
	 * utility classes to customise its behaviour.
	 * 
	 * <p>An emitter uses Initializers to customise the initial state of particles
	 * that it creates, their position, velocity, color etc. These are added to the 
	 * emitter using the addInitializer  method.</p>
	 * 
	 * <p>An emitter uses Actions to customise the behaviour of particles that
	 * it creates, to apply gravity, drag, fade etc. These are added to the emitter 
	 * using the addAction method.</p>
	 * 
	 * <p>An emitter uses Activities to customise its own behaviour in an ongoing manner, to 
	 * make it move or rotate.</p>
	 * 
	 * <p>An emitter uses a Counter to know when and how many particles to emit.</p>
	 * 
	 * <p>An emitter uses a Renderer to display the particles on screen.</p>
	 * 
	 * <p>All timings in the emitter are based on actual time passed, not on frames.</p>
	 * 
	 * <p>Most functionality is best added to an emitter using Actions,
	 * Initializers, Activities, Counters and Renderers. This offers greater 
	 * flexibility to combine behaviours witout needing to subclass 
	 * the Emitter itself.</p>
	 * 
	 * <p>The emitter also has position properties - x, y, rotation - that can be used to directly
	 * affect its location in the particle system.</p>
	 */

class Emitter2D extends Emitter
{
    public static var defaultParticleFactory(get, never) : ParticleFactory;
    public var x(get, set) : Float;
    public var y(get, set) : Float;
    public var rotation(get, set) : Float;
    public var rotRadians(get, set) : Float;

    /**
		 * @private
		 * 
		 * default factory to manage the creation, reuse and destruction of particles
		 */
    private static var _creator : ParticleCreator2D = new ParticleCreator2D();
    
    /**
		 * The default particle factory used to manage the creation, reuse and destruction of particles.
		 */
    private static function get_DefaultParticleFactory() : ParticleFactory
    {
        return _creator;
    }
    
    /**
		 * @private
		 */
    private var _x : Float = 0;
    /**
		 * @private
		 */
    private var _y : Float = 0;
    /**
		 * @private
		 */
    private var _rotation : Float = 0;  // N.B. Is in radians  
    
    /**
		 * Identifies whether the particles should be arranged
		 * into spacially sorted arrays - this speeds up proximity
		 * testing for those actions that need it.
		 */
    public var spaceSort : Bool = false;
    
    /**
		 * The constructor creates an emitter.
		 */
    public function new()
    {
        super();
        _particleFactory = _creator;
    }
    
    /**
		 * Indicates the x coordinate of the Emitter within the particle system's coordinate space.
		 */
    private function get_X() : Float
    {
        return _x;
    }
    private function set_X(value : Float) : Float
    {
        _x = value;
        return value;
    }
    /**
		 * Indicates the y coordinate of the Emitter within the particle system's coordinate space.
		 */
    private function get_Y() : Float
    {
        return _y;
    }
    private function set_Y(value : Float) : Float
    {
        _y = value;
        return value;
    }
    /**
		 * Indicates the rotation of the Emitter, in degrees, within the particle system's coordinate space.
		 */
    private function get_Rotation() : Float
    {
        return Maths.asDegrees(_rotation);
    }
    private function set_Rotation(value : Float) : Float
    {
        _rotation = Maths.asRadians(value);
        return value;
    }
    /**
		 * Indicates the rotation of the Emitter, in radians, within the particle system's coordinate space.
		 */
    private function get_RotRadians() : Float
    {
        return _rotation;
    }
    private function set_RotRadians(value : Float) : Float
    {
        _rotation = value;
        return value;
    }
    
    /**
		 * Used internally to initialise the position and rotation of a particle relative to the emitter.
		 */
    override private function initParticle(particle : Particle) : Void
    {
        var p : Particle2D = cast((particle), Particle2D);
        p.x = _x;
        p.y = _y;
        p.previousX = _x;
        p.previousY = _y;
        p.rotation = _rotation;
    }
    
    /**
		 * Used internally and in derived classes to update the emitter.
		 * @param time The duration, in seconds, of the current frame.
		 */
    override private function sortParticles() : Void
    {
        if (spaceSort) 
        {
            _particles.sortOn("x", Array.NUMERIC);
            var len : Int = _particles.length;
            for (i in 0...len){
                cast((_particles[i]), Particle2D).sortID = i;
            }
        }
    }
}
