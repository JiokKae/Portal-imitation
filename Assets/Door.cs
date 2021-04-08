using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    [Range(0.0F, 1.0F)]
    public float openModulus;
    public float doorSpeed;
    public float destination;

    public Transform leftDoor;
    public Transform rightDoor;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.O))
            Open();
        else if (Input.GetKeyDown(KeyCode.C))
            Close();

        if (destination > openModulus)
            openModulus += doorSpeed * Time.deltaTime;
        else if (destination < openModulus)
            openModulus -= doorSpeed * Time.deltaTime;

        openModulus = Mathf.Clamp(openModulus, 0.0f, 1.0f);

        leftDoor.localPosition = new Vector3( -(.75f + openModulus * 1.5f), 1.25f, 0f);
        rightDoor.localPosition = new Vector3(.75f + openModulus * 1.5f, 1.25f, 0f);
    }

    public void Open()
    {
        destination = 1;

    }

    public void Close()
    {
        destination = 0;
    }
}
