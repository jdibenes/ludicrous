using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StereoCalibration : MonoBehaviour
{
    public float rx = -0.853670845109363f;
    public float ry = -0.337014872745626f;
    public float rz =  0.397073121425406f;
    public float ro =  0.00881194396716451f;
    public float tx =  0.651606504801960f;
    public float ty =  0.00623719644244305f;
    public float tz =  0.0181880301519866f;

    // Start is called before the first frame update
    void Start()
    {
        Transform t = GetComponent<Transform>();
        float degrees = (ro / Mathf.PI) * 180.0f;
        t.localRotation = Quaternion.AngleAxis(degrees, new Vector3(rx, ry, rz));
        t.localPosition = new Vector3(tx, ty, tz);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
