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
    public float maxSpeed;

    public Transform spine;
    public Transform eyePivot;
    public float eyeAngle;

    public Portal orangePortal;
    public Portal bluePortal;
    public bool orangePortalOn;
    public bool bluePortalOn;

    public Transform grabPivot;
    public Grabbable grabbedObject;

    void Start()
    {
        Application.targetFrameRate = 120;
        playerInput = GetComponent<PlayerInput>();
        playerRigidbody = GetComponent<Rigidbody>();
        playerAnimator = GetComponent<Animator>();
    }

	private void FixedUpdate()
	{
        if(grabbedObject)
		{
            grabbedObject.Grab(grabPivot.position);
		}

		if(playerRigidbody.velocity.magnitude > maxSpeed)
		{
            playerRigidbody.velocity = playerRigidbody.velocity.normalized * maxSpeed;
        }

	}
	void Update()
    {
        Rotate();

        Move();

        playerAnimator.SetFloat("VelocityX", playerInput.horizontalMove);
        playerAnimator.SetFloat("VelocityY", playerInput.verticalMove);

        if (playerInput.jumpMove == 1 && Mathf.Abs(playerRigidbody.velocity.y) < 0.01f)
            playerRigidbody.AddForce(transform.up * 3000f);

        bool blueClick = false;
        bool orangeClick = false;
        bool eClick = false;

        if (Input.GetMouseButtonDown(0))
            blueClick = true;
        else if (Input.GetMouseButtonDown(1))
            orangeClick = true;
        else if (Input.GetKeyDown(KeyCode.E))
            eClick = true;

        if (blueClick | orangeClick | eClick)
		{
            RaycastHit hit;

            Ray ray = new Ray(Camera.main.transform.position, Camera.main.transform.forward);
            if (Physics.Raycast(ray, out hit, 1000.0f))
			{
                Portalable portalable = hit.collider.GetComponent<Portalable>();
                Grabbable grabbable;
                if (portalable)
				{
                    if(blueClick)
                        portalable.StartPortalOpen(hit.point, hit.normal, bluePortal);
                    else
                        portalable.StartPortalOpen(hit.point, hit.normal, orangePortal, true);
                }
                else if(grabbable = hit.collider.GetComponent<Grabbable>())
				{
                    grabbedObject = grabbable;
				}
			}
		}
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

        // 항상 서있게 해주기
        playerRigidbody.rotation = Quaternion.Slerp(playerRigidbody.rotation, Quaternion.Euler(0f, playerRigidbody.rotation.eulerAngles.y, 0f), 0.1f); 
    }

	private void LateUpdate()
	{
        eyeAngle -= playerInput.mouseYMove * rotateSpeed * Time.deltaTime;
        eyeAngle = Mathf.Clamp(eyeAngle, -270f, -120f);
        spine.localRotation = Quaternion.Euler(eyeAngle, 0f, 0f);
        eyePivot.localRotation = Quaternion.Euler(eyeAngle + 180f, 0f, 0f);

    }
}
