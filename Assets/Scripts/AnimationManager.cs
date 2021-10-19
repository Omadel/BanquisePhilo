using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationManager : MonoBehaviour
{
    [SerializeField] private Animator m_animator;
    [SerializeField] private Rigidbody m_rigidbody;

    private void Update()
    {
        if (this.GetComponent<CMF.SimpleWalkerController>().enabled)
        {
            if (m_animator.GetBool("walk"))
            {
                if (m_rigidbody.velocity.magnitude <= 0.1f)
                {
                    m_animator.SetBool("walk", false);
                }
            }
            else
            {
                if (m_rigidbody.velocity.magnitude > 0.1f)
                {
                    m_animator.SetBool("walk", true);
                }
            }
        }
        else
        {
            m_animator.SetBool("walk", false);
        }

    }

}
