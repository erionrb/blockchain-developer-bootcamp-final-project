import MusiButton from "../common/button/custom-button";
import "./menu.css";

function Menu() {
  return (
    <nav className="background">
      <a href="#" class="brand">
        <span className="text">Musichain</span>
      </a>

      <input id="bmenub" type="checkbox" class="show" />
      <label for="bmenub" class="burger pseudo button">
        menu
      </label>

      <div class="menu">
        <MusiButton
          className="cst-default"
          onClick={() => alert("Clicked !")}
          text="Sign up"
        />
        <MusiButton
          className="cst-primary"
          onClick={() => alert("Clicked !")}
          text="Sign in"
        />
      </div>
    </nav>
  );
}

export default Menu;
