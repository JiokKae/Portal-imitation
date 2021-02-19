using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour
{
    public string verticalAxisName = "Vertical";
    public string horizontalAxisName = "Horizontal";
    public string mouseXAxisName = "Mouse X";
    public string mouseYAxisName = "Mouse Y";
    public string jumpAxisName = "Jump";


    public float verticalMove { get; private set; }
    public float horizontalMove { get; private set; }
    public float mouseXMove { get; private set; }
    public float mouseYMove { get; private set; }
    public float jumpMove { get; private set; }

    void Update()
    {
        verticalMove = Input.GetAxis(verticalAxisName);
        horizontalMove = Input.GetAxis(horizontalAxisName);
        mouseXMove = Input.GetAxis(mouseXAxisName);
        mouseYMove = Input.GetAxis(mouseYAxisName);
        jumpMove = Input.GetAxis(jumpAxisName);

    }
}
