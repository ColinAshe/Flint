package org.flintparticles.integration.flare3d.initializers;


import flare.core.Pivot3D;
import flare.materials.Material3D;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.common.particles.Particle;

/**
	 * @author Richard
	 */
class F3DCloneMaterial extends InitializerBase
{
    public var material(get, set) : Material3D;

    private var _material : Material3D;
    
    public function new(material : Material3D)
    {
        super();
        _material = material;
        _priority = -10;
    }
    
    private function get_Material() : Material3D
    {
        return _material;
    }
    
    private function set_Material(value : Material3D) : Material3D
    {
        _material = material;
        return value;
    }
    
    override public function initialize(emitter : Emitter, particle : Particle) : Void
    {
        if (particle.image && Std.is(particle.image, Pivot3D)) 
        {
            cast((particle.image), Pivot3D).setMaterial(_material.clone());
        }
    }
}

