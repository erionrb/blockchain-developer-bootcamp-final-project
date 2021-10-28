import logo from "./logo.svg";
import "./App.css";
import MusicCard from "./store/card/music-card";
import Menu from "./header/menu";
import Thumbnail from "./common/thumbnail/custom-thumb";

function App() {
  return (
    <div className="App">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/picnic" />
      <Menu />
      <div className="App-content">
        <Thumbnail />
        <MusicCard />
      </div>
    </div>
  );
}

export default App;
