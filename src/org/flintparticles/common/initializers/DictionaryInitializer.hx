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

import org.flintparticles.common.initializers.InitializerBase;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;

/**
	 * The Dictionary Initializer copies properties from an initializing object to a particle's dictionary.
	 */
class DictionaryInitializer extends InitializerBase
{
    public var initValues(get, set) : Dynamic;

    private var _initValues : Dynamic;
    
    /**
		 * The constructor creates a DictionaryInit initializer for use by 
		 * an emitter. To add a DictionaryInit to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param initValues The object containing the properties for copying to the particle's dictionary.
		 * May be an object or a dictionary.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
    public function new(initValues : Dynamic)
    {
        super();
        _initValues = initValues;
    }
    
    /**
		 * The object containing the properties for copying to the particle's dictionary.
		 * May be an object or a dictionary.
		 */
    private function get_InitValues() : Dynamic
    {
        return _initValues;
    }
    private function set_InitValues(value : Dynamic) : Dynamic
    {
        _initValues = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    override public function initialize(emitter : Emitter, particle : Particle) : Void
    {
        if (_initValues == null) 
        {
            return;
        }
        for (key in Reflect.fields(_initValues))
        {
            particle.dictionary[key] = Reflect.field(_initValues, key);
        }
    }
}

