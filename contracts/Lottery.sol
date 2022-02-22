pragma solidity >=0.4.22 <0.9.0;
contract Lottery {
    struct BetInfo {
        uint256 answerBlockNumber;
        address payable bettor;
        byte challenges; // 0xab
    }
    // public으로 만들게 되면 자동으로 getter를 만들어 준다.
    // 그래서 Smart Contract 외부에서 변수(owner) 값을 바로 확인 가능.
    address public owner;
    uint256 private _tail;
    uint256 private _head;
    mapping(uint256 => BetInfo) private _bets;
    uint256 internal constant BLOCK_LIMIT = 256;
    uint256 internal constant BET_BLOCK_INTERNAL = 3;
    uint256 internal constant BET_AMOUNT = 5 * 10**15;
    uint256 private _pot;
    event BET(uint256 index, address bettor, uint256 amount, byte challenges, uint256 answerBlockNumber);
    // Smart Contracts가 실행,배포가 될 떄 가장먼저 실행 되는 함수!!
    constructor() public {
        // 배포가 될 떄 보낸사름으로 owner를 하겠다.
        // msg.sender는 Smart Contracts 자체에서 제공 해 주는 글로벌 변수
        owner = msg.sender;
    }
    function getPot() public view returns (uint256 pot) {
        return _pot;
    }
    // Bet
    /**
    * @dev 배팅을 한다. 유저는 0.005 ETF를 보내야 하고, 배팅용 1 byte 글자를 보낸다.
    * 큐에 저장된 베팅 정보는 이후 distribute 함수에서 해결된다.
    * @param challenges 유저가 베팅하는 글자
    * @return 함수가 잘 수행되었는지 확인해주는 bool 값
    */
    function bet(byte challenges) public payable returns (bool result) {
      // Check the proper ether is sent
      require(msg.value == BET_AMOUNT, "Not enough ETH");
      // Push bet to the queue
      require(pushBet(challenges), "Fail to add a new Bet Info");
      // Emit event
      emit BET(_tail - 1, msg.sender, msg.value, challenges, block.number + BET_BLOCK_INTERNAL);
      return true;
    }
    // save the bet to the queue
    // Distribute
      // check the answer
    function getBetInfo(uint256 index) public view returns (uint256 answerBlockNumber, address bettor, byte challenges) {
      BetInfo memory b = _bets[index];
      answerBlockNumber = b.answerBlockNumber;
      bettor = b.bettor;
      challenges = b.challenges;
    }
    function pushBet(byte challenges) internal returns (bool) {
       BetInfo memory b;
       b.bettor = msg.sender;
       b.answerBlockNumber = block.number + BET_BLOCK_INTERNAL;
       b.challenges = challenges;
       _bets[_tail] = b;
       _tail++;
       return true;
    }
    function popBet(uint256 index) internal returns (bool) {
      // delete는 일정량의 Gas를 돌려준다. 그래서 사용하지 않는 값은 delete해주는게 좋다. 
      delete _bets[index];
      return true;
    }
}