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

package org.flintparticles.common.renderers;


import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.events.EmitterEvent;
import org.flintparticles.common.events.ParticleEvent;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.renderers.Renderer;

import mx.core.UIComponent;

import openfl.events.Event;

/**
	 * The base class used by all the Flex compatible renderers. This class manages
	 * various aspects of the rendering process.
	 * 
	 * <p>The class will add every emitter it should renderer to it's internal
	 * collection of emitters. It will listen for the appropriate events on the 
	 * emitter and will then call the protected methods addParticle, removeParticle
	 * and renderParticles at the appropriate times. Many derived classes need 
	 * only implement these three methods to manage the rendering of the particles.</p>
	 */
class FlexRendererBase extends UIComponent implements Renderer
{
    public var emitters(get, set) : Array<Emitter>;

    /**
		 * @private
		 * 
		 * We retain assigned emitters in this array merely so the reference exists and they are not
		 * garbage collected. This ensures the expected behaviour is achieved - an emitter that exists
		 * on a renderer is not garbage collected, an emitter that does not exist on a renderer may be 
		 * garbage collected if no other references exist.
		 */
    private var _emitters : Array<Emitter>;
    
    private var _particles : Array<Dynamic>;
    
    /**
		 * The constructor creates a FlexRendererBase class.
		 */
    public function new()
    {
        super();
        _emitters = new Array<Emitter>();
        _particles = [];
        mouseEnabled = false;
        mouseChildren = false;
        addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
    }
    
    /**
		 * Adds the emitter to the renderer. When an emitter is added, the renderer
		 * invalidates its display so the renderParticles method will be called
		 * on the next render event in the frame update.
		 * 
		 * @param emitter The emitter that is added to the renderer.
		 */
    public function addEmitter(emitter : Emitter) : Void
    {
        _emitters.push(emitter);
        if (stage) 
        {
            stage.invalidate();
        }
        emitter.addEventListener(EmitterEvent.EMITTER_UPDATED, emitterUpdated, false, 0, true);
        emitter.addEventListener(ParticleEvent.PARTICLE_CREATED, particleAdded, false, 0, true);
        emitter.addEventListener(ParticleEvent.PARTICLE_ADDED, particleAdded, false, 0, true);
        emitter.addEventListener(ParticleEvent.PARTICLE_DEAD, particleRemoved, false, 0, true);
        emitter.addEventListener(ParticleEvent.PARTICLE_REMOVED, particleRemoved, false, 0, true);
        for (p/* AS3HX WARNING could not determine type for var: p exp: EField(EIdent(emitter),particlesArray) type: null */ in emitter.particlesArray)
        {
            addParticle(p);
        }
        if (_emitters.length == 1) 
        {
            addEventListener(Event.RENDER, updateParticles, false, 0, true);
        }
    }
    
    /**
		 * Removes the emitter from the renderer. When an emitter is removed, the renderer
		 * invalidates its display so the renderParticles method will be called
		 * on the next render event in the frame update.
		 * 
		 * @param emitter The emitter that is removed from the renderer.
		 */
    public function removeEmitter(emitter : Emitter) : Void
    {
        for (i in 0..._emitters.length){
            if (_emitters[i] == emitter) 
            {
                _emitters.splice(i, 1);
                emitter.removeEventListener(EmitterEvent.EMITTER_UPDATED, emitterUpdated);
                emitter.removeEventListener(ParticleEvent.PARTICLE_CREATED, particleAdded);
                emitter.removeEventListener(ParticleEvent.PARTICLE_ADDED, particleAdded);
                emitter.removeEventListener(ParticleEvent.PARTICLE_DEAD, particleRemoved);
                emitter.removeEventListener(ParticleEvent.PARTICLE_REMOVED, particleRemoved);
                for (p/* AS3HX WARNING could not determine type for var: p exp: EField(EIdent(emitter),particlesArray) type: null */ in emitter.particlesArray)
                {
                    removeParticle(p);
                }
                if (_emitters.length == 0) 
                {
                    removeEventListener(Event.RENDER, updateParticles);
                    renderParticles([]);
                }
                else if (stage) 
                {
                    stage.invalidate();
                }
                return;
            }
        }
    }
    
    private function addedToStage(ev : Event) : Void
    {
        if (stage) 
        {
            stage.invalidate();
        }
    }
    
    private function particleAdded(ev : ParticleEvent) : Void
    {
        addParticle(ev.particle);
        if (stage) 
        {
            stage.invalidate();
        }
    }
    
    private function particleRemoved(ev : ParticleEvent) : Void
    {
        removeParticle(ev.particle);
        if (stage) 
        {
            stage.invalidate();
        }
    }
    
    private function emitterUpdated(ev : EmitterEvent) : Void
    {
        if (stage) 
        {
            stage.invalidate();
        }
    }
    
    private function updateParticles(ev : Event) : Void
    {
        renderParticles(_particles);
    }
    
    
    
    /**
		 * The addParticle method is called when a particle is added to one of
		 * the emitters that is being rendered by this renderer.
		 * 
		 * @param particle The particle.
		 */
    private function addParticle(particle : Particle) : Void
    {
        _particles.push(particle);
    }
    
    /**
		 * The removeParticle method is called when a particle is removed from one
		 * of the emitters that is being rendered by this renderer.
		 * 
		 * @param particle The particle.
		 */
    private function removeParticle(particle : Particle) : Void
    {
        var index : Int = Lambda.indexOf(_particles, particle);
        if (index != -1) 
        {
            _particles.splice(index, 1);
        }
    }
    
    /**
		 * The renderParticles method is called during the render phase of 
		 * each frame if the state of one of the emitters being rendered
		 * by this renderer has changed.
		 * 
		 * @param particles The particles being managed by all the emitters
		 * being rendered by this renderer. The particles are in no particular
		 * order.
		 */
    private function renderParticles(particles : Array<Dynamic>) : Void
    {
        
    }
    
    /**
		 * The array of all emitters being rendered by this renderer. This is exposed
		 * to enable setting of the emitters in mxml files. It is not intended to be used
		 * from Actionscript code.
		 */
    private function get_Emitters() : Array<Emitter>
    {
        return _emitters;
    }
    private function set_Emitters(value : Array<Emitter>) : Array<Emitter>
    {
        if (value != emitters) 
        {
            clearEmitters();
            for (e in value)
            {
                addEmitter(e);
            }
        }
        return value;
    }
    
    /**
		 * Removes every emitter rendered by this renderer.
		 */
    public function clearEmitters() : Void
    {
        while (_emitters.length > 0)
        {
            removeEmitter(_emitters[0]);
        }
    }
    
    /**
		 * private
		 */
    override private function measure() : Void
    {
        super.measure();
        
        measuredWidth = 200;
        measuredMinWidth = 0;
        measuredHeight = 200;
        measuredMinHeight = 0;
    }
}

