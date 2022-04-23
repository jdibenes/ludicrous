using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Intrinsics2 : MonoBehaviour
{
    public float fx = 3.075760065039901e+03f;
    public float fy = 3.090077653518453e+03f;
    public float cx = 1.908250309308530e+03f - 1.0f; // matlab to regular
    public float cy = 9.920829355829316e+02f - 1.0f; // matlab to regular

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
