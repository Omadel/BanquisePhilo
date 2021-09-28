using UnityEngine;

[RequireComponent(typeof(Light))]
public class TimeOfDay : MonoBehaviour {
    public Vector2 BaseRotation => baseRotation;
    [SerializeField] private Vector2 baseRotation;
    public float Time => time;
    [SerializeField, Range(0, 24)] private float time = 12;

    public void CalculateTimeOfDay() {
        float sunangle = (time/24f) * 360 - 90;
        Vector3 midpoint = Vector3.zero;

        transform.position = midpoint + Quaternion.Euler(baseRotation.x, baseRotation.y, sunangle) * (5 * Vector3.right);
        transform.LookAt(midpoint);
    }

    /// <summary>
    /// Set the time of day and calculate it
    /// </summary>
    /// <param name="time">time in 24h format</param>
    public void SetTime(float time) {
        this.time = time;
        CalculateTimeOfDay();
    }
}
