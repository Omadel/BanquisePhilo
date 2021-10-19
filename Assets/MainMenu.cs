using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{

    public void OnClickPlayGame()
    {
        SceneManager.LoadScene("Scene");
    }
    public void OnClickQuitGame()
    {
        Application.Quit();
    }
}
