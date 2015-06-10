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

package org.flintparticles.threed.renderers.controllers.mxml;


import org.flintparticles.threed.renderers.controllers.KeyboardControllerBase;

import mx.core.IMXMLObject;

import openfl.display.DisplayObject;
import openfl.events.Event;

/**
	 * Base class for keyboard based camera controllers. Tracks the keyboard state for camera controllers.
	 */
class KeyboardControllerMxml extends KeyboardControllerBase implements IMXMLObject
{
    public function initialized(document : Dynamic, id : String) : Void
    {
        var displayObj : DisplayObject = try cast(document, DisplayObject) catch(e:Dynamic) null;
        if (displayObj != null) 
        {
            if (displayObj.stage) 
            {
                this.stage = displayObj.stage;
            }
            else 
            {
                displayObj.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
            }
        }
        if (autoStart) 
        {
            start();
        }
    }
    
    private function addedToStage(ev : Event) : Void
    {
        this.stage = cast((ev.target), DisplayObject).stage;
    }

    public function new()
    {
        super();
    }
}
