import Sound
import lean_certs.cert_18_66

open CertVerify

theorem H18_gt_66 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 18) (d := 66) (c := cert_18_66) (by native_decide)
