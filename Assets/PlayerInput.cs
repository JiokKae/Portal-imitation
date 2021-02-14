using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour
{
    public string verticalAxisName = "Vertical";
    public string horizontalAxisName = "Horizontal";

    public float verticalMove { get; private set; }
    public float horizontalMove { get; private set; }

    void Update()
    {
        verticalMove = Input.GetAxis(verticalAxisName);
        horizontalMove = Input.GetAxis(horizontalAxisName);
    }
}
