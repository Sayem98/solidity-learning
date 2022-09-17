//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import '../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol';


contract CrowdFund{
    struct Campaign{
        string name;
        string description;
        address creator;
        uint goal;
        uint plaged;
        uint startAt;
        uint endAt;
        bool claimed;
    }
    //State variables
    IERC20 public immutable token;
    mapping(uint=>Campaign) campaigns;
    mapping(uint=>mapping(address=>uint)) plaged;
    uint public count = 0;


    /* Events */
    event EventLunch(address indexed creator, uint indexed index);


    constructor(address _token){
        token = IERC20(_token);
    }

    

    function Lunch(
        uint _goal,
        uint _startAt,
        uint _endAt,
        string memory _name,
        string memory _description)
    external {
        require(_endAt>block.timestamp, 'Ending time is less than starting time');
        // require(bytes(_name).length< 100, 'Name is too big'); and so for description.
        count = count+1;
        Campaign storage campaign = campaigns[count];
        campaign.creator = msg.sender;
        campaign.goal = _goal;
        campaign.startAt = block.timestamp;
        //endAt should be bigger than startAt needs a require()
        campaign.startAt= _startAt;
        campaign.endAt = _endAt;
        campaign.name = _name;
        campaign.description = _description;
        campaign.claimed = false;
        emit EventLunch(msg.sender, count);
        // Could be done this way too.
        // campaigns[count] = Campaign({
        //     creator: msg.sender,
        //     goal: _goal,
        //     pledged: 0,
        //     startAt: _startAt,
        //     endAt: _endAt,
        //     claimed: false
        // });

        

    }

    function Cancel(uint _id) external{
        
    }


}