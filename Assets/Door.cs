using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    [Range(0.0F, 1.0F)]
    public float openModulus;

    public Transform leftDoor;
    public Transform rightDoor;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        leftDoor.localPosition = new Vector3( -(.75f + openModulus * 1.5f), 1.25f, 0f);
        rightDoor.localPosition = new Vector3(.75f + openModulus * 1.5f, 1.25f, 0f);
    }

    void Open()
    {


    }

    void Close()
    {

    }
}
