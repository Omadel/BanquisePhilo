using UnityEngine;

[UnityEditor.CustomEditor(typeof(TimeOfDay))]
public class TimeOfDayEditor : EtienneEditor.Editor<TimeOfDay> {
    public override void OnInspectorGUI() {       
        base.OnInspectorGUI();
        if(!Application.isPlaying) {
            Target.CalculateTimeOfDay();
        }
    }
}
