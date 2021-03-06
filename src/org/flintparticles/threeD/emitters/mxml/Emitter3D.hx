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

package org.flintparticles.threed.emitters.mxml;


import org.flintparticles.threed.emitters.Emitter3D;

import mx.core.IMXMLObject;

/**
	 * @inheritDoc
	 * 
	 * <p>This version of the emitter exposes additional properties to MXML and is intended for use 
	 * in MXML documents.</p>
	 */
class Emitter3D extends org.flintparticles.threed.emitters.Emitter3D implements IMXMLObject
{
    public function new()
    {
        super();
    }
    
    /**
		 * Makes the emitter skip forwards a period of time at teh start. Use this property
		 * when you want the emitter to look like it's been running for a while.
		 */
    @:meta(Inspectable())

    public var runAheadTime : Float = 0;
    
    /**
		 * The frame=-rate to use when running the emitter ahead at the start.
		 * 
		 * @see #runAheadTime
		 */
    @:meta(Inspectable())

    public var runAheadFrameRate : Float = 10;
    
    /**
		 * Indicates if the emitter should start automatically or wait for the start methood to be called.
		 */
    @:meta(Inspectable())

    public var autoStart : Bool = true;
    
    /**
		 * @private
		 */
    public function initialized(document : Dynamic, id : String) : Void
    {
        if (autoStart) 
        {
            start();
        }
        if (runAheadTime != 0) 
        {
            runAhead(runAheadTime, runAheadFrameRate);
        }
    }
}

