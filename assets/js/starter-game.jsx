import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root,channel) {
  ReactDOM.render(<Starter channel={channel} />, root);
}

class Starter extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;

    this.state = {alphabets : [],
                  indisplay : [],
                  finished : [],
                  visibilityStatus : [],
                  numOfClicks : 0,
                };
  //Referred to https://reactjs.org/docs/handling-events.html for binding events
   this.handleClick = this.handleClick.bind(this);
   this.channel
       .join()
       .receive("ok", this.got_view.bind(this))
       .receive("error", resp => { console.log("Unable to join", resp); });
  }


  got_view(view) {
    console.log("new view", view);
    this.setState(view.game);

  }
  swap(_ev) {
    let state1 = _.assign({}, this.state, { left: !this.state.left });
    this.setState(state1);
  }

  hax(_ev) {
    alert("hax!");
  }


  handleClick(e) {
    console.log("click");
    console.log(e.target.id);
    var id = e.target.id;
    if(!(this.state.finished.length === 8 || this.state.indisplay.includes(parseInt(id)) || this.state.finished.flat().includes(parseInt(id)))){

      this.channel.push("onClick", { id: e.target.id})
          .receive("ok", this.got_view.bind(this));
     this.channel.push("onClick2", { id: e.target.id})
        .receive("ok", this.got_view.bind(this));
    }


  }

  handleReset(){
    this.channel.push("onHandleReset", { index: 1 })
        .receive("ok", this.got_view.bind(this));

  }

  render() {

    var allTiles= [];
    var rowWiseTiles = [];
    var tileIndex = 0;
    for(var i=0;i<4;i++)
    {
      for(var j=0;j<4;j++)
      {

        var inputLetter = <input type="button"  className="display" id={tileIndex} value={(this.state.visibilityStatus[4*i+j] === "hide" ? "" : this.state.alphabets[4*i+j])}
        onClick={() => this.handleClick(event)}
         />

        rowWiseTiles.push(inputLetter);
        tileIndex++;
      }
      allTiles.push(rowWiseTiles);
      rowWiseTiles = [];
    }
    return (
      <div>
      <p className ="displayGameDetails"><u>MEMORY GAME </u></p>
      <div className="gridDisplay buttons">
        {allTiles}

      </div>
      <div className= "displayGameDetails">
      No of Clicks : {this.state.numOfClicks}
      <br/>
      Game Status : {this.state.numOfClicks === 0? " Game Not Started" : (this.state.finished.length === 8? "You Won" : "Game In Progress")}
      </div>
      <div>
      <input type="button" className="resetButton" id="resetBtn" value="Reset Game" onClick={()=>this.handleReset()}/>
      </div>
      </div>
    );
  }
}
