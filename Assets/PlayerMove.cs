using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    public float moveSpeed = 5f;
    public float rotateSpeed = 300f;

    private PlayerInput playerInput;
    private Rigidbody playerRigidbody;
    private Animator playerAnimator;

    public float angle;
    public Vector3 direction;
    public float magnitude;

    private Camera eye;
    void Start()
    {
        Application.targetFrameRate = 120;
        playerInput = GetComponent<PlayerInput>();
        playerRigidbody = GetComponent<Rigidbody>();
        playerAnimator = GetComponent<Animator>();
        eye = GetComponentInChildren<Camera>();
    }

    void Update()
    {
        Rotate();

        Move();

        //playerAnimator.SetFloat("Move", playerInput.move);
    }

    private void Move()
    {
        direction = playerInput.verticalMove * Vector3.forward + playerInput.horizontalMove * Vector3.right;
        angle = Mathf.Atan2(direction.z, direction.x);
        Vector3 moveDistance = (
            Mathf.Abs(playerInput.verticalMove) * Mathf.Sin(angle) * transform.forward + 
            Mathf.Abs(playerInput.horizontalMove) * Mathf.Cos(angle) * transform.right) * moveSpeed * Time.deltaTime;
        playerRigidbody.MovePosition(playerRigidbody.position + moveDistance);
        magnitude = moveDistance.magnitude;
    }

    private void Rotate()
    {
        float turn = playerInput.mouseXMove * rotateSpeed * Time.deltaTime;
        playerRigidbody.rotation = playerRigidbody.rotation * Quaternion.Euler(0f, turn, 0f);

        eye.transform.localRotation *= Quaternion.Euler(-playerInput.mouseYMove * rotateSpeed * Time.deltaTime, 0f, 0f);
    }

}
