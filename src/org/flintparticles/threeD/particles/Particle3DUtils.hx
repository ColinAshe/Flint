/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org/
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

package org.flintparticles.threed.particles;


import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.particles.ParticleFactory;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;

/**
	 * Utility methods for working with three-d particles.
	 */
class Particle3DUtils
{
    public static function createPixelParticlesFromBitmapData(bitmapData : BitmapData, factory : ParticleFactory = null, offset : Vector3D = null) : Array<Particle>
    {
        if (offset == null) 
        {
            offset = new Vector3D(0, 0, 0, 1);
        }
        var particles : Array<Particle> = new Array<Particle>();
        var width : Int = bitmapData.width;
        var height : Int = bitmapData.height;
        var y : Int;
        var x : Int;
        var p : Particle3D;
        var color : Int;
        if (factory != null) 
        {
            for (y in 0...height){
                for (x in 0...width){
                    color = bitmapData.getPixel32(x, y);
                    if (color >>> 24 > 0) 
                    {
                        p = cast((factory.createParticle()), Particle3D);
                        p.position = new Vector3D(x + offset.x, y + offset.y, offset.z, 1);
                        p.color = color;
                        particles.push(p);
                    }
                }
            }
        }
        else 
        {
            for (y in 0...height){
                for (x in 0...width){
                    color = bitmapData.getPixel32(x, y);
                    if (color >>> 24 > 0) 
                    {
                        p = new Particle3D();
                        p.position = new Vector3D(x + offset.x, y + offset.y, offset.z, 1);
                        p.color = color;
                        particles.push(p);
                    }
                }
            }
        }
        return particles;
    }
    
    public static function createRectangleParticlesFromBitmapData(bitmapData : BitmapData, size : Int, factory : ParticleFactory = null, offset : Vector3D = null) : Array<Particle>
    {
        if (offset == null) 
        {
            offset = new Vector3D(0, 0, 0, 1);
        }
        var particles : Array<Particle> = new Array<Particle>();
        var width : Int = bitmapData.width;
        var height : Int = bitmapData.height;
        var y : Int;
        var x : Int;
        var halfSize : Float = size * 0.5;
        offset.x += halfSize;
        offset.y += halfSize;
        var p : Particle3D;
        var b : BitmapData;
        var m : Bitmap;
        var s : Sprite;
        var zero : Point = new Point(0, 0);
        if (factory != null) 
        {
            y = 0;
            while (y < height){
                x = 0;
                while (x < width){
                    p = cast((factory.createParticle()), Particle3D);
                    p.position = new Vector3D(x + offset.x, y + offset.y, offset.z, 1);
                    b = new BitmapData(size, size, true, 0);
                    b.copyPixels(bitmapData, new Rectangle(x, y, size, size), zero);
                    m = new Bitmap(b);
                    m.x = -halfSize;
                    m.y = -halfSize;
                    s = new Sprite();
                    s.addChild(m);
                    p.image = s;
                    p.collisionRadius = halfSize;
                    particles.push(p);
                    x += size;
                }
                y += size;
            }
        }
        else 
        {
            for (y in 0...height){
                for (x in 0...width){
                    p = new Particle3D();
                    p.position = new Vector3D(x + offset.x, y + offset.y, offset.z, 1);
                    b = new BitmapData(size, size, true, 0);
                    b.copyPixels(bitmapData, new Rectangle(x, y, size, size), zero);
                    m = new Bitmap(b);
                    m.x = -halfSize;
                    m.y = -halfSize;
                    s = new Sprite();
                    s.addChild(m);
                    p.image = s;
                    p.collisionRadius = halfSize;
                    particles.push(p);
                }
            }
        }
        return particles;
    }
}

