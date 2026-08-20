import Sound
import lean_certs.cert_22_66

open CertVerify

theorem H22_gt_66 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 22) (d := 66) (c := cert_22_66) (by native_decide)
