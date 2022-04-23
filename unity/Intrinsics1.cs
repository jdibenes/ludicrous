using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Intrinsics1 : MonoBehaviour
{
    public float fx = 3.092761726641308e+03f;
    public float fy = 3.108669008283216e+03f;
    public float cx = 1.933559003364737e+03f - 1.0f; // matlab to regular
    public float cy = 1.085195892819605e+03f - 1.0f; // matlab to regular

    public float width  = 3840.0f;
    public float height = 2160.0f;

    public float far  = 1000.0f;
    public float near =    0.3f;

    // Start is called before the first frame update
    void Start()
    {
        Camera cam = GetComponent<Camera>();

        Matrix4x4 m = new Matrix4x4();

        m[0, 0] =  2.0f * fx / width;
        m[0, 1] =  0.0f;
        m[0, 2] =  1.0f - 2.0f * cx / width;
        m[0, 3] =  0.0f;

        m[1, 0] =  0.0f;
        m[1, 1] =  2.0f * fy / height;
        m[1, 2] =  1.0f - 2.0f * cy / height;
        m[1, 3] =  0.0f;

        m[2, 0] =  0.0f;
        m[2, 1] =  0.0f;
        m[2, 2] = (far + near) / (near - far);
        m[2, 3] =  2.0f * far * near / (near - far);

        m[3, 0] =  0.0f;
        m[3, 1] =  0.0f;
        m[3, 2] = -1.0f;
        m[3, 3] =  0.0f;

        cam.projectionMatrix = m;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
