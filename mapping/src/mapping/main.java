package mapping;

import mapping.repository.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class main {
    public static void main(String[] args) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@144.21.67.201:1521/PDBM1INF.631174089.oraclecloud.internal", "AMEDOMEY1I2223", "Amedomey1I222301");
            Statement stmt = connection.createStatement();

            // Mapping des types
            java.util.Map mapOraObjType = connection.getTypeMap();
            mapOraObjType.put((Object)"AMEDOMEY1I2223.BOAT", (Object)Class.forName("mapping.repository.Boat"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.CATEGORY", (Object)Class.forName("mapping.repository.Category"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.RESERVATION", (Object)Class.forName("mapping.repository.Reservation"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.PILOT", (Object)Class.forName("mapping.repository.Pilot"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.CUSTOMER", (Object)Class.forName("mapping.repository.Customer"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.PERSON", (Object)Class.forName("mapping.repository.Person"));

            // Find all sur tous les types
            ResultSet resultsetTableau = stmt.executeQuery(Boat.findAll());
            System.out.println("***************************INFOS Bateaux***************************************");
            while (resultsetTableau.next()) {
                Boat boat = (Boat) resultsetTableau.getObject(1, mapOraObjType);
                boat.display();
            }

            resultsetTableau = stmt.executeQuery(Category.findAll());
            System.out.println("***************************INFOS Categories***************************************");
            while (resultsetTableau.next()) {
                Category category = (Category) resultsetTableau.getObject(1, mapOraObjType);
                category.display();
                category.displayBoatsInCategory();
            }

            resultsetTableau = stmt.executeQuery(Customer.findAll());
            System.out.println("***************************INFOS Customers***************************************");
            while (resultsetTableau.next()) {
                Customer customer = (Customer) resultsetTableau.getObject(1, mapOraObjType);
                customer.display();
            }

            resultsetTableau = stmt.executeQuery(Pilot.findAll());
            System.out.println("***************************INFOS Pilotes***************************************");
            while (resultsetTableau.next()) {
                Pilot pilot = (Pilot) resultsetTableau.getObject(1, mapOraObjType);
                pilot.display();
            }

            resultsetTableau = stmt.executeQuery(Reservation.findAll());
            System.out.println("***************************INFOS Reservations***************************************");
            while (resultsetTableau.next()) {
                Reservation reservation = (Reservation) resultsetTableau.getObject(1, mapOraObjType);
                reservation.display();
            }
        } catch (Exception e){
            System.out.println("Echec du mapping");
            e.printStackTrace();
        }
    }
}
