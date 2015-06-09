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

package org.flintparticles.common.displayobjects;


import flash.display.Shape;

/**
	 * The Rect class is a DisplayObject that is a rectangle shape. The 
	 * registration point of this display object is in the center of the
	 * rectangle.
	 */

class Rect extends Shape
{
    public var color(get, set) : Int;

    private var _width : Float;
    private var _height : Float;
    private var _color : Int;
    
    /**
		 * The constructor creates a Rect with the specified width and height.
		 * 
		 * @param width The width, in pixels, of the rectangle.
		 * @param height The height, in pixels, of the rectangle.
		 * @param color the color of the rectangle
		 * @param bm The blendMode for the rectangle
		 */
    public function new(width : Float = 1, height : Float = 1, color : Int = 0xFFFFFF, bm : String = "normal")
    {
        super();
        _width = width;
        _height = height;
        _color = color;
        draw();
        blendMode = bm;
    }
    
    private function draw() : Void
    {
        graphics.clear();
        graphics.beginFill(_color);
        graphics.drawRect(-_width * 0.5, -_height * 0.5, _width, _height);
        graphics.endFill();
    }
    
    override private function get_Width() : Float
    {
        return _width;
    }
    override private function set_Width(value : Float) : Float
    {
        _width = value;
        draw();
        return value;
    }
    
    override private function get_Height() : Float
    {
        return _height;
    }
    override private function set_Height(value : Float) : Float
    {
        _height = value;
        draw();
        return value;
    }
    
    private function get_Color() : Int
    {
        return _color;
    }
    private function set_Color(value : Int) : Int
    {
        _color = value;
        draw();
        return value;
    }
}

