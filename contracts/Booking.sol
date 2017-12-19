pragma solidity ^0.4.18;


contract Booking {

    ////////////////////////////////////////////////////////////////////////////
    // Types
    ////////////////////////////////////////////////////////////////////////////

    struct Room {
        uint8 capacity;
        Slot[6] slots;
    }

    struct Slot {
        bool enabled;
        bytes32 data;
        mapping (uint32 => Reservation) reservations;
    }

    struct Reservation {
        address owner;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Modifiers
    ////////////////////////////////////////////////////////////////////////////

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier noEmptyRoom(uint32 roomId) {
        require(rooms[roomId].capacity > 0);
        _;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Attributes
    ////////////////////////////////////////////////////////////////////////////

    /**
     * Max days in which you can book in advance
     */
    uint8 public maxDays;

    /**
    * Owner of the contract
    */
    address private owner;

    /**
     * Available rooms
     */
    mapping(uint32 => Room) private rooms;

    /**
     * List of IDs of available rooms
     */
    uint32[] private roomIds;

    ////////////////////////////////////////////////////////////////////////////
    // Public admin methods
    ////////////////////////////////////////////////////////////////////////////

    /**
     * Constructor where you can set the number of days in which you can book in
     * advance.
     *
     * @param   _maxDays    Days in which you can book in advance
     */
    function Booking(uint8 _maxDays) public {
        require(_maxDays > 0);

        maxDays = _maxDays;
        owner = msg.sender;
    }

    /**
     * Set the numer of days in which you can book in advance.
     *
     * @param   _maxDays    Number of days in which you can book in advance
     */
    function setMaxDays(uint8 _maxDays) public onlyOwner {
        require(_maxDays > 0);

        maxDays = _maxDays;
    }

    /**
     * Set room information.
     *
     * @param   roomId      ID of the room.
     * @param   capacity    Capacity of the room.
     */
    function setRoom(uint32 roomId, uint8 capacity) public onlyOwner {
        require(capacity > 0);

        if (rooms[roomId].capacity == 0) {
            roomIds.push(roomId);
        }

        rooms[roomId].capacity = capacity;
    }

    function getRoom(uint32 roomId) public view
        returns (uint8 capacity, bool[6] enabled, bytes32[6] data)
    {
        Room memory room = rooms[roomId];
        capacity = room.capacity;
        for (uint i = 0; i < 6; i++) {
            Slot memory slot = room.slots[i];
            enabled[i] = slot.enabled;
            data[i] = slot.data;
        }

        return;
    }

    /**
     * Set a time slot data. Useful for store human readable information,
     * like "9:00 - 11:00".
     *
     * @param   roomId  ID of the room
     * @param   order   Time slot of the room
     * @param   data    Data to store
     */
    function setSlot(uint32 roomId, uint8 order, bytes32 data) public noEmptyRoom(roomId) onlyOwner {
        require(order < 6);

        rooms[roomId].slots[order].enabled = true;
        rooms[roomId].slots[order].data = data;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Public user methods
    ////////////////////////////////////////////////////////////////////////////

    /**
     * List all available rooms IDs.
     *
     * @return  List of rooms IDs
     */
    function listRoomsIds() public view returns (uint32[]) {
        return roomIds;
    }

    /**
     * Checks if a room is available for a given slot and day.
     *
     * @param   roomId  Room ID
     * @param   slotId  Slot
     * @param   timestamp     Day computed by dividing unix timestamp by 86400
     * @return          True if available, false if booked.
     */
    function checkAvailability(
        uint32 roomId,
        uint8 slotId,
        uint32 timestamp
    ) public view noEmptyRoom(roomId) returns (bool) {
        Slot storage slot = rooms[roomId].slots[slotId];
        if (!slot.enabled) {
            return false;
        }

        Reservation memory reservation = slot.reservations[getDay(timestamp)];

        return reservation.owner == address(0);
    }

    /**
     * Books a room if available. Fails if the given day to book is "maxDays"
     * after the current day.
     *
     * @param   roomId  Room ID
     * @param   slotId  Slot
     * @param   timestamp     Day computed by dividing unix timestamp by 86400
     */
    function book(uint32 roomId, uint8 slotId, uint32 timestamp) public noEmptyRoom(roomId) {
        uint32 day = getDay(timestamp);
        uint32 currentDay = getCurrentDay();
        require(day >= currentDay && day <= currentDay + maxDays);
        require(rooms[roomId].slots[slotId].enabled);

        Room storage room = rooms[roomId];
        Slot storage slot = room.slots[slotId];
        Reservation storage reservation = slot.reservations[day];
        require(reservation.owner == address(0));

        reservation.owner = msg.sender;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Private methods
    ////////////////////////////////////////////////////////////////////////////

    /**
     * Compute current day by dividing block timestamp by 86400.
     *
     * @return  Current day
     */
    function getCurrentDay() private view returns (uint32) {
        return uint32(block.timestamp / 86400);
    }

    function getDay(uint256 timestamp) private pure returns (uint32) {
        return uint32(timestamp / 86400);
    }
}
