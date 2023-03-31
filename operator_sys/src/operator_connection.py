import pymysql


class DatabaseConnection:
    """
    # Content:
    # This project design for online Robot shop operator system.
    # Group: (name, email)
    # Member name:
    ** Andy(Xiang-Yu) Cui：cui.xiangyu@northeastern.edu
    ** Shu-Hao Liu：liu.shuha@northeastern.edu
    """

    def __int__(self):
        self.cur = None  # cur is cursor of database(MySQL)
        self.cnx = None  # cnx is connection of database(MySQL)

    def work(self):
        while True:
            print("### Please Login With Your Username and Password ###")
            user_name = input("username: ")
            passwd = input("password: ")

            try:
                self.cnx = pymysql.connect(
                    host='localhost',
                    user=user_name,
                    password=passwd,
                    db='rbstore',
                    charset='utf8mb4',
                    cursorclass=pymysql.cursors.DictCursor
                )
                self.cur = self.cnx.cursor()
                break

            except pymysql.err.OperationalError as e:
                # Access denied error
                if e.args[0] == 1045:
                    print('Invalid username or password, please try again.')
                else:
                    print('Connection failed, Error: %d: %s' % (e.args[0], e.args[1]))
                    print('Connection failed:{}'.format(e))
                    exit()

        return self.cur, self.cnx

    def sign_up(self):
        new_user = "new_user"
        new_password = "new_password"
        # Create a new user and set the password
        self.cur.execute(f"CREATE USER '{new_user}'@'%' IDENTIFIED BY '{new_password}';")
        self.cnx.commit()
        print(f"User '{new_user}' created with password '{new_password}'.")

    @staticmethod
    def prompt_user_interface():
        print('------------ Welcome To Sale System ------------')
        print('Please Enter Number To Goto Your Windows:')
        print('[1]: Sign Up (If You Do Not Have A Account.)')
        print('[2]: Login')

    def user_choice(self):
        user_input = input('Enter your choice: ')
        match user_input:
            case '1':
                self.sign_up()
            case '2':
                self.login(self)
            case _:
                print('Error Select, Please Select Again. (ONLY [1] and [2] OPTIONS.)')
        return user_input

    @staticmethod
    def login(self):
        if self.work():
            print("You have successfully logged in.")
        else:
            print('Invalid username or password, please try again.')

    def main(self):
        self.prompt_user_interface()
        self.user_choice()



if __name__ == '__main__':
    database = DatabaseConnection()
    database.main()
