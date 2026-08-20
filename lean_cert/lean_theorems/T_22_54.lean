import Sound
import lean_certs.cert_22_54

open CertVerify

theorem H22_gt_54 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 22) (d := 54) (c := cert_22_54) (by native_decide)
