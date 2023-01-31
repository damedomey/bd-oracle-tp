package mapping.repository;

import oracle.sql.ARRAY;

import java.sql.*;

public class Reservation implements SQLData  {
    private int id;
    private Date requestDatetime;
    private Date startDate;
    private Date endDate;
    private int groupSize;
    private String stateOfReservation;
    private ARRAY listRefBoats;
    private ARRAY listRefPilots;
    private ARRAY listRefCustomers;

    private String sql_type;

    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        sql_type = typeName;
        id = stream.readInt();
        requestDatetime = stream.readDate();
        startDate = stream.readDate();
        endDate = stream.readDate();
        groupSize = stream.readInt();
        stateOfReservation = stream.readString();
        listRefBoats = (ARRAY) stream.readArray();
        listRefPilots = (ARRAY) stream.readArray();
        listRefCustomers = (ARRAY) stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(id);
        stream.writeDate(requestDatetime);
        stream.writeDate(startDate);
        stream.writeDate(endDate);
        stream.writeInt(groupSize);
        stream.writeString(stateOfReservation);
        stream.writeArray(listRefBoats);
        stream.writeArray(listRefPilots);
        stream.writeArray(listRefCustomers);
    }

    public static String findAll() {
        return "SELECT VALUE(re) FROM reservations re";
    }

    public void display(){
        System.out.println("Id : " + id + " group size : " + groupSize);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getRequestDatetime() {
        return requestDatetime;
    }

    public void setRequestDatetime(Date requestDatetime) {
        this.requestDatetime = requestDatetime;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getGroupSize() {
        return groupSize;
    }

    public void setGroupSize(int groupSize) {
        this.groupSize = groupSize;
    }

    public String getStateOfReservation() {
        return stateOfReservation;
    }

    public void setStateOfReservation(String stateOfReservation) {
        this.stateOfReservation = stateOfReservation;
    }

    public ARRAY getListRefBoats() {
        return listRefBoats;
    }

    public void setListRefBoats(ARRAY listRefBoats) {
        this.listRefBoats = listRefBoats;
    }

    public ARRAY getListRefPilots() {
        return listRefPilots;
    }

    public void setListRefPilots(ARRAY listRefPilots) {
        this.listRefPilots = listRefPilots;
    }

    public ARRAY getListRefCustomers() {
        return listRefCustomers;
    }

    public void setListRefCustomers(ARRAY listRefCustomers) {
        this.listRefCustomers = listRefCustomers;
    }
}
