import random
    """
    Generate random completeness values and save them to a file.

    Parameters:
        num (int): The number of completeness values to generate.

    Returns:
        None
    """
def generate_completeness_values(num):
    with open("completeness_values.txt", "w") as file:
        for _ in range(num):
            completeness = round(random.uniform(40, 100), 2)
            file.write(str(completeness) + "\n")

if __name__ == "__main__":
    try:
        num = int(input("Enter the number of completeness values to generate: "))
        generate_completeness_values(num)
        print(f"{num} completeness values generated and saved to 'completeness_values.txt'.")
    except ValueError:
        print("Please enter a valid integer.")
