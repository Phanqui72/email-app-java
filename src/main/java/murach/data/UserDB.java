package murach.data;

import murach.business.User;

public class UserDB {
    public static void insert(User user) {
        // Giả lập lưu vào cơ sở dữ liệu bằng cách in ra console
        System.out.println("Inserting user: " + user.getFirstName() + " " + user.getLastName());
    }
}