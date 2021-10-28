import "./music-card.css";
import MusiButton from "../../common/button/custom-button";

function MusicCard() {
  return (
    <div class="flex two padding">
      <div>
        <article className="card">
          <header>
            <h3>Three Days Grace - Life Starts Now </h3>
          </header>
          <img src="https://i.pinimg.com/originals/d4/c1/49/d4c149bfd1b6b8227ff5edeb9e2e7c37.jpg" />
          <footer>
            <MusiButton
              className="cst-primary"
              onClick={() => alert("buying !")}
              text="Buy"
            />
            <span className="spacing-left" />
            <MusiButton
              className="cst-default"
              onClick={() => alert("seeing more !")}
              text="More"
            />
          </footer>
        </article>
      </div>
      <div>
        <article className="card padding">
          <header>
            <h3>Alter Bridge - Blackbird</h3>
          </header>
          <img src="https://napalmrecords.com/pub/media/catalog/product/cache/2c98b5dedb058b51317c19b0b945bfc5/2/3/23638_alter_bridge_blackbird_cd_heavy_metal_napalm_records.jpg" />
          <footer>
            <MusiButton
              className="cst-primary"
              onClick={() => alert("buying !")}
              text="Buy"
            />
            <span className="spacing-left" />
            <MusiButton
              className="cst-default"
              onClick={() => alert("seeing more !")}
              text="More"
            />
          </footer>
        </article>
      </div>
    </div>
  );
}

export default MusicCard;
