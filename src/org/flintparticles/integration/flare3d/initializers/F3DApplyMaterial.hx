/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord & Michael Ivanov
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

package org.flintparticles.integration.flare3d.initializers;


import flare.core.Pivot3D;
import flare.materials.Material3D;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.common.particles.Particle;

/**
	 * The F3DApplyMaterial initializer sets a material to apply to the Flare3D
	 * object that is used when rendering the particle. To use this initializer,
	 * the particle's image object must be a Flare3D Pivot3D object.
	 * 
	 * <p>This initializer has a priority of -10 to ensure that it is applied after 
	 * the ImageInit classes which define the image object.</p>
	 */
class F3DApplyMaterial extends InitializerBase
{
    public var material(get, set) : Material3D;

    private var _material : Material3D;
    
    /**
		 * The constructor creates an F3DApplyMaterial initializer for use by 
		 * an emitter. To add an F3DApplyMaterial to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param material The material to use for the particle.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
    public function new(material : Material3D)
    {
        super();
        priority = -10;
        _material = material;
    }
    
    /**
		 * The material to use for the particle.
		 */
    private function get_Material() : Material3D
    {
        return _material;
    }
    private function set_Material(value : Material3D) : Material3D
    {
        _material = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    override public function initialize(emitter : Emitter, particle : Particle) : Void
    {
        if (particle.image && Std.is(particle.image, Pivot3D)) 
        {
            cast((particle.image), Pivot3D).setMaterial(_material);
        }
    }
}

