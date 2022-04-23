using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Extrinsics : MonoBehaviour
{
    public float rx = 1.0f;
    public float ry = 0.0f;
    public float rz = 0.0f;
    public float ro = 0.0f;
    public float tx = 0.0f;
    public float ty = 0.0f;
    public float tz = 0.0f;

    // Start is called before the first frame update
    void Start()
    {
        Transform t = GetComponent<Transform>();
        float degrees = (ro / Mathf.PI) * 180.0f;
        t.rotation = Quaternion.AngleAxis(degrees, new Vector3(rx, ry, rz));
        t.position = new Vector3(tx, ty, tz);
    }

    // Update is called once per frame
    void Update()
    {
        if (!Input.GetKeyDown("d")) { return; }

        GameObject g2 = gameObject.transform.GetChild(0).gameObject;

        Camera cam1 = GetComponent<Camera>();
        Camera cam2 = g2.GetComponent<Camera>();

        Vector3 pos1 = cam1.WorldToScreenPoint(new Vector3(0,0,0));
        Vector3 pos2 = cam2.WorldToScreenPoint(new Vector3(0,0,0));

        Debug.Log("pixel 1 (" + pos1.x + "," + pos1.y + ")");
        Debug.Log("pixel 2 (" + pos2.x + "," + pos2.y + ")");
    }
}
