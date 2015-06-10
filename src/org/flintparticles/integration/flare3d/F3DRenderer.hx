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

package org.flintparticles.integration.flare3d;


import flare.core.Mesh3D;
import flare.core.Pivot3D;
import flare.core.Surface3D;
import flare.materials.Material3D;
import flare.materials.Shader3D;
import flare.materials.flsl.FLSLFilter;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.renderers.RendererBase;
import org.flintparticles.common.utils.Maths;
import org.flintparticles.integration.flare3d.utils.Convert;
import org.flintparticles.threed.particles.Particle3D;
import openfl.geom.Vector3D;

/**
	 * @author Richard
	 */
class F3DRenderer extends RendererBase
{
    private var _container : Pivot3D;
    
    public function new(container : Pivot3D)
    {
        super();
        _container = container;
    }
    
    /**
		 * This method copies the particle's state to the associated image object.
		 * 
		 * <p>This method is called internally by Flint and shouldn't need to be 
		 * called by the user.</p>
		 * 
		 * @param particles The particles to be rendered.
		 */
    override private function renderParticles(particles : Array<Dynamic>) : Void
    {
        for (p in particles)
        {
            renderParticle(p);
        }
    }
    
    private function renderParticle(particle : Particle3D) : Void
    {
        if (Std.is(particle.image, Pivot3D)) 
        {
            var obj : Pivot3D = try cast(particle.image, Pivot3D) catch(e:Dynamic) null;
            
            obj.setPosition(particle.position.x, particle.position.y, particle.position.z);
            obj.setScale(particle.scale, particle.scale, particle.scale);
            
            var rotation : Vector3D = Convert.quaternion2euler(particle.rotation);
            obj.setRotation(Maths.asDegrees(rotation.x), Maths.asDegrees(rotation.y), Maths.asDegrees(rotation.z));
            
            if (Std.is(obj, Mesh3D)) 
            {
                var mesh : Mesh3D = try cast(obj, Mesh3D) catch(e:Dynamic) null;
                for (surface/* AS3HX WARNING could not determine type for var: surface exp: EField(EIdent(mesh),surfaces) type: null */ in mesh.surfaces)
                {
                    var material : Material3D = surface.material;
                    if (Std.is(material, Shader3D)) 
                    {
                        var shader : Shader3D = try cast(material, Shader3D) catch(e:Dynamic) null;
                        for (filter/* AS3HX WARNING could not determine type for var: filter exp: EField(EIdent(shader),filters) type: null */ in shader.filters)
                        {
                            if (filter.exists("color")) 
                            {
                                filter["color"] = particle.color;
                            }
                            if (filter.exists("alpha")) 
                            {
                                filter["alpha"] = Std.parseFloat((particle.color >>> 24) & 255) / 255;
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
		 * This method is called when a particle is added to an emitter -
		 * usually because the emitter has just created the particle. The
		 * method adds the particle's image to the container's display list.
		 * It is called internally by Flint and need not be called by the user.
		 * 
		 * @param particle The particle being added to the emitter.
		 */
    override private function addParticle(particle : Particle) : Void
    {
        if (Std.is(particle.image, Pivot3D)) 
        {
            _container.addChild(cast((particle.image), Pivot3D));
            renderParticle(cast((particle), Particle3D));
        }
    }
    
    /**
		 * This method is called when a particle is removed from an emitter -
		 * usually because the particle is dying. The method removes the 
		 * particle's image from the container's display list. It is called 
		 * internally by Flint and need not be called by the user.
		 * 
		 * @param particle The particle being removed from the emitter.
		 */
    override private function removeParticle(particle : Particle) : Void
    {
        if (Std.is(particle.image, Pivot3D)) 
        {
            _container.removeChild(cast((particle.image), Pivot3D));
        }
    }
}

