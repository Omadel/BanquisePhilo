using UnityEngine;

[UnityEditor.CustomEditor(typeof(TimeOfDayHandeler))]
public class TimeOfDayHandelerEditor : EtienneEditor.Editor<TimeOfDayHandeler> {
    private void OnSceneGUI() {
        GameObject lair = serializedObject.FindProperty("start").objectReferenceValue as GameObject;
        UnityEditor.Handles.color = Color.red;
        UnityEditor.Handles.DrawWireArc(lair.transform.position, Vector3.up, Vector3.right, 360, Target.DistanceMax);
    }
}
