using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DayTransitionManager : MonoBehaviour
{
    [SerializeField] private string[] dayTexts = new string[0];

    private int dayIndex = 0;

    public static event Action<string, string> InitDaytTransitionEvent;

    public static event Action<GameController.GameSate> OnGameStateChange;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            InitDayTransition();
        }

        if (Input.GetKeyDown(KeyCode.A))
        {
            OnGameStateChange?.Invoke(GameController.GameSate.GoEat);
        }
    }

    private void InitDayTransition()
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

        InitDaytTransitionEvent.Invoke(tempPreviousDayText, tempCurrDayText);

        dayIndex++;
    }
}
