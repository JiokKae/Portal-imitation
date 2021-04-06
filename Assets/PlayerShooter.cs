using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerShooter : MonoBehaviour
{
    public Transform gunPivot;
    private Animator playerAnimator;

    // Start is called before the first frame update
    void Start()
    {
        playerAnimator = GetComponent<Animator>();    
    }

    // Update is called once per frame
    void Update()
    {

    }

	private void OnAnimatorIK(int layerIndex)
	{
        gunPivot.position = playerAnimator.GetIKHintPosition(AvatarIKHint.RightElbow);

        playerAnimator.SetIKPositionWeight(AvatarIKGoal.RightHand, 1.0f);
        playerAnimator.SetIKRotationWeight(AvatarIKGoal.RightHand, 1.0f);

        playerAnimator.SetIKPosition(AvatarIKGoal.RightHand, gunPivot.position);
        playerAnimator.SetIKRotation(AvatarIKGoal.RightHand, gunPivot.localRotation);

    }
}
