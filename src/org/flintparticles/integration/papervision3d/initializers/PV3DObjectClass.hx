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
	 * The PV3DObjectClass initializer sets the 3D Object to use to 
	 * draw the particle in a 3D scene. It is used with the Papervision3D renderer when
	 * particles should be represented by a 3D object.
	 */

class PV3DObjectClass extends InitializerBase
{
    public var imageClass(get, set) : Class<Dynamic>;
    public var parameters(get, set) : Array<Dynamic>;

    private var _imageClass : Class<Dynamic>;
    private var _parameters : Array<Dynamic>;
    
    /**
		 * The constructor creates an PV3DObjectClass initializer for use by 
		 * an emitter. To add an ImageClass to all particles created by an emitter, 
		 * use the emitter's addInitializer method.
		 * 
		 * @param imageClass The class to use when creating
		 * the particles' image object.
		 * @param parameters The parameters to pass to the constructor
		 * for the image class.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
    public function new(imageClass : Class<Dynamic>)
    {
        super();
        _imageClass = imageClass;
        _parameters = parameters;
    }
    
    /**
		 * The class to use when creating
		 * the particles' DisplayObjects.
		 */
    private function get_ImageClass() : Class<Dynamic>
    {
        return _imageClass;
    }
    private function set_ImageClass(value : Class<Dynamic>) : Class<Dynamic>
    {
        _imageClass = value;
        return value;
    }
    
    /**
		 * The parameters to pass to the constructor
		 * for the image class.
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
        particle.image = construct(_imageClass, _parameters);
        if (particle.image["hasOwnProperty"]("size")) 
        {
            particle.dictionary["pv3dBaseSize"] = particle.image["size"];
        }
    }
}

