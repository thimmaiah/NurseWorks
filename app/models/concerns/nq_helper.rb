module NqHelper

    # Maps for scores used for various nurse attributes
    # Ex nurse with Bsc gets 20 points from QUALIFICATIONS x 10% from weights
    # Ex nurse with expeience > 15 gets 17 points from EXPERIENCE x 15% from weights
    # Each attribute is weighted - see the WEIGHTS map
    # The NQ score is the sum of weighted scores for all attributes
    

    QUALIFICATIONS = {
        "A&M Nurse" => -100, 
        "G&M / Diploma Nurse" => 10, 
        "BSc Nursing" => 20, 
        "MSc Nursing / PhD" =>25, 
        "Student in Nursing" => 5
    }

    EXPERIENCE = {
        "< 5" => 2,
        "5 - 10" => 8,
        "11 - 15" => 12,
        "> 15" => 17
    }

    SPECIALIZATIONS = {
        "Other" => 0,
        "Medical wards/other" => 3,
        "Maternity and Pediatric wards" => 6,
        "Mental health / Psychiatric ward" => 10,
        "Ortho / Surgical wards" =>	10,
        "OT nurse" => 15,
        "Higher end specialty (ICU / CCU / Onco care)" => 18
    }

    LOCUM = {
        "Yes" => 15,
        "No" => 0
    }

    LOCUM_SHIFTS_PER_MONTH = {
        "None" => 0,
        "1 - 4" => 5,
        "5 - 10" => 10,
        "> 10" => 20
    }

    SCHOOL = {
        "Rated" => 10,
        "UnRated" => 0
    }

    NUID = {
        "Valid" => 25,
        "Invalid" => 0
    }

    WEIGHTS = {
        QUALIFICATIONS => 0.10,
        EXPERIENCE => 0.15,
        SPECIALIZATIONS => 0.20,
        LOCUM => 0.15,
        LOCUM_SHIFTS_PER_MONTH => 0.20,
        SCHOOL => 0.05,
        NUID => 0.15
    }


    def self.experience_in_words(e)
        case e
            when 0..4
                "< 5"
            when 5..10
                "5 - 10"
            when 10..15
                "11 - 15"
            when 15..100
                "> 15"
        end
    end

    def self.avail_part_time_shifts_in_words(e)
        case e
            when 0
                "None"
            when 1..4
                "1 - 4"
            when 5..10
                "5 - 10"
            when 11..100
                "> 10"
        end
    end

    # Computes the dynamic score based on shifts and hours worked etc
    def self.dynamic_score(nurse)
        0
    end

    # https://stats.stackexchange.com/questions/70801/how-to-normalize-data-to-0-1-range
    def self.normalize_scores
        max = User.temps.maximum("nq_score")
        min = User.temps.minimum("nq_score")
        User.temps.each do |u|
            norm = 1.0 * (u.nq_score - min)/(max - min)
            u.nq_score_normalized = (norm * 100).ceil
            u.save
        end
    end

    # Recomputes the base and dynamic scores for all temp staff
    def self.recompute_scores
        User.temps.each do |u|
            u.nq_score_base, audit = base_score(u)
            u.nq_score_dynamic = dynamic_score(u)
            Rails.logger.debug "#{u.nq_score_base} + #{u.nq_score_dynamic}"
            u.nq_score = u.nq_score_base + u.nq_score_dynamic
            u.save
        end
    end

    # Computes the base score based on the criteria specified
    # https://docs.google.com/spreadsheets/d/1S2fgwiRQzBdpnOLs62tgZ3E-lbFsZcOFEjPVtMad5uA/edit#gid=0
    def self.base_score(nurse)
        Rails.logger.debug("\nProcessing user #{nurse.id}")
        cal_audit = {}
        qual_score = QUALIFICATIONS[nurse.key_qualifications] * WEIGHTS[QUALIFICATIONS]
        cal_audit["QUALIFICATIONS"] = "#{nurse.key_qualifications}: #{QUALIFICATIONS[nurse.key_qualifications]} x #{WEIGHTS[QUALIFICATIONS]} "
        # Nurse can have multiple specializations
        # Grab the one which has the highest score
        highest_spz = "N/A"
        highest_spz_val = 0
        nurse.specializations.each do |curr_spz|
            if curr_spz.present?
                curr_val = SPECIALIZATIONS[curr_spz]
                Rails.logger.debug "###  #{curr_spz} #{curr_val} > #{highest_spz} #{highest_spz_val}"
                highest_spz = (curr_val && curr_val > highest_spz_val) ? curr_spz : highest_spz 
                highest_spz_val ||= SPECIALIZATIONS[highest_spz]
            end
        end

        specialization_score = SPECIALIZATIONS[highest_spz] * WEIGHTS[SPECIALIZATIONS]
        cal_audit["SPECIALIZATIONS"] = "#{highest_spz}: #{SPECIALIZATIONS[highest_spz]} x #{WEIGHTS[SPECIALIZATIONS]}" 

        l = nurse.avail_part_time ? "Yes" : "No"
        avail_part_time_score = LOCUM[l] * WEIGHTS[LOCUM]
        cal_audit["LOCUM"] = "Locum #{l}: #{LOCUM[l]} x #{WEIGHTS[LOCUM]}"

        lspm = avail_part_time_shifts_in_words(nurse.shifts_per_month)
        avail_part_time_spm_score = LOCUM_SHIFTS_PER_MONTH[lspm] * WEIGHTS[LOCUM_SHIFTS_PER_MONTH]
        cal_audit["LOCUM_SHIFTS_PER_MONTH"] = "#{lspm}: #{LOCUM_SHIFTS_PER_MONTH[lspm]} x #{WEIGHTS[LOCUM_SHIFTS_PER_MONTH]}"


        ew = experience_in_words(nurse.years_of_exp)
        experience_score = EXPERIENCE[ew] * WEIGHTS[EXPERIENCE]
        cal_audit["EXPERIENCE"] = "#{ew} Years: #{EXPERIENCE[ew]} x #{WEIGHTS[EXPERIENCE]}"

        school = School.find_by_name(nurse.nursing_school_name)
        rated = school ? "Rated" : "UnRated"
        school_score = SCHOOL[rated] * WEIGHTS[SCHOOL]
        cal_audit["SCHOOL"] = "#{nurse.nursing_school_name} #{rated}: #{SCHOOL[rated]} x #{WEIGHTS[SCHOOL]}"
        
        v = nurse.nuid_valid ? "Valid" : "Invalid"
        nuid_score = NUID[v] * WEIGHTS[NUID]
        cal_audit["NUID"] = "#{nurse.NUID} #{v}: #{NUID[v]} x #{WEIGHTS[NUID]}"

        base =  (qual_score + specialization_score + 
                avail_part_time_score + avail_part_time_spm_score + experience_score + 
                school_score + nuid_score).ceil
                
        return base, cal_audit
    end

end