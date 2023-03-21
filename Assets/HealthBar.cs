using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class HealthBar : MonoBehaviour
{

    public float _Health;

    void Update()
    {
        MaterialPropertyBlock props = new MaterialPropertyBlock();
        if (props.GetFloat("_Health") != _Health)
        {
            MeshRenderer renderer;

            props.SetFloat("_Health", _Health);

            renderer = gameObject.GetComponent<MeshRenderer>();
            renderer.SetPropertyBlock(props);
        }
        
    }
}
