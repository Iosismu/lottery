pragma solidity >=0.4.22 <0.9.0;

contract Lottery {
    // public으로 만들게 되면 자동으로 getter를 만들어 준다.
    // 그래서 Smart Contract 외부에서 변수(owner) 값을 바로 확인 가능.
    address public owner;

    // Smart Contracts가 실행,배포가 될 떄 가장먼저 실행 되는 함수!!
    constructor() public {
        // 배포가 될 떄 보낸사름으로 owner를 하겠다.
        // msg.sender는 Smart Contracts 자체에서 제공 해 주는 글로벌 변수
        owner = msg.sender;
    }

    function getSomeValue() public pure returns (uint256 value) {
        return 5;
    }
}
