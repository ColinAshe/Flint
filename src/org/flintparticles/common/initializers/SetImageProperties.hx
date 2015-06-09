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

import nme.errors.Error;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;

/**
	 * The SetImageProperties Initializer can be used to set any properties of a particle's
	 * image object. This Initializer has a single property that is any object whose properties
	 * should be copied to the image object.
	 * 
	 * This Initializer has a priority of -10 so that it runs after the image setting Initializers,
	 * which have a priority of zero.
	 */

class SetImageProperties extends InitializerBase
{
    public var properties(get, set) : Dynamic;

    private var _properties : Dynamic;
    
    /**
		 * The constructor creates a SetImageProperties initializer for use by 
		 * an emitter. To apply a SetImageProperties to all particles created by an emitter,
		 * use the emitter's addInitializer method.
		 * 
		 * @param properties An object or dictionary containing the properties to set on the 
		 * particle's image object. The name of the properties on this object must match the
		 * names of the properties on the particle's image object.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
    public function new(properties : Dynamic)
    {
        super();
        _priority = -10;
        _properties = properties;
    }
    
    /**
		 * An object or dictionary containing the properties to set on the particle's image 
		 * object. The name of the properties on this object must match the names of the 
		 * properties on the particle's image object.
		 */
    private function get_Properties() : Dynamic
    {
        return _properties;
    }
    private function set_Properties(value : Dynamic) : Dynamic
    {
        _properties = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    override public function initialize(emitter : Emitter, particle : Particle) : Void
    {
        if (!particle.image) 
        {
            throw new Error("Attempting to set image properties when no image is set");
        }
        var img : Dynamic = particle.image;
        for (name in Reflect.fields(_properties))
        {
            if (img.exists(name)) 
            {
                Reflect.setField(img, name, Reflect.field(_properties, name));
            }
        }
    }
}

