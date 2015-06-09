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

package org.flintparticles.integration.papervision3d.initializers;


import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.utils.Construct;

/**
	 * The ApplyMaterial initializer sets a material to apply to the Papervision3D
	 * object that is used when rendering the particle. To use this initializer,
	 * the particle's image object must be an Papervision3D object with a material
	 * property.
	 * 
	 * <p>This initializer has a priority of -10 to ensure that it is applied after 
	 * the ImageInit classes which define the image object.</p>
	 */
class PV3DApplyMaterial extends InitializerBase
{
    public var materialClass(get, set) : Class<Dynamic>;
    public var parameters(get, set) : Array<Dynamic>;

    private var _materialClass : Class<Dynamic>;
    private var _parameters : Array<Dynamic>;
    
    /**
		 * The constructor creates an ApplyMaterial initializer for use by 
		 * an emitter. To add an ApplyMaterial to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param materialClass The class to use when creating
		 * the particles' material.
		 * @param parameters The parameters to pass to the constructor
		 * for the material class.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
    public function new(materialClass : Class<Dynamic>)
    {
        super();
        priority = -10;
        _materialClass = materialClass;
        _parameters = parameters;
    }
    
    /**
		 * The class to use when creating the particles' material.
		 */
    private function get_MaterialClass() : Class<Dynamic>
    {
        return _materialClass;
    }
    private function set_MaterialClass(value : Class<Dynamic>) : Class<Dynamic>
    {
        _materialClass = value;
        return value;
    }
    
    /**
		 * The parameters to pass to the constructor
		 * for the material class.
		 */
    private function get_Parameters() : Array<Dynamic>
    {
        return _parameters;
    }
    private function set_Parameters(value : Array<Dynamic>) : Array<Dynamic>
    {
        _parameters = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    override public function initialize(emitter : Emitter, particle : Particle) : Void
    {
        if (particle.image && particle.image["hasOwnProperty"]("material")) 
        {
            particle.image["material"] = construct(_materialClass, _parameters);
        }
    }
}

