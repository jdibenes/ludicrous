using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Motion : MonoBehaviour
{
    public float rx = 1.0f;
    public float ry = 0.0f;
    public float rz = 0.0f;
    public float ro_degrees_second = 0.0f;
    public float tx = 0.0f;
    public float ty = 0.0f;
    public float tz = 0.0f;
    public float tn_meters_second = 0.0f;
    public int exposure = 300;

    int state = 0;
    int count = 0;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (state == 0) {
        if (Input.GetKeyDown("s")) { state = 1; }
        }
        else {
        state = 2;
        Transform t = GetComponent<Transform>();
        float meters_per_unit = 0.1085f;
        float units_per_second = (tn_meters_second / meters_per_unit);
        float units_per_line = (units_per_second / 60.0f) / 2160.0f;
        t.position = t.position + new Vector3(tx * units_per_line, ty * units_per_line, tz * units_per_line);
        t.Rotate(new Vector3(rx, ry, rz), (ro_degrees_second / 60.0f) / 2160.0f, Space.World);
        }
    }

    void Screenshot(Camera camera, int id, string camstr, int width, int height) {
        RenderTexture rt = new RenderTexture(width, height, 24);
        camera.targetTexture = rt;
        Texture2D screenShot = new Texture2D(width, height, TextureFormat.RGB24, false);
        camera.Render();
        RenderTexture.active = rt;
        screenShot.ReadPixels(new Rect(0, 0, width, height), 0, 0);
        camera.targetTexture = null;
        RenderTexture.active = null;
        Destroy(rt);
        byte[] bytes = screenShot.EncodeToPNG();
        string filename = string.Format("{0}/Screenshots/im{1}_{2}.png", Application.dataPath, camstr, id);
        System.IO.File.WriteAllBytes(filename, bytes);
        Debug.Log(string.Format("Took screenshot to: {0}", filename));
    }

    void LateUpdate()
    {
        if (state < 2) { return; }

        Camera cam1 = GetComponent<Camera>();
        Camera cam2 = gameObject.transform.GetChild(0).gameObject.GetComponent<Camera>();
        Screenshot(cam1, count, "0", 3840, 2160);
        Screenshot(cam2, count, "1", 3840, 2160);

        count++;
        if (count >= exposure) { state = 0; count = 0; }
    }
}
