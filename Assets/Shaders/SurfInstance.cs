using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SurfInstance : MonoBehaviour
{
    public Color color;

    private MeshRenderer _renderer;
    void Update()
    {
        _renderer = GetComponent<MeshRenderer>();
        
        MaterialPropertyBlock props = new MaterialPropertyBlock();

        props.SetColor("_Color", color);
        
        _renderer.SetPropertyBlock(props);
        
        
    }
}
