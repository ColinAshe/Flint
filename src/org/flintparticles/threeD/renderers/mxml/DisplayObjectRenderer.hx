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

package org.flintparticles.threed.renderers.mxml;


import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.renderers.FlexRendererBase;
import org.flintparticles.threed.geom.Quaternion;
import org.flintparticles.threed.particles.Particle3D;
import org.flintparticles.threed.renderers.Camera;

import openfl.display.DisplayObject;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;

/**
	 * The DisplayObjectRenderer is a native Flint 3D renderer that draws particles
	 * as display objects in the renderer. The particles are drawn face-on to the
	 * camera, with perspective applied to position and scale the particles.
	 * 
	 * <p>Particles may be represented by any DisplayObject and each particle 
	 * must use a different DisplayObject instance. The DisplayObject
	 * to be used should not be defined using the SharedImage initializer
	 * because this shares one DisplayObject instance between all the particles.
	 * The ImageClass initializer is commonly used because this creates a new 
	 * DisplayObject for each particle.</p>
	 * 
	 * <p>The DisplayObjectRenderer has mouse events disabled for itself and any 
	 * display objects in its display list. To enable mouse events for the renderer
	 * or its children set the mouseEnabled or mouseChildren properties to true.</p>
	 * 
	 * <p>Because the DisplayObject3DRenderer directly uses the particle's image,
	 * it is not suitable in situations where the same particle will be displayed 
	 * by two different renderers.</p> 
	 */
class DisplayObjectRenderer extends FlexRendererBase
{
    public var zSort(get, set) : Bool;
    public var camera(get, set) : Camera;

    /**
		 * @private
		 */
    private var _zSort : Bool;
    /**
		 * @private
		 */
    private var _camera : Camera;
    /**
		 * @private
		 */
    private var _halfWidth : Float = 0;
    /**
		 * @private
		 */
    private var _halfHeight : Float = 0;
    
    
    private var toDegrees : Float = 180 / Math.PI;
    
    /**
		 * The constructor creates a DisplayObject3DRenderer. After creation the
		 * renderer should be added to the display list of a DisplayObjectContainer 
		 * to place it on the stage.
		 * 
		 * <p>Emitter's should be added to the renderer using the renderer's
		 * addEmitter method. The renderer displays all the particles created
		 * by the emitter's that have been added to it.</p>
		 * 
		 * @param zSort Whether to sort the particles according to their
		 * z order when rendering them or not.
		 */
    public function new(zSort : Bool = true)
    {
        super();
        _zSort = zSort;
        _camera = new Camera();
    }
    
    /**
		 * Indicates whether the particles should be sorted in distance order for display.
		 */
    private function get_ZSort() : Bool
    {
        return _zSort;
    }
    private function set_ZSort(value : Bool) : Bool
    {
        _zSort = value;
        return value;
    }
    
    /**
		 * The camera controls the view for the renderer
		 */
    private function get_Camera() : Camera
    {
        return _camera;
    }
    private function set_Camera(value : Camera) : Camera
    {
        _camera = value;
        return value;
    }
    
    override private function set_Width(value : Float) : Float
    {
        super.width = value;
        _halfWidth = value * 0.5;
        return value;
    }
    override private function set_Height(value : Float) : Float
    {
        super.height = value;
        _halfHeight = value * 0.5;
        return value;
    }
    
    /**
		 * This method positions and scales the particles according to the
		 * particles' positions relative to the camera viewport.
		 * 
		 * <p>This method is called internally by Flint and shouldn't need to be called
		 * by the user.</p>
		 * 
		 * @param particles The particles to be rendered.
		 */
    override private function renderParticles(particles : Array<Dynamic>) : Void
    {
        var pos : Vector3D = new Vector3D();
        var rawCameraTransform : Array<Float> = _camera.transform.rawData;
        var particle : Particle3D;
        var img : DisplayObject;
        var len : Int = particles.length;
        var facing : Vector3D = new Vector3D();
        var f : Vector3D;
        for (i in 0...len){
            particle = cast((particles[i]), Particle3D);
            img = particle.image;
            
            var p : Vector3D = particle.position;
            // The following is very much more efficient than
            // pos = camera.transform.transformVector( particle.position );
            pos.x = rawCameraTransform[0] * p.x + rawCameraTransform[4] * p.y + rawCameraTransform[8] * p.z + rawCameraTransform[12] * p.w;
            pos.y = rawCameraTransform[1] * p.x + rawCameraTransform[5] * p.y + rawCameraTransform[9] * p.z + rawCameraTransform[13] * p.w;
            pos.z = rawCameraTransform[2] * p.x + rawCameraTransform[6] * p.y + rawCameraTransform[10] * p.z + rawCameraTransform[14] * p.w;
            pos.w = rawCameraTransform[3] * p.x + rawCameraTransform[7] * p.y + rawCameraTransform[11] * p.z + rawCameraTransform[15] * p.w;
            
            particle.zDepth = pos.z;
            if (pos.z < _camera.nearPlaneDistance || pos.z > _camera.farPlaneDistance) 
            {
                img.visible = false;
            }
            else 
            {
                var scale : Float = particle.scale * _camera.projectionDistance / pos.z;
                pos.project();
                img.scaleX = scale;
                img.scaleY = scale;
                img.x = pos.x + _halfWidth;
                img.y = pos.y + _halfHeight;
                img.transform.colorTransform = particle.colorTransform;
                img.visible = true;
                if (particle.rotation.equals(Quaternion.IDENTITY)) 
                {
                    f = particle.faceAxis;
                }
                else 
                {
                    var m : Matrix3D = particle.rotation.toMatrixTransformation();
                    f = m.transformVector(particle.faceAxis);
                }  // facing = camera.transform.transformVector( f );    // The following is very much more efficient than  
                
                
                
                
                
                facing.x = rawCameraTransform[0] * f.x + rawCameraTransform[4] * f.y + rawCameraTransform[8] * f.z + rawCameraTransform[12] * f.w;
                facing.y = rawCameraTransform[1] * f.x + rawCameraTransform[5] * f.y + rawCameraTransform[9] * f.z + rawCameraTransform[13] * f.w;
                facing.z = rawCameraTransform[2] * f.x + rawCameraTransform[6] * f.y + rawCameraTransform[10] * f.z + rawCameraTransform[14] * f.w;
                facing.w = rawCameraTransform[3] * f.x + rawCameraTransform[7] * f.y + rawCameraTransform[11] * f.z + rawCameraTransform[15] * f.w;
                
                if (facing.x != 0 || facing.y != 0) 
                {
                    var angle : Float = Math.atan2(facing.y, facing.x);
                    img.rotation = angle * toDegrees;
                }
            }
        }
        if (_zSort) 
        {
            particles.sort(sortOnZ);
            for (i in 0...len){
                swapChildrenAt(i, getChildIndex(cast((particles[i]), Particle).image));
            }
        }
    }
    
    /**
		 * @private
		 */
    private function sortOnZ(p1 : Particle3D, p2 : Particle3D) : Int
    {
        return p2.zDepth - p1.zDepth;
    }
    
    /**
		 * This method is called when a particle is added to an emitter -
		 * usually becaus ethe emitter has just created the particle. The
		 * method adds the particle's image to the renderer's display list.
		 * It is called internally by Flint and need not be called by the user.
		 * 
		 * @param particle The particle being added to the emitter.
		 */
    override private function addParticle(particle : Particle) : Void
    {
        super.addParticle(particle);
        var img : DisplayObject = try cast(particle.image, DisplayObject) catch(e:Dynamic) null;
        addChildAt(img, 0);
        img.visible = false;
    }
    
    /**
		 * This method is called when a particle is removed from an emitter -
		 * usually because the particle is dying. The method removes the 
		 * particle's image from the renderer's display list. It is called 
		 * internally by Flint and need not be called by the user.
		 * 
		 * @param particle The particle being removed from the emitter.
		 */
    override private function removeParticle(particle : Particle) : Void
    {
        removeChild(particle.image);
        super.removeParticle(particle);
    }
}
