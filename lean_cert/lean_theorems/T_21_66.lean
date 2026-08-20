import Sound
import lean_certs.cert_21_66

open CertVerify

theorem H21_gt_66 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 21) (d := 66) (c := cert_21_66) (by native_decide)
