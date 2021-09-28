using UnityEngine;

[RequireComponent(typeof(TimeOfDay))]
public class TimeOfDayHandeler : Etienne.Singleton<TimeOfDayHandeler> {
    public float DistanceMax => Vector3.Distance(start.transform.position, objective.transform.position);
    public GameObject Objective => objective;
    [SerializeField] private GameObject player, start, objective;
    [SerializeField] private float startTimeOfDay = 7f, speeOfTime = 8f;
    private TimeOfDay time;
    private float maxDistanceFromStart, timeofDay;
    protected override void Awake() {
        base.Awake();
        time = GetComponent<TimeOfDay>();
        ReseTimeOfDay();
    }

    private void Update() {
        float distanceFromStart = Vector3.Distance(player.transform.position, start.transform.position) / DistanceMax;
        name = distanceFromStart.ToString();
        if(distanceFromStart > maxDistanceFromStart) {
            timeofDay += distanceFromStart - maxDistanceFromStart;
            time.SetTime(timeofDay * speeOfTime + startTimeOfDay);
            maxDistanceFromStart = distanceFromStart;
        }
    }

    public void ReseTimeOfDay()
    {
        timeofDay =  0;
        time.SetTime(startTimeOfDay);
    }

    [ContextMenu("Swap")]
    public void Swap() {
        GameObject oldStart = start;
        start = objective;
        objective = oldStart;
        maxDistanceFromStart = 0;

    }
}
