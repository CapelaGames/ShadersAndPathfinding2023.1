using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection.Emit;
using System.Runtime.CompilerServices;
using UnityEngine;

public class Node  : MonoBehaviour
{
    //field
    private float _pathWeight = int.MaxValue;
    //property
    public float PathWeight
    {
        get { return _pathWeight; }
        set {
            _pathWeight = value;
        }
    }

    public float distanceToEnd;

    public float PathWeightDistance
    {
        get
        {
            return _pathWeight + distanceToEnd;
        }
    }
    private Vector3 _endPosition;
    public Node PreviousNode { get; set; }

    [SerializeField] public List<Node> _neighbours;

    public void ResetNode(Vector3 endPosition)
    {
        _pathWeight = int.MaxValue;
        PreviousNode = null;
        _endPosition = endPosition;
        distanceToEnd = Vector3.Distance(transform.position, _endPosition);
    }
    
    private void OnValidate()
    {
        ValidateNeighbours();
    }

    private void ValidateNeighbours()
    {
        foreach (Node waypoint in _neighbours)
        {
            if(waypoint == null) continue;

            if (!waypoint._neighbours.Contains(this))
            {
                waypoint._neighbours.Add(this);
            }
        }
    }

    private void OnDrawGizmos()
    {
        if (_neighbours == null) return;
        foreach (Node neighbour in _neighbours)
        {
            if( neighbour == null) continue;
            Gizmos.color = Color.blue;
            Gizmos.DrawLine(transform.position, neighbour.transform.position);
        }
    }
    
}
