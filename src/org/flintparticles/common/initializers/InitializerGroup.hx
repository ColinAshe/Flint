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

package org.flintparticles.common.initializers;


import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;

@:meta(DefaultProperty(name="initializers"))


/**
	 * The InitializerGroup initializer collects a number of initializers into a single 
	 * larger initializer that applies all the grouped initializers to a particle. It is
	 * commonly used with the ChooseInitializer initializer to choose from different
	 * groups of initializers when initializing a particle.
	 * 
	 * @see org.flintparticles.common.initializers.ChooseInitializer
	 */

class InitializerGroup extends InitializerBase
{
    public var initializers(get, set) : Array<Initializer>;

    private var _initializers : Array<Initializer>;
    private var _emitter : Emitter;
    
    /**
		 * The constructor creates an InitializerGroup.
		 * 
		 * @param initializers Initializers that should be added to the group.
		 */
    public function new()
    {
        super();
        _initializers = new Array<Initializer>();
        for (i in initializers)
        {
            addInitializer(i);
        }
    }
    
    private function get_Initializers() : Array<Initializer>
    {
        return _initializers;
    }
    private function set_Initializers(value : Array<Initializer>) : Array<Initializer>
    {
        var initializer : Initializer;
        if (_emitter != null) 
        {
            for (initializer in _initializers)
            {
                initializer.removedFromEmitter(_emitter);
            }
        }
        _initializers = value.substring();
        _initializers.sort(prioritySort);
        if (_emitter != null) 
        {
            for (initializer in _initializers)
            {
                initializer.addedToEmitter(_emitter);
            }
        }
        return value;
    }
    
    public function addInitializer(initializer : Initializer) : Void
    {
        var len : Int = _initializers.length;
        for (i in 0...len){
            if (_initializers[i].priority < initializer.priority) 
            {
                break;
            }
        }
        _initializers.splice(i, 0, initializer);
        if (_emitter != null) 
        {
            initializer.addedToEmitter(_emitter);
        }
    }
    
    public function removeInitializer(initializer : Initializer) : Void
    {
        var index : Int = Lambda.indexOf(_initializers, initializer);
        if (index != -1) 
        {
            _initializers.splice(index, 1);
            if (_emitter != null) 
            {
                initializer.removedFromEmitter(_emitter);
            }
        }
    }
    
    override public function addedToEmitter(emitter : Emitter) : Void
    {
        _emitter = emitter;
        var len : Int = _initializers.length;
        for (i in 0...len){
            _initializers[i].addedToEmitter(emitter);
        }
    }
    
    override public function removedFromEmitter(emitter : Emitter) : Void
    {
        var len : Int = _initializers.length;
        for (i in 0...len){
            _initializers[i].removedFromEmitter(emitter);
        }
        _emitter = null;
    }
    
    /**
		 * @inheritDoc
		 */
    override public function initialize(emitter : Emitter, particle : Particle) : Void
    {
        var len : Int = _initializers.length;
        for (i in 0...len){
            _initializers[i].initialize(emitter, particle);
        }
    }
    
    private function prioritySort(b1 : Initializer, b2 : Initializer) : Float
    {
        return b1.priority - b2.priority;
    }
}

