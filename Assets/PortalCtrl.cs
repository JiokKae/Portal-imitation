using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalCtrl : MonoBehaviour
{
    public Transform gunPivot;
    public Transform rightMount;

    Animator animator;
    // Start is called before the first frame update
    void Start()
    {
        animator = GetComponent<Animator>();
    }

    private void OnAnimatorIK(int layerIndex)
    {
        gunPivot.position = animator.GetIKHintPosition(AvatarIKHint.RightElbow);

        animator.SetIKPositionWeight(AvatarIKGoal.RightHand, 1.0f);
        animator.SetIKRotationWeight(AvatarIKGoal.RightHand, 1.0f);

        animator.SetIKPosition(AvatarIKGoal.RightHand, rightMount.position);
        animator.SetIKRotation(AvatarIKGoal.RightHand, rightMount.rotation);

       
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            transform.Rotate(0, 10f, 0);
        }
        else if (Input.GetKey(KeyCode.RightArrow))
        {
            transform.Rotate(0, -10f, 0);
        }
    }
}
