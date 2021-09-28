using System;
using UnityEngine;

public class DayTransitionManager : MonoBehaviour
{
    public static DayTransitionManager instance;

    [SerializeField] public string[] dayTexts = new string[0];

    public int dayIndex = 0;

    public static event Action<string, string> InitDaytTransitionEvent;

    private void Awake()
    {
        instance = this;
    }

    private void Start()
    {
        InitDayTransition();
    }

    public void InitDayTransition()
    {
        if(dayIndex >= dayTexts.Length) { return; }

        string tempPreviousDayText;
        string tempCurrDayText;
        if (dayIndex == 0)
        {
            tempPreviousDayText = "";
            tempCurrDayText = dayTexts[0];
        }
        else if (dayIndex == dayTexts.Length)
        {
            tempPreviousDayText = dayTexts[dayTexts.Length];
            tempCurrDayText = "";
        }
        else
        {
            tempPreviousDayText = dayTexts[dayIndex - 1];
            tempCurrDayText = dayTexts[dayIndex];
        }

        InitDaytTransitionEvent?.Invoke(tempPreviousDayText, tempCurrDayText);

        dayIndex++;
    }
}
