import re


def multiple_replace(text, adict):
    rx = re.compile('|'.join(map(re.escape, adict)))

    def one_xlat(match):
        return adict[match.group(0)]
    return rx.sub(one_xlat, text)


def repair_column_series_census_metadata(table_number, column_name, column_heading):
    if table_number == "p16":
        column_number = int(column_name[1:])
        # These are mislabelled as part of the FEMALES series
        if column_number >= 2994 and column_number <= 3003:
            column_heading = column_heading.replace("|FEMALES", "|MALES")
        # These are mislabelled as part of the PERSONS series
        elif column_number >= 3074 and column_number <= 3083:
            column_heading = column_heading.replace("|PERSONS", "|FEMALES")
    elif table_number == "t18":
        if column_name == "t7780":
            column_heading = "Other dwelling|2011 CENSUS"
    return column_heading


def repair_census_metadata(table_number, column_name, metadata):
    if table_number == "b18":
        metadata["kind"] = metadata["kind"].replace("No need for assistance", "Does not have need for assistance")
    elif table_number == "b24":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One child",
            ": 2": " Two children",
            ": 3": " Three children",
            ": 4": " Four children",
            ": 5": " Five children",
            ": 6 or more": " Six or more children",
            ": None": " No children",
        })
    elif table_number == "b36":
        metadata["kind"] = metadata["kind"].replace("Six bedrooms or more", "Six or more bedrooms")

    elif table_number == "i02":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            "Indigenous: Total ": "",
            "Non-Indigenous ": "",
            "Indigenous status not stated: ": "",
            "Total ": "",
        })
    elif table_number == "i08":
        metadata["kind"] = metadata["kind"].replace("No need for assistance", "Does not have need for assistance")
    elif table_number == "i11":
        metadata["kind"] = metadata["kind"].replace("Indigenous households", "Households with Indigenous persons")
    elif table_number == "i12":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One",
            ": 2": " Two",
            ": 3": " Three",
            ": 4": " Four",
            ": 5": " Five",
            ": 6 or more": " Six or more",
        })
    elif table_number == "i15":
        metadata["type"] = metadata["type"].replace("Certificatel", "Certificate")
    elif table_number == "p16":
        column_number = int(column_name[1:])
        # These are mislabelled as part of the FEMALES series
        if column_number >= 2994 and column_number <= 3003:
            metadata["kind"] = metadata["kind"].replace("|FEMALES", "|MALES")
        # These are mislabelled as part of the PERSONS series
        elif column_number >= 3074 and column_number <= 3083:
            metadata["kind"] = metadata["kind"].replace("|PERSONS", "|FEMALES")
    elif table_number == "p18":
        metadata["kind"] = metadata["kind"].replace("vistors", "visitors")
    elif table_number == "p19":
        metadata["kind"] = metadata["kind"].replace("vistors", "visitors")
        metadata["kind"] = multiple_replace(metadata["kind"], {
            "vistors": "visitors",
            "Voluntary work not stated": "Voluntary work for an organisation or group Not stated",
        })
    elif table_number == "p20":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            "Unpaid domestic work not stated": "Unpaid domestic work number of hours Not stated",
            "Did unpaid domestic work: ": "Unpaid domestic work number of hours ",
        })
    elif table_number == "p21":
        metadata["kind"] = metadata["kind"].replace("Unpaid assistance not stated", "Unpaid assistance to a person with a disability Not stated")
    elif table_number == "p22":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            "Cared for: Own child/children only": "Unpaid child care Cared for own child children",
            "Cared for: Other child/children only": "Unpaid child care Cared for other child children",
            "Cared for: Total": "Unpaid child care Cared for child children Total",
        })
    elif table_number == "p24":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One child",
            ": 2": " Two children",
            ": 3": " Three children",
            ": 4": " Four children",
            ": 5": " Five children",
            ": 6 or more": " Six or more children",
            ": None": " No children",
        })
    elif table_number == "x07":
        metadata["kind"] = metadata["kind"].replace("BIRTHPLACE OF PARENT/S NOT STATED", "Birthplace of parents not stated")
    elif table_number == "x17":
        metadata["kind"] = metadata["kind"].replace("Landlord type: Landlord type not stated", "Landlord type not stated")
    elif table_number == "x18":
        metadata["kind"] = metadata["kind"].replace("Landlord type: Landlord type not stated", "Landlord type not stated")
    elif table_number == "x24":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            "etc:": "etc with",
            "Dwelling structure: Dwelling structure not stated": "Dwelling structure not stated",
        })
    elif table_number == "x38":
        metadata["kind"] = metadata["kind"].replace("49 and over", "49 hours and over")
    elif table_number == "x39":
        metadata["kind"] = metadata["kind"].replace("49 and over", "49 hours and over")
    elif table_number == "x42":
        metadata["kind"] = metadata["kind"].replace("Unemployed, looking for work: ", "Unemployed looking for ")
    elif table_number == "t07":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One child",
            ": 2": " Two children",
            ": 3": " Three children",
            ": 4": " Four children",
            ": 5": " Five children",
            ": 6 or more": " Six or more children",
            ": None": " No children",
        })
    elif table_number == "t15":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One",
            ": 2": " Two",
            ": 3": " Three",
            ": 4": " Four",
            ": 5": " Five",
            ": 6 or more": " Six or more",
        })
    elif table_number == "t16":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One",
            ": 2": " in family households Two",
            ": 3": " in family households Three",
            ": 4": " in family households Four",
            ": 5": " in family households Five",
            ": 6 or more": " in family households Six or more",
        })
    elif table_number == "t17":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One",
            ": 2": " in group households Two",
            ": 3": " in group households Three",
            ": 4": " in group households Four",
            ": 5": " in group households Five",
            ": 6 or more": " in group households Six or more",
        })
    elif table_number == "t18":
        if column_name == "t7780":
            metadata["kind"] = "Other dwelling|2011 CENSUS"
    elif table_number == "t22":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One",
            ": 2": " Two",
            ": 3": " Three",
            ": 4 or more": " Four or more",
        })
    elif table_number == "t23":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One",
            ": 2": " Two",
            ": 3": " Three",
            ": 4 or more": " Four or more",
        })
    elif table_number == "t25":
        metadata["type"] = multiple_replace(metadata["type"], {
            "_0_299": "_1_299",
        })
    elif table_number == "t27":
        metadata["kind"] = multiple_replace(metadata["kind"], {
            ": 1": " One",
            ": 2": " Two",
            ": 3": " Three",
            ": 4 or more": " Four or more",
        })
    elif table_number == "w12":
        metadata["kind"] = metadata["kind"].replace("Occupation inadequately", "inadequately")
    elif table_number == "w19":
        metadata["kind"] = metadata["kind"].replace(" STUDENTS", " STUDENT")
    elif table_number == "w23":
        metadata["kind"] = metadata["kind"].replace("Institutions:", "Institution:")
    return metadata
