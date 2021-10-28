import "./button.css";

function MusiButton(props) {
  const clickAction = props.onClick ? props.onClick : () => {};
  const className = props.className ? props.className : "cst-default";
  return (
    <button className={className} onClick={clickAction}>
      {props.text}
    </button>
  );
}

export default MusiButton;
