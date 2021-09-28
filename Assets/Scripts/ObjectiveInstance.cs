using UnityEngine;
using System;

public class ObjectiveInstance : MonoBehaviour
{
    public static event Action<GameObject> OnPlayerTriggerEnterObjective;
    public static event Action<GameObject> OnPlayerTriggerExitObjective;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            OnPlayerTriggerEnterObjective?.Invoke(this.gameObject);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if(other.tag == "Player")
        {
            OnPlayerTriggerExitObjective?.Invoke(this.gameObject);
        }
    }
}
