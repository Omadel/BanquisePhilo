using UnityEngine;

namespace CMF {
    //This abstract character input class serves as a base for all other character input classes;
    //The 'Controller' component will access this script at runtime to get input for the character's movement (and jumping);
    //By extending this class, it is possible to implement custom character input;
    public abstract class CharacterInput : MonoBehaviour {
        public bool IsJumpKeyPressed => isJumpKeyPressed;
        public bool IsSprintKeyPressed => isSprintKeyPressed;

        protected bool isJumpKeyPressed;
        protected bool isSprintKeyPressed;

        public abstract float GetHorizontalMovementInput();
        public abstract float GetVerticalMovementInput();
    }
}
