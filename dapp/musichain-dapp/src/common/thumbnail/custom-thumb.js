import "./custom-thumb.css";

function Thumbnail() {
  return (
    <div class="tabs four text-white">
      <br />
      <h1>Top Rated</h1>
      <input id="tabC-1" type="radio" name="tabGroupC" checked />
      <input id="tabC-2" type="radio" name="tabGroupC" />
      <input id="tabC-3" type="radio" name="tabGroupC" />
      <input id="tabC-4" type="radio" name="tabGroupC" />
      <div class="row">
        <div>
          <img src="https://picnicss.com/img/forest.jpg" />
        </div>
        <div>
          <img src="https://picnicss.com/img/lake.jpg" />
        </div>
        <div>
          <img src="https://picnicss.com/img/halong.jpg" />
        </div>
        <div>
          <img src="https://picnicss.com/img/balloon.jpg" />
        </div>
      </div>
      <label for="tabC-1">
        <img src="https://picnicss.com/img/forest.jpg" />
      </label>
      <label for="tabC-2">
        <img src="https://picnicss.com/img/lake.jpg" />
      </label>
      <label for="tabC-3">
        <img src="https://picnicss.com/img/halong.jpg" />
      </label>
      <label for="tabC-4">
        <img src="https://picnicss.com/img/balloon.jpg" />
      </label>
    </div>
  );
}

export default Thumbnail;
