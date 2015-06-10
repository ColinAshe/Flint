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

package org.flintparticles.integration.away3d.v3;


import away3d.sprites.Sprite3D;
import away3d.containers.ObjectContainer3D;
import away3d.core.base.Mesh;
import away3d.core.base.Object3D;
import away3d.core.math.Vector3DUtils;
import away3d.sprites.MovieClipSprite;

import openfl.geom.Vector3D;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.renderers.RendererBase;
import org.flintparticles.common.utils.Maths;
import org.flintparticles.integration.away3d.v3.utils.Convert;
import org.flintparticles.threed.particles.Particle3D;

/**
	 * Renders the particles in an Away3D scene.
	 * 
	 * <p>To use this renderer, the particles' image properties should be 
	 * Away3D objects, renderable in an Away3D scene. This renderer
	 * doesn't update the scene, but copies each particle's properties
	 * to its image object so next time the Away3D scene is rendered the 
	 * image objects are drawn according to the state of the particle
	 * system.</p>
	 */
class A3D3Renderer extends RendererBase
{
    private var _container : ObjectContainer3D;
    
    /**
		 * The constructor creates an Away3D renderer for displaying the
		 * particles in an Away3D scene.
		 * 
		 * @param container An Away3D object container. The particle display
		 * objects are created inside this object container. This is usually
		 * a scene object, but it may be any ObjectContainer3D.
		 */
    public function new(container : ObjectContainer3D)
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
        var o : Dynamic = particle.image;
        
        if (Std.is(o, Object3D)) {
            cast((o), Object3D).x = particle.position.x;
            cast((o), Object3D).y = particle.position.y;
            cast((o), Object3D).z = particle.position.z;
            cast((o), Object3D).scaleX = cast((o), Object3D).scaleY = cast((o), Object3D).scaleZ = particle.scale;
            
            var rotation : openfl.geom.Vector3D = away3d.core.math.Vector3DUtils.quaternion2euler(Convert.QuaternionToA3D(particle.rotation));
            cast((o), Object3D).rotationX = Maths.asDegrees(rotation.x);
            cast((o), Object3D).rotationY = Maths.asDegrees(rotation.y);
            cast((o), Object3D).rotationZ = Maths.asDegrees(rotation.z);
            
            // mesh rendering
            if (Std.is(o, Mesh)) 
            {
                if (cast((o), Mesh).material["hasOwnProperty"]("color")) 
                {
                    cast((o), Mesh).material["color"] = particle.color & 0xFFFFFF;
                }
                if (cast((o), Mesh).material["hasOwnProperty"]("alpha")) 
                {
                    cast((o), Mesh).material["alpha"] = particle.alpha;
                }
            }
            else 
            {
                // can't do color transform
                // will try alpha - only works if objects have own canvas
                cast((o), Object3D).alpha = particle.alpha;
            }
        }
        // display object rendering
        // others
        else if (Std.is(o, Sprite3D)) 
        {
            cast((o), Sprite3D).x = particle.position.x;
            cast((o), Sprite3D).y = particle.position.y;
            cast((o), Sprite3D).z = particle.position.z;
            cast((o), Sprite3D).scaling = particle.scale;
            
            if (Std.is(o, MovieClipSprite)) 
            {
                cast((o), MovieClipSprite).movieClip.transform.colorTransform = particle.colorTransform;
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
        if (Std.is(particle.image, Object3D)) 
        {
            _container.addChild(cast((particle.image), Object3D));
            renderParticle(cast((particle), Particle3D));
        }
        else if (Std.is(particle.image, Sprite3D)) 
        {
            _container.addSprite(cast((particle.image), Sprite3D));
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
        if (Std.is(particle.image, Object3D)) 
        {
            _container.removeChild(cast((particle.image), Object3D));
        }
        else if (Std.is(particle.image, Sprite3D)) 
        {
            _container.removeSprite(cast((particle.image), Sprite3D));
        }
    }
}

