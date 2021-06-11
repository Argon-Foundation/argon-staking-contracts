pragma solidity 0.6.12;

import "ArgonStakingPool.sol";

contract ArgonStakeMaster is Ownable {
    address[] public pools;
    event PoolCreated(
        address owner,
        address newPoolAddress,
        address stakingToken,
        address poolToken,
        uint256 startBlock,
        uint256 finishBLock,
        uint256 poolTokenAmount,
        bool isPenalty,
        uint256 penaltyRate,
        address penaltyAddress,
        uint256 penaltyBlockLength
    );

    function createStakingPool(
        IERC20 _stakingToken,
        IERC20 _poolToken,
        uint256 _startBlock,
        uint256 _finishBlock,
        uint256 _poolTokenAmount,
        bool _isPenalty,
        uint256 _penaltyRate,
        address _penaltyAddress,
        uint256 _penaltyBlockLength
    ) public onlyOwner {
        ArgonStakingPool newStakingPool =
            new ArgonStakingPool(
                _stakingToken,
                _poolToken,
                _startBlock,
                _finishBlock,
                _poolTokenAmount,
                _isPenalty,
                _penaltyRate,
                _penaltyAddress,
                _penaltyBlockLength
            );
        newStakingPool.transferOwnership(msg.sender);
        _poolToken.transferFrom(
            msg.sender,
            address(newStakingPool),
            _poolTokenAmount
        );
        pools.push(address(newStakingPool));

        emit PoolCreated(
            msg.sender,
            address(newStakingPool),
            address(_stakingToken),
            address(_poolToken),
            _startBlock,
            _finishBlock,
            _poolTokenAmount,
            _isPenalty,
            _penaltyRate,
            _penaltyAddress,
            _penaltyBlockLength
        );
    }

    function getAllPools() public view returns (address[]) {
        return pools;
    }
}
