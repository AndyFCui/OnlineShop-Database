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

    def __init__(self):
        self.cur = None  # cur is the cursor of the database (MySQL)
        self.cnx = None  # cnx is the connection of the database (MySQL)
        self.status = False
        self.default_account = 'root'  # 'default_account'
        self.default_passwd = 'Db@5822900'  # 'rbstore_guest'
        self.cnx_connection()
        self.current_operator = None

    def cnx_connection(self):
        try:
            self.cnx = pymysql.connect(
                host='localhost',
                user=self.default_account,
                password=self.default_passwd,
                db='rbstore',
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
            self.cur = self.cnx.cursor()
            self.status = True
            print('[Status] Connect To Database Successful.')

        except pymysql.err.OperationalError as e:
            # Access denied error
            if e.args[0] == 1045:
                print('Invalid username or password, please try again.')
            else:
                self.status = False
                print('[ERROR] Connection Failed, Error: %d: %s' % (e.args[0], e.args[1]))
                print('[Status] Connection Failed:{}'.format(e))

    def sign_up(self):
        # new_user = input("new_user: ", )
        # new_password = input("passwd: ")
        # Create a new user and set the password
        # query = "CREATE USER %s@'localhost' IDENTIFIED BY %s"
        # self.cur.execute(query, (new_user, new_password))
        # self.cnx.commit()
        print('Please Enter Info For Sign Up:')
        new_user = input('new_user: ', )
        new_password = input('passwd: ')
        new_name = input('your name: ')
        new_address = input('your address: ')
        new_phone = input('your phone number: ')
        new_sex = input('your sex: ')
        new_date_birth = input('your birth(year-mm-dd): ')

        self.cur.callproc('create_account',
                          [new_user,
                           new_password,
                           new_name,
                           new_address,
                           new_phone,
                           new_sex,
                           new_date_birth])
        self.cnx.commit()
        print(f"User '{new_user}' created with password '{new_password}'.")

        # Close guest account, and prepare to connect new account
        self.status = False
        self.cur.close()
        self.cnx.close()

        # Login new account
        self.login(self)

    @staticmethod
    def prompt_user_interface(self):
        if self.status is True:
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
    def welcome(user_name):
        print("[%s] Welcome to use Robot Sale System" % user_name)
        print("You have successfully logged in.")

    @staticmethod
    def login(self):
        print("### Please Login With Your Username and Password ###")
        user_name = input("username: ")
        passwd = input("password: ")

        self.default_account = user_name
        self.default_passwd = passwd
        self.cnx_connection()

        if self.status is True:
            self.welcome(user_name)
            self.current_operator = user_name
            self.control_panel()

    @staticmethod
    def control_panel():
        print('###########################################')
        print('####-- Robot Sale Sys Control Panel  --####')
        print('###########################################')
        print('->[1] Fill Order                          #')
        print('->[2] Return Order                        #')
        print('->[3] Data Management')
        print('###########################################')

    def control_panel_function(self):
            print('Please Enter Number To Select Operate:(Please with out [], ONLY NUMBER.)')
            user_select = input("->")
            match user_select:
                case '1':
                    self.order()
                case '2':
                    self.return_order()
                case '3':
                    self.data_management()
                case _:
                    print('Error Select, Please Select Again. (ONLY [1] [2] and [3] OPTIONS.)')

    def order(self):
        print('Please Enter Order Info:')
        order_date = input('Order Date:')
        status_select = input(
                             '[1]: Order,'
                             '[2]: Return Request, '
        )

        while True:
            match status_select:
                case '1':
                    order_status = 'Order'
                    break
                case '2':
                    order_status = 'Return Request'
                    break
                case _:
                    print('Error Select, Please Select Again. (ONLY [1] and [2] OPTIONS.)')
                    break

        preference_select = input('[1]: Overnight Delivery, '
                                  '[2]: Regular Delivery')
        while True:
            match preference_select:
                case '1':
                    preference = 'Overnight Delivery'
                    break
                case '2':
                    preference = 'Regular Delivery'
                    break
                case _:
                    print('Error Select, Please Select Again. (ONLY [1] and [2] OPTIONS.)')
                    break

        self.cur.execute("SET @operator_id_out = 0")
        self.cur.callproc('get_id', [self.current_operator, "@operator_id_out"])
        self.cur.execute("SELECT @operator_id_out")
        operator_id = self.cur.fetchone()[0]
        self.cnx.commit()
        self.cur.callproc('order_create',
                          order_date,
                          order_status,
                          preference,
                          operator_id
                          )
        self.cnx.commit()

    @staticmethod
    def order_list():
        print('###########################################')
        print('####-- Robot Sale Sys Order Panel  --####')
        print('###########################################')
        print('->[1] Refund                              #')
        print('->[2] Refund & Return Product             #')
        print('->[3] Exchange                            #')
        print('->[4] Return Pre Menu                     #')
        print('###########################################')

    def order_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                user_select = 'Refund'
            case '2':
                user_select = 'Refund & Return Product'
            case '3':
                user_select = 'Exchange'
            case '4':
                user_select = 'Return Pre Menu'
            case _:
                print('Error Select, Please Select Again.')

    def return_order(self):
        self.order_list()
        self.order_options()
        # TO DO Procedure

    @staticmethod
    def management_list():
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel  --##')
        print('###########################################')
        print('->[1] Storage Management                  #')
        print('->[2] Edit Operator Info                  #')
        print('->[3] Edit Customer Info                  #')
        print('->[4] Edit Robot Info                     #')
        print('###########################################')

    def edit_customer_info(self):
        print('###########################################')
        print('##-- Robot Sale Sys Management Panel  --##')
        print('##-- Edit Customer Info  --##')
        print('###########################################')
        print('->[1] Create                              #')
        print('->[2] Update                              #')
        print('->[3] Delete                              #')
        print('->[4] Add Card                            #')
        print('###########################################')

        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.create_cus_info()
            case '2':
                self.create_update_info()
            case '3':
                self.create_del_info()
            case '4':
                self.create_add_card()
            case _:
                print('Error Select, Please Select Again.')

    def create_cus_info(self):
        print('Call procedure')


    def management_options(self):
        print('Please Enter Number To Select Options:')
        user_select = input('->')
        match user_select:
            case '1':
                self.storage_mangement()
            case '2':
                self.edit_operator_info()
            case '3':
                self.edit_customer_info()
            case '4':
                self.edit_robot_info()
            case _:
                print('Error Select, Please Select Again.')

    # To Do
    def data_management(self):
        self.management_list()
        self.management_options()
        print('Call procedure')

    def main(self):
        self.prompt_user_interface(self)
        if self.status is True:
            self.user_choice()
            self.control_panel_function()


if __name__ == '__main__':
    database = DatabaseConnection()
    database.main()
