import Sound
import lean_certs.cert_21_46

open CertVerify

theorem H21_gt_46 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 21) (d := 46) (c := cert_21_46) (by native_decide)
