using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AStar : Dijkstra
{
    public override void LogMessage(string text)
    {
        Debug.LogWarning("AStar: " + text);
    }
    
    protected override bool RunAlgorithm(Node startWaypoint, Node endWaypoint)
    {
        List<Node> unexplored = new List<Node>();
        Node start = null;
        Node end = null;

        foreach(Node obj in _nodesInScene)
        {
            Node node = obj.GetComponent<Node>();
            if(node == null) continue;
            node.ResetNode(endWaypoint.transform.position);
            unexplored.Add(node);

            if (startWaypoint == obj) start = node;
            if (endWaypoint == obj) end = node;
        }

        if (start == null && end == null)
        {
            return false;
        }

        start.PathWeight = 0;

        while (unexplored.Count > 0)
        {
            unexplored.Sort((a,b) => a.PathWeightDistance.CompareTo(
                                                        b.PathWeightDistance));

            Node current = unexplored[0];
            unexplored.RemoveAt(0);

            if (current == end) break; //We have found the shortest path, stop looping through unexplored

            foreach (Node neighbourNode in current._neighbours)
            {
                if(!unexplored.Contains(neighbourNode)) continue;

                float neighbourWeight = Vector3.Distance(neighbourNode.transform.position,
                    current.transform.position);

                neighbourWeight += current.PathWeight;

                if (neighbourWeight < neighbourNode.PathWeightDistance)
                {
                    neighbourNode.PathWeight = neighbourWeight;
                    neighbourNode.PreviousNode = current;
                }
            }
        }
        
        return true;
    }
}
