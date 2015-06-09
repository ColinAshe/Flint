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

package org.flintparticles.integration.away3d.v3.initializers;


import away3d.sprites.MovieClipSprite;

import org.flintparticles.common.initializers.ImageInitializerBase;
import org.flintparticles.common.utils.WeightedArray;
import org.flintparticles.common.utils.Construct;

/**
	 * The A3D3DisplayObjectClasses Initializer sets the DisplayObject to use to draw
	 * the particle in a 3D scene. It is used with the Away3D renderer when
	 * particles should be represented by one of a number of display objects.
	 * 
	 * <p>The initializer creates an Away3D MovieClipSprite, with the display object
	 * as the image source (the movieClip property), for rendering a display 
	 * object in an Away3D scene.</p>
	 * 
	 * <p>This class includes an object pool for reusing objects when particles die.</p>
	 */

class A3D3DisplayObjectClasses extends ImageInitializerBase
{
    private var _images : WeightedArray;
    
    /**
		 * The constructor creates a A3D3DisplayObjectClasses initializer for use by 
		 * an emitter. To add a A3D3DisplayObjectClasses to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param images An array containing the classes to use for 
		 * each particle created by the emitter.
		 * @param weights The weighting to apply to each image class. If no weighting
		 * values are passed, the image classes are used with equal probability.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
    public function new(images : Array<Dynamic>, weights : Array<Dynamic> = null, usePool : Bool = false, fillPool : Int = 0)
    {
        super(usePool);
        _images = new WeightedArray();
        var len : Int = images.length;
        var i : Int;
        if (weights != null && weights.length == len) 
        {
            for (i in 0...len){
                addImage(images[i], weights[i]);
            }
        }
        else 
        {
            for (i in 0...len){
                addImage(images[i], 1);
            }
        }
        if (fillPool > 0) 
        {
            this.fillPool(fillPool);
        }
    }
    
    public function addImage(image : Dynamic, weight : Float = 1) : Void
    {
        if (Std.is(image, Array)) 
        {
            var parameters : Array<Dynamic> = (try cast(image, Array</*AS3HX WARNING no type*/>) catch(e:Dynamic) null).concat();
            var img : Class<Dynamic> = parameters.shift();
            _images.add(new Pair(img, parameters), weight);
        }
        else 
        {
            _images.add(new Pair(image, []), weight);
        }
        if (_usePool) 
        {
            clearPool();
        }
    }
    
    public function removeImage(image : Dynamic) : Void
    {
        _images.remove(image);
        if (_usePool) 
        {
            clearPool();
        }
    }
    
    /**
		 * Used internally, this method creates an image object for displaying the particle 
		 * by creating aninstance of one of the display objects and wrapping it in a MovieClipSprite.
		 */
    override public function createImage() : Dynamic
    {
        var img : Pair = _images.getRandomValue();
        return new MovieClipSprite(construct(img.image, img.parameters), "none", 1, true);
    }
}

class Pair
{
    @:allow(org.flintparticles.integration.away3d.v3.initializers)
    private var image : Class<Dynamic>;
    @:allow(org.flintparticles.integration.away3d.v3.initializers)
    private var parameters : Array<Dynamic>;
    
    public function new(image : Class<Dynamic>, parameters : Array<Dynamic>)
    {
        this.image = image;
        this.parameters = parameters;
    }
}